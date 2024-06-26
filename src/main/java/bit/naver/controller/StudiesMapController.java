package bit.naver.controller;


import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMembers;
import bit.naver.mapper.StudyGroupMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController // @Controller -> @RestController 로 변경
@RequestMapping("/studies")
@RequiredArgsConstructor
public class StudiesMapController {


    private final StudyGroupMapper studiesMapMapper;

    @GetMapping("/listOnMap")
    public List<StudyGroup> getStudyList() {
        return studiesMapMapper.findAllStudies();
    }

    // 스터디 목록 조회 (로그인하지 않은 사용자용)
    @GetMapping("/listOnAnonymousMap") // GET 방식으로 변경
    public List<StudyGroup> getStudyListOnAnonymousMap() {
        return studiesMapMapper.findAllStudies();
    }

    // 스터디 상세 페이지 조회
    @GetMapping("/detail/{studyIdx}")
    public String getStudyDetail(@PathVariable Long studyIdx, Model model) {
        StudyGroup studyGroup = studiesMapMapper.getStudyById(studyIdx);
        List<StudyMembers> studyMembers = studiesMapMapper.getStudyMembers(studyIdx);
        model.addAttribute("studyGroup", studyGroup);
        model.addAttribute("studyMembers", studyMembers);
        return "studies/studyDetail"; // 스터디 상세 페이지 뷰 이름
    }
}