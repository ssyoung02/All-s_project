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

import javax.servlet.http.HttpSession;
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
    public String getAllStudies(Model model, HttpSession session, Principal principal,
                                @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                @RequestParam(value = "searchOption", required = false) String searchOption) {
        Users user = (Users) session.getAttribute("userVo");
        String username = principal.getName();
        Users users = usersMapper.findByUsername(username);
        Long userIdx = Long.valueOf(users != null ? users.getUserIdx() : 59);

        // Get studies with userIdx as a parameter
        List<StudyGroup> studies = studyMapper.getAllStudies(userIdx,searchKeyword, searchOption);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("studies", studies);

        List<StudyGroup> study_18 = studyMapper.getAllStudy_9(userIdx);
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

        model.addAttribute("study", study);
        model.addAttribute("members", members);
        model.addAttribute("isMember", isMember);

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

        System.out.println(leaderIdx);
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
    public String updateStudyGroup(@ModelAttribute StudyGroup study, Model model) {
        studyMapper.updateStudyGroup(study);
        model.addAttribute("message", "수정이 완료되었습니다.");
        return "redirect:/studyRecruit/recruitReadForm?studyIdx=" + study.getStudyIdx();
    }

}
