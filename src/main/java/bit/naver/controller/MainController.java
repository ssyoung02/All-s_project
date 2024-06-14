package bit.naver.controller;

import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.security.Principal;

@Controller
public class MainController {

    @Autowired
    private UsersMapper usersMapper;

    @RequestMapping("/main")
    public String mainScreen(Model model, HttpSession session) {
        // 세션에서 사용자 정보 가져오기
        Users userVo = (Users) session.getAttribute("userVo");

        if (userVo != null) { // 로그인한 사용자인 경우
            // 사용자 정보를 모델에 추가하여 JSP에서 사용할 수 있도록 함
            model.addAttribute("userVo", userVo);
        } else {
            // 로그인하지 않은 사용자 처리 (예: 로그인 페이지로 리다이렉트)
        }
        return "/main";
    }
}

