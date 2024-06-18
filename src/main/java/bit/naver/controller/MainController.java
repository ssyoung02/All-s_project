package bit.naver.controller;

import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUser;
import lombok.extern.log4j.Log4j;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.security.Principal;

@Slf4j
@Controller
public class MainController {

    @Autowired
    private UsersMapper usersMapper;

    @RequestMapping("/main")
    public String mainScreen(Model model ,HttpSession session) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UsersUser) {
            UsersUser usersUser = (UsersUser) authentication.getPrincipal();
            Users user = usersUser.getUsers();
            model.addAttribute("userVo", user); // Users 객체를 모델에 추가
            session.setAttribute("userVo", user);
        }
        Users userVo = (Users) session.getAttribute("userVo");
        if (userVo != null) {
            log.info("메인 페이지 접속 (username: {})", userVo.getUsername()); // 로그 추가
            model.addAttribute("userVo", userVo);
            session.setAttribute("userVo", userVo);
        } else {
            log.warn("메인 페이지 접근 시도 (로그인되지 않은 사용자)"); // 로그 추가
        }
        return "/main";
    }


    @RequestMapping("/include/header")
    public String header (Model model,HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);
        return "/include/header";
    }

    @RequestMapping("/include/footer")
    public String footer(Model model,HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);
        return "/include/footer";
    }
    @RequestMapping("/include/navbar")
    public String navbar(Model model,HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);
        return "/include/navbar";
    }
    @RequestMapping("/include/timer")
    public String timer(Model model,HttpSession session, Principal principal) {
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        model.addAttribute("user", user);
        session.setAttribute("userVo", user);
        return "/include/timer";
    }



}

