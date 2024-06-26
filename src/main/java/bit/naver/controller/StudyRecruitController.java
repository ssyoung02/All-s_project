package bit.naver.controller;

import bit.naver.entity.LikeStudyEntity;
import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMembers;
import bit.naver.entity.Users;
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

    // 모집글 리스트
    @RequestMapping("/recruitList")
    public String getAllStudies(Model model, HttpSession session, Principal principal) {
        Users user = (Users) session.getAttribute("userVo");
        String username = principal.getName();
        Users users = usersMapper.findByUsername(username);
        Long userIdx = Long.valueOf(users != null ? users.getUserIdx() : 59);


        // Get studies with userIdx as a parameter
        List<StudyGroup> studies = studyMapper.getAllStudies(userIdx);
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
        model.addAttribute("study", study);

        return "studyRecruit/recruitReadForm";
    }

    // 스터디 등록 insert
    @RequestMapping("/recruitReadForm")
    public String registerStudyMember(@RequestParam("studyIdx") Long studyIdx, @RequestParam("joinReason") String joinReason, HttpSession session, Principal principal) {

        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기

        StudyMembers studyMember = new StudyMembers();
        studyMember.setStudyIdx(studyIdx);
        studyMember.setUserIdx(userIdx);
        studyMember.setRole("MEMBER");
        studyMember.setStatus("ACCEPTED");
        studyMember.setJoinReason(joinReason);
        studyMember.setCreatedAt(LocalDateTime.now());
        studyMember.setUpdatedAt(LocalDateTime.now());


        studyMapper.insertStudyMember(studyMember);

        return "/main";
    }

    @RequestMapping("/insertLike")
    @ResponseBody
    public int insertLike(@ModelAttribute LikeStudyEntity entity) {
        System.out.println("ENTITY >>>" + entity.toString());
        return studyService.insertLike(entity);
    }

    @RequestMapping("/deleteLike")
    @ResponseBody
    public int deleteLike(@ModelAttribute LikeStudyEntity entity) {
        System.out.println("ENTITY >>>" + entity.toString());

        return studyService.deleteLike(entity);
    }

    @RequestMapping("/updateReport")
    @ResponseBody
    public int updateReport(@ModelAttribute StudyGroup entity) {
        System.out.println(entity.toString());
        return studyService.updateReport(entity);
    }

}
