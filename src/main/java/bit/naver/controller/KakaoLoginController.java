

package bit.naver.controller;

import bit.naver.dto.KakaoUsersInfo;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUser;
import bit.naver.service.IKakaoLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;

@PropertySource("classpath:application.properties")
@Controller
public class KakaoLoginController {

    @Autowired
    private Environment env;

    @Autowired
    private UsersMapper usersMapper;

    @Autowired
    private IKakaoLoginService iKakaoS;

    // 카카오 로그인 리다이렉트 및 사용자 인증 처리
    @RequestMapping(value = "/kakao/login", method = RequestMethod.GET)
    public ModelAndView kakaoLogin(@RequestParam(value = "code", required = false) String code) throws Throwable {
        System.out.println("Code: " + code);

        // 1. Access token 획득
        String access_Token = iKakaoS.getAccessToken(code);
        System.out.println("### Access Token #### : " + access_Token);

        // 2. Access token을 사용하여 사용자 정보 얻기
        HashMap<String, Object> userInfo = iKakaoS.getUserInfo(access_Token);
        System.out.println("### Name #### : " + userInfo.get("name"));
        System.out.println("### Email #### : " + userInfo.get("email"));
        System.out.println("### Profile Image #### : " + userInfo.get("profileImage"));

        // 사용자 이메일 가져오기
        String userEmail = (String) userInfo.get("email");

        // 3. DB에서 사용자 정보 확인
        boolean userExists = usersMapper.findByEmail(userEmail);

        if (userExists) {
            // 사용자가 존재하는 경우
            Users existingUser = usersMapper.findUserByEmail(userEmail);

            // 4. Spring Security 인증 처리
            UserDetails userDetails = new UsersUser(existingUser);
            Authentication authentication = new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities()
            );
            SecurityContextHolder.getContext().setAuthentication(authentication);

            // 5. 메인 페이지로 리다이렉트
            return new ModelAndView("redirect:/main");
        } else {
            // 사용자가 존재하지 않는 경우, 회원가입 페이지로 이동
            ModelAndView modelAndView = new ModelAndView("Users/join");
            modelAndView.addObject("KakaoUserInfo", userInfo);
            return modelAndView;
        }
    }
}
