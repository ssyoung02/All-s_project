package bit.naver.controller;


import bit.naver.entity.StudyGroup;
import bit.naver.mapper.StudiesMapMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController // @Controller -> @RestController 로 변경
@RequestMapping("/studies")
@RequiredArgsConstructor
public class StudiesMapController {

    @Autowired
    private StudiesMapMapper studiesMapMapper;

    @GetMapping("/listOnMap")
    public List<StudyGroup> getStudyList() {
        return studiesMapMapper.findAllStudies();
    }

//    // 스터디 목록 조회 (로그인하지 않은 사용자용)
//    @GetMapping("/listOnAnonymousMap")
//    public String getStudyListOnAnonymousMap(Model model) {
//        List<StudyGroup> studies = studiesMapMapper.findAllStudies(); // 모든 스터디 정보 조회
//        model.addAttribute("studyList", studies); // 모델에 스터디 정보 추가
//        return "main"; // 메인 페이지 뷰 이름 반환 (리다이렉트 아님)
//    }

    // 스터디 목록 조회 (로그인하지 않은 사용자용)
    @GetMapping("/listOnAnonymousMap") // GET 방식으로 변경
    public List<StudyGroup> getStudyListOnAnonymousMap() {
        return studiesMapMapper.findAllStudies();
    }
}