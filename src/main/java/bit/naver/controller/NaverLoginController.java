package bit.naver.controller;

import bit.naver.entity.NaverUsersInfo;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUser;
import bit.naver.service.INaverLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;

@PropertySource("classpath:application.properties")
@Controller
public class NaverLoginController {

    @Autowired
    private Environment env;

    @Autowired
    private INaverLoginService naverLoginService;

    @Autowired
    private UsersMapper usersMapper;

    @RequestMapping("/login/naver")
    public void naverLoginRedirect(HttpServletResponse response) {
        String clientId = env.getProperty("oauth2.naver.client-id");
        String redirectUri = env.getProperty("oauth2.naver.redirect-uri");
        String state = generateState();

        String reqUrl = "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=" + clientId +
                "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8) + "&state=" + state;

        try {
            response.sendRedirect(reqUrl);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/login/oauth2/code/naver")
    public String handleNaverAuthCode(@RequestParam String code, @RequestParam String state, Model model) {
        try {
            NaverUsersInfo userInfo = naverLoginService.getUsersInfoFromNaver(code, state);

            boolean userExists = usersMapper.findByEmail(userInfo.getEmail());

            if (userExists) {
                Users existingUser = usersMapper.findUserByEmail(userInfo.getEmail());
                UserDetails userDetails = new UsersUser(existingUser);

                Authentication authentication = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities()
                );
                SecurityContextHolder.getContext().setAuthentication(authentication);
                return "redirect:/main";
            } else {
                model.addAttribute("naverUserInfo", userInfo);
                return "/Users/join";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/login?error=true";
        }
    }

    private String generateState() {
        SecureRandom random = new SecureRandom();
        return new BigInteger(130, random).toString(32);
    }
}
