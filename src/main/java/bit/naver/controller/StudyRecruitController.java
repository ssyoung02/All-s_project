package bit.naver.controller;

import bit.naver.entity.*;
import bit.naver.mapper.NotificationMapper;
import bit.naver.mapper.StudyGroupMapper;
import bit.naver.mapper.StudyRecruitMapper;
import bit.naver.mapper.UsersMapper;
import bit.naver.service.StudyRecruitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/studyRecruit")
public class StudyRecruitController {

    @Autowired
    private StudyRecruitMapper studyMapper;

    @Autowired
    private StudyRecruitService studyService;

    @Autowired
    private UsersMapper usersMapper;

    @Autowired
    private StudyGroupMapper groupMapper;

    @Autowired
    private NotificationMapper notificationMapper;

    // 모집글 리스트
    @RequestMapping("/recruitList")
    public String getAllStudies(@RequestParam(defaultValue = "1") int page,
                                @RequestParam(defaultValue = "RECRUITING") String status,
                                @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                @RequestParam(value = "searchOption", required = false) String searchOption,
                                Model model,
                                HttpSession session,
                                Principal principal) {

        Users user = (Users) session.getAttribute("userVo");
        String username = principal.getName();
        Users users = usersMapper.findByUsername(username);
        Long userIdx = Long.valueOf(users != null ? users.getUserIdx() : 59);

        int pageSize = 10; // 페이지당 스터디 수
        int offset = (page - 1) * pageSize;

//        // Get studies with userIdx as a parameter
//        List<StudyGroup> studies = studyMapper.getAllStudies(userIdx,searchKeyword, searchOption);
//        model.addAttribute("searchKeyword", searchKeyword);
//        model.addAttribute("searchOption", searchOption);


        // Get studies with userIdx as a parameter
        List<StudyGroup> studies = studyMapper.getStudiesPaged(userIdx, status, offset, pageSize);
        for (StudyGroup study : studies) {
            study.setCurrentParticipants(studyMapper.getCurrentParticipants(study.getStudyIdx()));
            studyMapper.closeStudyIfFull(study.getStudyIdx()); // Close the study if it's full
        }

        int totalStudies = studyMapper.countAllStudies(userIdx, status);
        int totalPages = (int) Math.ceil((double) totalStudies / pageSize);

        // 페이지 네비게이션 처리
        int startPage = Math.max(1, page - 5);
        int endPage = Math.min(startPage + 9, totalPages);

        model.addAttribute("userIdx", userIdx);
        model.addAttribute("studies", studies);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("status", status);

        List<StudyGroup> study_18 = studyMapper.getAllStudy_9(userIdx);
        for (StudyGroup study : study_18) {
            study.setCurrentParticipants(studyMapper.getCurrentParticipants(study.getStudyIdx()));
            studyMapper.closeStudyIfFull(study.getStudyIdx()); // Close the study if it's full
        }
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("study_18", study_18);

        return "studyRecruit/recruitList"; // recruitList.jsp로 이동
    }

    // 신청가입리스트?
    @GetMapping("/recruitReadForm")
    public String getStudyDetail(@RequestParam("studyIdx") Long studyIdx, Model model, HttpSession session, Principal principal) {
        String username = principal.getName();
        Users users = usersMapper.findByUsername(username);
        long userIdx = users != null ? users.getUserIdx() : 59;

        // 스터디 상세 정보 조회
        StudyGroup study = studyMapper.getStudyById(studyIdx, userIdx);
        List<StudyMembers> members = studyMapper.getStudyMembersByStudyId(studyIdx);

        boolean isMember = studyMapper.isMember(studyIdx, userIdx);
        boolean isPending = studyMapper.isPending(studyIdx, userIdx);


        boolean isLeaderOrAccepted = study.getStudyLeaderIdx() == userIdx || isMember;

        model.addAttribute("study", study);
        model.addAttribute("members", members);
        model.addAttribute("isMember", isMember);
        model.addAttribute("isPending", isPending);
        model.addAttribute("isLeaderOrAccepted", isLeaderOrAccepted);


        return "studyRecruit/recruitReadForm";
    }

    // 스터디 가입 신청서 제출
    @PostMapping("/apply")
    public String applyForStudy(@RequestParam("studyIdx") Long studyIdx,
                                @RequestParam("joinReason") String joinReason,
                                HttpSession session, Principal principal) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기

