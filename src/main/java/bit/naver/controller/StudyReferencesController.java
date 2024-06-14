package bit.naver.controller;

import bit.naver.entity.StudyReferencesEntity;
import bit.naver.service.StudyReferencesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

// StudyReferencesController 클래스: 클라이언트의 요청을 처리하는 컨트롤러 계층
@Controller
@RequestMapping("/StudyReferences")
public class StudyReferencesController {

    // StudyReferencesService를 주입받습니다.
    @Autowired
    private StudyReferencesService studyReferencesService;

    // "/StudyReferences/StudyReferencesList" URL 요청을 처리하는 메서드
    @GetMapping("/StudyReferencesList")
    public String studyReferencesList(Model model) {
        // 전체 게시물 수를 가져옵니다.
        int totalPost = studyReferencesService.getTotalPosts();
        // 게시물 목록을 가져옵니다.
        List<StudyReferencesEntity> studyReferencesList = studyReferencesService.getAllPosts();

        // 전체 게시물 수를 모델에 추가하여 뷰에 전달합니다.
        model.addAttribute("totalPost", totalPost);
        model.addAttribute("studyReferences", studyReferencesList);

        // "StudyReferences/StudyReferencesList"라는 이름의 JSP 파일을 반환하여 사용자에게 결과를 표시합니다.
        return "StudyReferences/StudyReferencesList";
    }
}
