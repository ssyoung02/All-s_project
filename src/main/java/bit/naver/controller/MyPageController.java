package bit.naver.controller;

import bit.naver.entity.*;
import bit.naver.mapper.StudyRecruitMapper;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.MyPageService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/myPage")
@RequiredArgsConstructor
public class MyPageController {

    @Autowired
    private UsersMapper usersMapper;

    private final UsersUserDetailsService usersUserDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MyPageService myPageService;

    @Autowired
    private StudyRecruitMapper studyMapper;

    @Value("${kakao.map.api.key}") // application.properties에서 API 키 값 가져오기
    private String kakaoMapApiKey;

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    @RequestMapping("/myPageInfo")
    public String getMyPageInfo(Model model, HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);

        StudyReferencesEntity entity = new StudyReferencesEntity();
        entity.setUserIdx(user.getUserIdx());

        ResumesEntity entity2 = new ResumesEntity();
        entity2.setUserIdx(user.getUserIdx());

        List<StudyReferencesEntity> studyReferencesEntity = myPageService.getStudyReferencesList(entity);
        List<ResumesEntity> resumesEntity = myPageService.getResumesList(entity2);


        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("resumesEntity", resumesEntity);
        model.addAttribute("user", user);

        LocalDateTime createdAtDateTime = user.getCreatedAt(); // 예시: Users 엔티티에 getCreatedAt() 메서드가 있어야 함
        String formattedCreatedAt = createdAtDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        model.addAttribute("formattedCreatedAt", formattedCreatedAt); // 변환된 createdAt을 모델에 추가

        session.setAttribute("userVo", user);

        long userIdx = user.getUserIdx();

        List<StudyGroup> likedStudies = studyMapper.getUserLikedStudies(userIdx);
        model.addAttribute("likedStudies", likedStudies);

        model.addAttribute("kakaoMapApiKey", kakaoMapApiKey); // API 키를 모델에 추가

        return "/myPage/myPageInfo";
    }

    @RequestMapping("/myPageLikePost")
    public String getLikePostList(Model model, @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                         @RequestParam(value = "searchOption", required = false) String searchOption,
                                         @RequestParam(value = "limits", required = false, defaultValue = "5") String limits,
                                         HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        String userIdx = String.valueOf(user != null ? user.getUserIdx() : 59); // 사용자 ID 가져오기
        List<StudyReferencesEntity> studyReferencesEntity = myPageService.getLikePostList(userIdx, searchKeyword, searchOption, limits);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("limits", limits);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);

        return "/myPage/myPageLikePost";
    }

    @RequestMapping("/insertLike")
    @ResponseBody
    public int insertLike(@ModelAttribute LikeReferencesEntity entity) {
        return myPageService.insertLike(entity);
    }

    @RequestMapping("/deleteLike")
    @ResponseBody
    public int deleteLike(@ModelAttribute LikeReferencesEntity entity) {
        return myPageService.deleteLike(entity);
    }

    @PostMapping("/uploadResume")
    @ResponseBody
    public Long uploadResume(@ModelAttribute StudyReferencesEntity entity1, @ModelAttribute ResumesEntity entity, MultipartFile uploadFile, HttpSession session,
                             HttpServletResponse response) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
        entity.setUserIdx(userIdx);

        if (uploadFile.getSize() > MAX_FILE_SIZE) {
            return 10L;
        }

        try {
            entity.setFileName(URLEncoder.encode(uploadFile.getOriginalFilename(), "UTF-8").replaceAll("\\+", "%20"));
            entity.setResumePath(uploadFile.getBytes());
        } catch (IOException e) {
            e.printStackTrace();
            return -1L;
        }

        return myPageService.uploadResume(entity, uploadFile);
    }


    @GetMapping(value = "/download")
    public void fileDownload(@RequestParam("resumeIdx") Long resumeIdx, HttpSession session,
                             HttpServletResponse response) throws UnsupportedEncodingException {
        Users user = (Users) session.getAttribute("userVo");
        String userIdx = String.valueOf(user.getUserIdx());
        ResumesEntity entity = myPageService.getMyPageById(resumeIdx);
        String fileName = entity.getFileName();
        String mimeType = "application/octet-stream";

        try {
            Path filePath = Paths.get("path/to/files/" + fileName); // 실제 파일 경로로 변경
            mimeType = Files.probeContentType(filePath);
        } catch (IOException e) {
            e.printStackTrace();
        }

        response.setContentType(mimeType);

        // 파일 이름에 한글이 포함된 경우를 대비해 인코딩 처리
        String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString()).replaceAll("\\+", "%20");

        // Content-Disposition 헤더 수정
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName);

        try (InputStream inputStream = new ByteArrayInputStream(entity.getResumePath());
             OutputStream outputStream = response.getOutputStream()) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/deleteResume")
    @ResponseBody
    public String deleteResume(@RequestParam("resumeIdx") String resumeIdx) {
        return myPageService.deleteResume(resumeIdx);
    }

    @RequestMapping("/myPageLikeStudy")
    public String getUserLikedStudies(@RequestParam("userIdx") long userIdx, Model model) {
        List<StudyGroup> likedStudies = studyMapper.getUserLikedStudies(userIdx);
        model.addAttribute("likedStudies", likedStudies);
        return "/myPage/myPageLikeStudy";
    }
}
