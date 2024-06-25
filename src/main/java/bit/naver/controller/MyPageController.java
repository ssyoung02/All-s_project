package bit.naver.controller;

import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.MyPageService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/myPage")
@RequiredArgsConstructor
public class MyPageController {

    @Autowired
    private UsersMapper usersMapper;

    private final UsersUserDetailsService usersUserDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MyPageService myPageService;

    @RequestMapping("/myPageInfo")
    public String getMyPageInfo(Model model, @ModelAttribute StudyReferencesEntity entity,
                             HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        entity.setUserIdx(user.getUserIdx());

        List<StudyReferencesEntity> studyReferencesEntity = myPageService.getStudyReferencesList(entity);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);
        return "/myPage/myPageInfo";
    }

    @RequestMapping("/myPageLikePost")
    public String getLikePostList(Model model, @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                                         @RequestParam(value = "searchOption", required = false) String searchOption,
                                         @RequestParam(value = "limits", required = false, defaultValue = "5") String limits,
                                         HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        String userIdx = String.valueOf(user != null ? user.getUserIdx() : 59); // 사용자 ID 가져오기
        List<StudyReferencesEntity> studyReferencesEntity = myPageService.getLikePostList(userIdx, searchKeyword, searchOption, limits);
        model.addAttribute("studyReferencesEntity", studyReferencesEntity);
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("limits", limits);
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);

        return "/myPage/myPageLikePost";
    }

    @RequestMapping("/insertLike")
    @ResponseBody
    public int insertLike(@ModelAttribute LikeReferencesEntity entity) {
        return myPageService.insertLike(entity);
    }

    @RequestMapping("/deleteLike")
    @ResponseBody
    public int deleteLike(@ModelAttribute LikeReferencesEntity entity) {
        return myPageService.deleteLike(entity);
    }


}
