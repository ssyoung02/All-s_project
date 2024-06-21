package bit.naver.controller;

import bit.naver.entity.GoogleUsersInfo;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUser;
import bit.naver.service.GoogleLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
/*
@Controller
@CrossOrigin("*")
@AllArgsConstructor
 */
@PropertySource("classpath:application.properties")
@Controller
public class GoolgeLoginController {

    @Autowired
    private Environment env;

    @Autowired
    private GoogleLoginService loginService;

    @Autowired
    private UsersMapper usersMapper;

    @GetMapping("/login/google")
    public void googleLoginRedirect(HttpServletResponse response) {
        String googleClientId = env.getProperty("oauth2.google.client-id");
        String redirectUri = env.getProperty("oauth2.google.redirect-uri");
        String scope = env.getProperty("oauth2.google.scope");

        String reqUrl = "https://accounts.google.com/o/oauth2/auth" +
                "?client_id=" + googleClientId +
                "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8) +
                "&response_type=code" +
                "&scope=" + URLEncoder.encode(scope, StandardCharsets.UTF_8);

        try {
            response.sendRedirect(reqUrl);
        } catch (IOException e) {
            // IOException 처리
            e.printStackTrace();
        }
    }

    @GetMapping("/login/oauth2/code/google")
    public String handleGoogleAuthCode(@RequestParam String code, Model model) {
        try {
            // 구글 사용자 정보 가져오기
            GoogleUsersInfo userInfo = loginService.getUsersInfoFromGoogle(code);
            // 1. 사용자 정보를 바탕으로 DB에서 해당 이메일의 사용자 조회 (boolean 결과 확인)
            boolean userExists = usersMapper.findByEmail(userInfo.getEmail());

            if (userExists) {
                // 2-1. 사용자가 이미 존재하는 경우: 로그인 처리 (기존 로직 유지)
                Users existingUser = usersMapper.findUserByEmail(userInfo.getEmail()); // 사용자 정보 가져오기
                // UsersUser 객체 생성 (UserDetails 구현체)
                UserDetails userDetails = new UsersUser(existingUser);

                Authentication authentication = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities()
                );
                SecurityContextHolder.getContext().setAuthentication(authentication);
                return "redirect:/main";
            } else {
                // 2-2. 사용자가 존재하지 않는 경우: 회원가입 페이지로 이동 (기존 로직 유지)
                model.addAttribute("googleUserInfo", userInfo);
                return "Users/join";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/login?error=true";
        }
    }
}


