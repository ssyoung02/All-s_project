package bit.naver.controller;

import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
    public String mainScreen(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UsersUser) {
            UsersUser usersUser = (UsersUser) authentication.getPrincipal();
            Users user = usersUser.getUsers();
            model.addAttribute("userVo", user); // Users 객체를 모델에 추가
        }
        return "/main";
    }

}

