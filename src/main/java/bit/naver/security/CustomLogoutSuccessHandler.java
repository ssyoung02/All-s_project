package bit.naver.security;

import bit.naver.service.GoogleLoginService;
import bit.naver.service.KakaoLoginService;
import bit.naver.service.NaverLoginService;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@Component
public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

    private final NaverLoginService naverLoginService;
    private final KakaoLoginService kakaoLoginService;
    private final GoogleLoginService googleLoginService;

    public CustomLogoutSuccessHandler(NaverLoginService naverLoginService, KakaoLoginService kakaoLoginService, GoogleLoginService googleLoginService) {
        this.naverLoginService = naverLoginService;
        this.kakaoLoginService = kakaoLoginService;
        this.googleLoginService = googleLoginService;
    }

    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        if (authentication.getPrincipal() instanceof OAuth2User) {
            OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();
            String registrationId = (String) oauth2User.getAttributes().get("registration_id");

            switch (registrationId) {
                case "google":
                    String googleAccessToken = getGoogleAccessToken(authentication);
                    if (googleAccessToken != null) {
                        logoutGoogle(googleAccessToken);
                    }
                    break;
                case "kakao":
                    String kakaoAccessToken = getKakaoAccessToken(authentication);
                    if (kakaoAccessToken != null) {
                        logoutKakao(kakaoAccessToken);
                    }
                    break;
                case "naver":
                    logoutNaver(response);
                    break;
                default:
                    break;
            }
        }

        response.sendRedirect("/login?logout");
    }

    private void logoutNaver(HttpServletResponse response) throws IOException {
        String naverLogoutUrl = "https://nid.naver.com/nidlogin.logout";
        response.sendRedirect(naverLogoutUrl);
    }

    private void logoutKakao(String accessToken) {
        String requestUrl = "https://kapi.kakao.com/v1/user/logout";
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);

        HttpEntity<String> entity = new HttpEntity<>("", headers);

        try {
            ResponseEntity<String> response = restTemplate.exchange(requestUrl, HttpMethod.POST, entity, String.class);
            if (!response.getStatusCode().is2xxSuccessful()) {
                throw new RuntimeException("Failed to logout from Kakao: " + response.getStatusCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Kakao logout failed", e);
        }
    }

    private void logoutGoogle(String accessToken) {
        String requestUrl = "https://accounts.google.com/o/oauth2/revoke?token=" + accessToken;
        RestTemplate restTemplate = new RestTemplate();

        try {
            ResponseEntity<String> response = restTemplate.postForEntity(requestUrl, null, String.class);
            if (!response.getStatusCode().is2xxSuccessful()) {
                throw new RuntimeException("Failed to logout from Google: " + response.getStatusCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Google logout failed", e);
        }
    }

    private String getKakaoAccessToken(Authentication authentication) {
        if (authentication.getPrincipal() instanceof OAuth2User) {
            OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();
            return kakaoLoginService.getAccessTokenFromAttributes(oauth2User.getAttributes());
        }
        return null;
    }

    private String getGoogleAccessToken(Authentication authentication) {
        if (authentication.getPrincipal() instanceof OAuth2User) {
            OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();
            return googleLoginService.getAccessTokenFromAttributes(oauth2User.getAttributes());
        }
        return null;
    }
}
