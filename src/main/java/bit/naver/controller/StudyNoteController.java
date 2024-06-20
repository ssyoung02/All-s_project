package bit.naver.controller;

import bit.naver.entity.CommentsEntity;
import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.StudyNoteService;
import bit.naver.service.StudyReferencesService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.w3c.dom.ls.LSOutput;

import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.util.List;

// StudyReferencesController 클래스: 클라이언트의 요청을 처리하는 컨트롤러 계층
@Controller
@RequestMapping("/studyNote")
@RequiredArgsConstructor
public class StudyNoteController {
    @Autowired
    private UsersMapper usersMapper;

    private final UsersUserDetailsService usersUserDetailsService;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private StudyNoteService studyNoteService;

    @RequestMapping("/noteList")
    public String getStudyNoteList(Model model, @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                         @RequestParam(value = "searchOption", required = false) String searchOption,
                                         @RequestParam(value = "limits", required = false, defaultValue = "5") String limits,
                                         HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        String userIdx = String.valueOf(user != null ? user.getUserIdx() : 59); // 사용자 ID 가져오기
        List<StudyReferencesEntity> studyReferencesEntity = studyNoteService.getStudyNoteList(userIdx, searchKeyword, searchOption, limits);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("limits", limits);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);

        return "/studyNote/noteList";
    }

    @RequestMapping("/noteRead")
    public String getStudyNoteRead(Model model, @RequestParam("referenceIdx") Long referenceIdx, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        String userIdx = String.valueOf(user.getUserIdx()); // 사용자 ID 가져오기
        StudyReferencesEntity studyReferencesEntity = studyNoteService.getStudyNoteById(referenceIdx, userIdx);
        List<CommentsEntity> studyRefencesComment = studyNoteService.getCommentsByReferenceIdx(referenceIdx);

        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("studyRefencesComment", studyRefencesComment);
        model.addAttribute("userIdx", userIdx); //나중에 59만 로그인한사람의 userIdx로 바꿔주기


        return "/studyNote/noteRead";
    }

    @RequestMapping("/deleteComment")
    @ResponseBody
    public String deleteComment(@RequestParam("commentIdx") String commentIdx) {
        //System.out.println("comment Idx >>> " + commentIdx); 값 제대로 넘어오는지 확인하기 위해
        return studyNoteService.deleteComment(commentIdx);
    }

    @RequestMapping("/insertComment")
    @ResponseBody
    public String insertComment(@ModelAttribute CommentsEntity content, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
        content.setUserIdx(userIdx); //임의로 userIdx값 줌
        return studyNoteService.insertComment(content);
    }

    @RequestMapping("/insertLike")
    @ResponseBody
    public int insertLike(@ModelAttribute LikeReferencesEntity entity) {
        System.out.println("ENTITY >>>" + entity.toString());
        return studyNoteService.insertLike(entity);
    }

    @RequestMapping("/deleteLike")
    @ResponseBody
    public int deleteLike(@ModelAttribute LikeReferencesEntity entity) {
        return studyNoteService.deleteLike(entity);
    }

    @RequestMapping("/updateReport")
    @ResponseBody
    public int updateReport(@ModelAttribute StudyReferencesEntity entity) {
        return studyNoteService.updateReport(entity);
    }

    @GetMapping("/noteWrite")
    public String noteWrite(@ModelAttribute StudyReferencesEntity entity) {
        return "/studyNote/noteWrite";
    }

    @PostMapping("/noteWrite")
    @ResponseBody
    public Long submitPost(@ModelAttribute StudyReferencesEntity entity, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
        entity.setUserIdx(userIdx);

        return studyNoteService.writePost(entity);
    }

    @RequestMapping("/deletePost")
    @ResponseBody
    public int deletePost(@RequestParam("referenceIdx") int referenceIdx) {
        System.out.println("referenceIdx: " + referenceIdx);
        return studyNoteService.deletePost(referenceIdx);
    }

    @RequestMapping("/noteModify")
    public String modifyPost(Model model, @ModelAttribute StudyReferencesEntity entity, HttpSession session) {
        System.out.println("entity: " + entity);
        Users user = (Users) session.getAttribute("userVo");
        String userIdx = String.valueOf(user.getUserIdx()); // 사용자 ID 가져오기
        StudyReferencesEntity studyReferencesEntity = studyNoteService.getStudyNoteById(entity.getReferenceIdx(), userIdx);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);

        return "/studyNote/noteModify";
    }

    @RequestMapping("/updatePost")
    @ResponseBody
    public int updatePost(@ModelAttribute StudyReferencesEntity entity) {
        return studyNoteService.updatePost(entity);
    }

}
