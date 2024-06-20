package bit.naver.controller;

import bit.naver.entity.CommentsEntity;
import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.StudyReferencesService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.util.List;

// StudyReferencesController 클래스: 클라이언트의 요청을 처리하는 컨트롤러 계층
@Controller
@RequestMapping("/studyReferences")
@RequiredArgsConstructor
public class StudyReferencesController {
    @Autowired
    private UsersMapper usersMapper;

    private final UsersUserDetailsService usersUserDetailsService;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private StudyReferencesService studyReferencesService;

    @RequestMapping("/referencesList")
    public String getStudyReferencesList(Model model, @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                         @RequestParam(value = "searchOption", required = false) String searchOption,
                                         @RequestParam(value = "limits", required = false, defaultValue = "5") String limits,
                                         HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        String userIdx = String.valueOf(user != null ? user.getUserIdx() : 59); // 사용자 ID 가져오기
        List<StudyReferencesEntity> studyReferencesEntity = studyReferencesService.getStudyReferencesList(userIdx, searchKeyword, searchOption, limits);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("userIdx", userIdx); //나중에 59만 로그인한사람의 userIdx로 바꿔주기
        model.addAttribute("limits", limits);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);

        return "/studyReferences/referencesList";
    }

    @RequestMapping("/referencesRead")
    public String getStudyReferencesRead(Model model, @RequestParam("referenceIdx") Long referenceIdx, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        String userIdx = String.valueOf(user.getUserIdx()); // 사용자 ID 가져오기
        StudyReferencesEntity studyReferencesEntity = studyReferencesService.getStudyReferenceById(referenceIdx, userIdx);
        List<CommentsEntity> studyRefencesComment = studyReferencesService.getCommentsByReferenceIdx(referenceIdx);

        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("studyRefencesComment", studyRefencesComment);
        model.addAttribute("userIdx", userIdx); //나중에 59만 로그인한사람의 userIdx로 바꿔주기

        return "/studyReferences/referencesRead";
    }

    @RequestMapping("/deleteComment")
    @ResponseBody
    public String deleteComment(@RequestParam("commentIdx") String commentIdx) {
        //System.out.println("comment Idx >>> " + commentIdx); 값 제대로 넘어오는지 확인하기 위해
        return studyReferencesService.deleteComment(commentIdx);
    }

    @RequestMapping("/insertComment")
    @ResponseBody
    public String insertComment(@ModelAttribute CommentsEntity content, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
        content.setUserIdx(userIdx); //임의로 userIdx값 줌
        return studyReferencesService.insertComment(content);
    }

    @RequestMapping("/insertLike")
    @ResponseBody
    public int insertLike(@ModelAttribute LikeReferencesEntity entity) {
        //System.out.println("ENTITY >>>" + entity.toString());
        return studyReferencesService.insertLike(entity);
    }

    @RequestMapping("/deleteLike")
    @ResponseBody
    public int deleteLike(@ModelAttribute LikeReferencesEntity entity) {
        //System.out.println("ENTITY >>>" + entity.toString());
        return studyReferencesService.deleteLike(entity);
    }

    @RequestMapping("/updateReport")
    @ResponseBody
    public int updateReport(@ModelAttribute StudyReferencesEntity entity) {
        return studyReferencesService.updateReport(entity);
    }

    @GetMapping("/referencesWrite")
    public String referencesWrite(@ModelAttribute StudyReferencesEntity entity) {
        return "/studyReferences/referencesWrite";
    }

    @PostMapping("/referencesWrite")
    @ResponseBody
    public Long submitPost(@ModelAttribute StudyReferencesEntity entity, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
        entity.setUserIdx(userIdx);

        return studyReferencesService.writePost(entity);
    }

    @RequestMapping("/deletePost")
    @ResponseBody
    public int deletePost(@RequestParam("referenceIdx") int referenceIdx) {
        System.out.println("referenceIdx: " + referenceIdx);
        return studyReferencesService.deletePost(referenceIdx);
    }

    @RequestMapping("/referencesModify")
    public String modifyPost(Model model, @ModelAttribute StudyReferencesEntity entity, HttpSession session) {
        System.out.println("entity: " + entity);
        Users user = (Users) session.getAttribute("userVo");
        String userIdx = String.valueOf(user.getUserIdx()); // 사용자 ID 가져오기
        StudyReferencesEntity studyReferencesEntity = studyReferencesService.getStudyReferenceById(entity.getReferenceIdx(), userIdx);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);

        return "/studyReferences/referencesModify";
    }

    @RequestMapping("/updatePost")
    @ResponseBody
    public int updatePost(@ModelAttribute StudyReferencesEntity entity) {
        return studyReferencesService.updatePost(entity);
    }

    @GetMapping("/referencesSite")
    public String referencesSite(@ModelAttribute StudyReferencesEntity entity) {
        return "/studyReferences/referencesSite";
    }

}
