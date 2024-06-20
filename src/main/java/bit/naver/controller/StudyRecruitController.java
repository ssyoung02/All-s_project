package bit.naver.controller;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMembers;
import bit.naver.entity.Users;
import bit.naver.mapper.StudyGroupMapper;
import bit.naver.mapper.StudyRecruitMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/studyRecruit")
public class StudyRecruitController {

    @Autowired
    private StudyRecruitMapper studyMapper;

    // 모집글 리스트
    @RequestMapping("/recruitList")
    public String getAllStudies(Model model) {
        List<StudyGroup> studies = studyMapper.getAllStudies();
        System.out.println(studies.toString());
        model.addAttribute("studies", studies);
        return "redirect:studyRecruit/recruitList"; // recruitList.jsp로 이동
    }

    @RequestMapping("/register")
    // 스터디 등록 insert
    public String registerStudyMember(@RequestParam("studyIdx") Long studyIdx, HttpSession session, Principal principal) {

        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기

        StudyMembers studyMember = new StudyMembers();
        studyMember.setStudyIdx(studyIdx);
        studyMember.setUserIdx(userIdx);
        studyMember.setRole("MEMBER");
        studyMember.setStatus("ACCEPTED");
        studyMember.setCreatedAt(LocalDateTime.now());
        studyMember.setUpdatedAt(LocalDateTime.now());

        System.out.println(studyMember.toString());

        studyMapper.insertStudyMember(studyMember);

        return "redirect:studyGroup/studyGroupList";
    }
}
