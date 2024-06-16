package bit.naver.controller;

import bit.naver.entity.CommentsEntity;
import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.service.StudyReferencesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// StudyReferencesController 클래스: 클라이언트의 요청을 처리하는 컨트롤러 계층
@Controller
@RequestMapping("/StudyReferences")
public class StudyReferencesController {

    @Autowired
    private StudyReferencesService studyReferencesService;

    @GetMapping("/referencesList")
    public String getStudyReferencesList(Model model, @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                         @RequestParam(value = "searchOption", required = false) String searchOption,
                                         @RequestParam(value = "limits", required = false, defaultValue = "5") String limits) {
        String userIdx = "59";
        List<StudyReferencesEntity> studyReferencesEntity = studyReferencesService.getStudyReferencesList(userIdx, searchKeyword, searchOption, limits);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("userIdx", "59"); //나중에 59만 로그인한사람의 userIdx로 바꿔주기
        model.addAttribute("limits", limits);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);

        return "/StudyReferences/referencesList";
    }


    @GetMapping("/referencesMyList")
    public String getStudyReferencesMyList(Model model, @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                         @RequestParam(value = "searchOption", required = false) String searchOption,
                                         @RequestParam(value = "limits", required = false, defaultValue = "5") String limits) {
        String userIdx = "59";
        List<StudyReferencesEntity> studyReferencesEntity = studyReferencesService.getStudyReferencesMyList(userIdx, searchKeyword, searchOption, limits);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("userIdx", "59"); //나중에 59만 로그인한사람의 userIdx로 바꿔주기
        model.addAttribute("limits", limits);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);

        return "/StudyReferences/referencesList";
    }

    @GetMapping("/referencesSite")
    public String getStudyReferencesSite(Model model, @RequestParam("referenceIdx") Long referenceIdx) {
        String userIdx = "59";
        StudyReferencesEntity studyReferencesEntity = studyReferencesService.getStudyReferenceById(referenceIdx, userIdx);
        List<CommentsEntity> studyRefencesComment = studyReferencesService.getCommentsByReferenceIdx(referenceIdx);

        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("studyRefencesComment", studyRefencesComment);
        model.addAttribute("userIdx", "59"); //나중에 59만 로그인한사람의 userIdx로 바꿔주기


        return "/StudyReferences/referencesSite";
    }

    @PostMapping("/deleteComment")
    @ResponseBody
    public String deleteComment(@RequestParam("commentIdx") String commentIdx) {
        //System.out.println("comment Idx >>> " + commentIdx); 값 제대로 넘어오는지 확인하기 위해
        return studyReferencesService.deleteComment(commentIdx);
    }

    @PostMapping("/insertComment")
    @ResponseBody
    public String insertComment(@ModelAttribute CommentsEntity content) {
        content.setUserIdx(59L); //임의로 userIdx값 줌
        return studyReferencesService.insertComment(content);
    }

    @PostMapping("/insertLike")
    @ResponseBody
    public int insertLike(@ModelAttribute LikeReferencesEntity entity) {
        //System.out.println("ENTITY >>>" + entity.toString());
        return studyReferencesService.insertLike(entity);
    }

    @PostMapping("/deleteLike")
    @ResponseBody
    public int deleteLike(@ModelAttribute LikeReferencesEntity entity) {
        return studyReferencesService.deleteLike(entity);
    }

    @PostMapping("/updateReport")
    @ResponseBody
    public int updateReport(@ModelAttribute StudyReferencesEntity entity) {
        return studyReferencesService.updateReport(entity);
    }

    @GetMapping("/referencesWrite")
    public String referencesWrite(@ModelAttribute StudyReferencesEntity entity) {
        return "/StudyReferences/referencesWrite";
    }

    @PostMapping("/referencesWrite")
    @ResponseBody
    public Long submitPost(@ModelAttribute StudyReferencesEntity entity) {
        Long userIdx = 59L;
        entity.setUserIdx(userIdx);

        return studyReferencesService.writePost(entity);
    }

    @PostMapping("/deletePost")
    @ResponseBody
    public int deletePost(@RequestParam("referenceIdx") int referenceIdx) {
        System.out.println("referenceIdx: " + referenceIdx);
        return studyReferencesService.deletePost(referenceIdx);
    }

    @GetMapping("/referencesModify")
    public String modifyPost(Model model, @ModelAttribute StudyReferencesEntity entity) {
        System.out.println("entity: " + entity);
        String userIdx = "59";
        StudyReferencesEntity studyReferencesEntity = studyReferencesService.getStudyReferenceById(entity.getReferenceIdx(), userIdx);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        System.out.println(studyReferencesEntity.toString());

        return "/StudyReferences/referencesModify";
    }

    @PostMapping("/updatePost")
    @ResponseBody
    public int updatePost(@ModelAttribute StudyReferencesEntity entity) {
        return studyReferencesService.updatePost(entity);
    }

}
