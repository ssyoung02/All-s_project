package bit.naver.controller;

import bit.naver.entity.StudyGroup;
import bit.naver.mapper.StudyGroupMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/studyRecruit")
public class StudyRecruitController {

    @Autowired
    private StudyGroupMapper studyGroupMapper;

    @GetMapping("/recruitList")
    public String showRecruitList(Model model) {
        List<StudyGroup> recruitedStudies = studyGroupMapper.getAllRecruitedStudies();
        model.addAttribute("recruitedStudies", recruitedStudies);
        return "studyRecruit/recruitList";
    }
}