        StudyMembers studyMember = new StudyMembers();
        studyMember.setStudyIdx(studyIdx);
        studyMember.setUserIdx(userIdx);
        studyMember.setRole("MEMBER");
        studyMember.setStatus("PENDING");
        studyMember.setJoinReason(joinReason.isEmpty() ? "신청내용이 없습니다" : joinReason);
        studyMember.setCreatedAt(LocalDateTime.now());
        studyMember.setUpdatedAt(LocalDateTime.now());

        studyMapper.insertStudyMember(studyMember);

        Long leaderIdx = groupMapper.getStudyLeaderIdx(studyIdx);

        NotificationEntity notification = new NotificationEntity();
        notification.setStudyIdx(studyIdx);
        notification.setLeaderIdx(leaderIdx);
        notification.setNotifyType(NotificationEntity.NotifyType.valueOf("STUDY_INVITE"));
        notification.setCreatedAt(LocalDateTime.now());

        notificationMapper.createNotification(notification);

        return "redirect:/studyRecruit/recruitList";
    }

    // 스터디 멤버 상태 업데이트
    @PostMapping("/updateMemberStatus")
    public String updateMemberStatus(@RequestParam("studyIdx") Long studyIdx, @RequestParam("userIdx") Long userIdx, @RequestParam("status") String status) {
        studyMapper.updateStudyMemberStatus(studyIdx, userIdx, status);
        return "redirect:/studyRecruit/recruitReadForm?studyIdx=" + studyIdx;
    }

    @RequestMapping("/insertLike")
    @ResponseBody
    public int insertLike(@ModelAttribute LikeStudyEntity entity) {
        return studyService.insertLike(entity);
    }

    @RequestMapping("/deleteLike")
    @ResponseBody
    public int deleteLike(@ModelAttribute LikeStudyEntity entity) {

        return studyService.deleteLike(entity);
    }

    @RequestMapping("/updateReport")
    @ResponseBody
    public int updateReport(@ModelAttribute StudyGroup entity) {
        return studyService.updateReport(entity);
    }

    // 멤버 목록 가져오기
    @GetMapping("/studyGroupManagerMember")
    public String getStudyMembers(@RequestParam("studyIdx") Long studyIdx, Model model) {
        List<StudyMembers> members = studyMapper.getMembersByStudyIdx(studyIdx);
        for (StudyMembers member : members) {
            System.out.println(member);
        }
        model.addAttribute("members", members);
        return "studyGroup/studyGroupManagerMember";
    }

    // 스터디 정보 업데이트
    @PostMapping("/updateStudyGroup")
    public String updateStudyGroup(@RequestParam("studyIdx") Long studyIdx,
                                   @RequestParam("studyTitle") String studyTitle,
                                   @RequestParam("description") String description,
                                   @RequestParam("category") String category,
                                   @RequestParam("age") String age,
                                   @RequestParam("gender") String gender,
                                   @RequestParam("studyOnline") boolean studyOnline,
                                   @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
                                   HttpSession session,
                                   Model model) {
        try {
            StudyGroup studyGroup = new StudyGroup();
            studyGroup.setStudyIdx(studyIdx);
            studyGroup.setStudyTitle(studyTitle);
            studyGroup.setDescription(description);
            studyGroup.setCategory(category);
            studyGroup.setAge(age);
            studyGroup.setGender(gender);
            studyGroup.setStudyOnline(studyOnline);

            if (profileImage != null && !profileImage.isEmpty()) {
                String fileName = System.currentTimeMillis() + "_" + profileImage.getOriginalFilename();
                String savePath = session.getServletContext().getRealPath("/resources/uploads/");
                File directory = new File(savePath);
                if (!directory.exists()) {
                    directory.mkdirs();
                }
                File uploadFile = new File(savePath + "/" + fileName);
                profileImage.transferTo(uploadFile);
                studyGroup.setImage("/resources/uploads/" + fileName);
            }

            studyMapper.updateStudyGroup(studyGroup);
            model.addAttribute("message", "수정이 완료되었습니다.");
        } catch (IOException e) {
            model.addAttribute("message", "수정 중 오류가 발생했습니다: " + e.getMessage());
        }
        return "redirect:/studyRecruit/recruitReadForm?studyIdx=" + studyIdx;
    }
}

