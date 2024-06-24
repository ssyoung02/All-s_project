package bit.naver.service;

import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

//@Service
//@PropertySource("classpath:application.properties")
//public class KakaoLoginService {
//    private final Environment env;
//    private final RestTemplate restTemplate = new RestTemplate();
//
//    @Autowired
//    public KakaoLoginService(Environment env) {
//        this.env = env;
//    }
//
//    public KakaoUsersInfo getUsersInfoFromKakao(String code) {
//        String accessToken = getKakaoAccessToken(code);
//        System.out.println("Access Token: " + accessToken);
//
//        JsonNode userResourceNode = getUserResource(accessToken);
//
//        String name = userResourceNode.path("properties").path("nickname").asText();
//        String email = userResourceNode.path("kakao_account").path("email").asText();
//
//        return new KakaoUsersInfo(name, email);
//    }
//
//    private String getKakaoAccessToken(String code) {
//
//        String KakaoClientId = env.getProperty("oauth2.kakao.client-id");
//        String KakaoClientSecret = env.getProperty("oauth2.kakao.client-secret");
//        String redirectUri = env.getProperty("oauth2.kakao.redirect-uri");
//        String tokenUri = env.getProperty("oauth2.kakao.token-uri");
//
//        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
//        params.add("code", code);
//        params.add("client_id", KakaoClientId);
//        params.add("client_secret", KakaoClientSecret);
//        params.add("redirect_uri", redirectUri);
//        params.add("grant_type", "authorization_code");
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
//
//        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);
//
//        ResponseEntity<JsonNode> response = restTemplate.exchange(tokenUri, HttpMethod.POST, entity, JsonNode.class);
//        JsonNode accessTokenNode = response.getBody();
//
//        if (accessTokenNode != null && accessTokenNode.has("access_token")) {
//            return accessTokenNode.get("access_token").asText();
//        } else {
//            throw new IllegalStateException("Access token not found");
//        }
//    }
//
//    private JsonNode getUserResource(String accessToken) {
//        String userInfoUri = "https://kapi.kakao.com/v2/user/me";
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.set("Authorization", "Bearer " + accessToken);
//        HttpEntity<?> entity = new HttpEntity<>(headers);
//
//        ResponseEntity<JsonNode> response = restTemplate.exchange(userInfoUri, HttpMethod.GET, entity, JsonNode.class);
//        return response.getBody();
//    }
//
//
//}


@Service
@PropertySource("classpath:application.properties")
public class KakaoLoginService implements IKakaoLoginService {

    private final Environment env;
    private final RestTemplate restTemplate;

    @Autowired
    public KakaoLoginService(Environment env) {
        this.env = env;
        this.restTemplate = new RestTemplate();
    }

    @Override
    public String getAccessToken(String authorize_code) throws Throwable {
        System.out.println("Authorize Code: " + authorize_code);

        String tokenUri = env.getProperty("oauth2.kakao.token-uri");
        String clientId = env.getProperty("oauth2.kakao.client-id");
        String clientSecret = env.getProperty("oauth2.kakao.client-secret");
        String redirectUri = env.getProperty("oauth2.kakao.redirect-uri");

        // POST 요청에 필요한 파라미터 설정
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret);
        params.add("redirect_uri", redirectUri);
        params.add("code", authorize_code);

        // HTTP 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        // 요청 엔티티 생성
        HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(params, headers);

        try {
            // POST 요청으로 토큰을 요청하고 응답을 받음
            ResponseEntity<JsonNode> response = restTemplate.exchange(tokenUri, HttpMethod.POST, requestEntity, JsonNode.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JsonNode responseBody = response.getBody();
                String accessToken = responseBody.get("access_token").asText();
                String refreshToken = responseBody.get("refresh_token").asText();

                // 콘솔에 액세스 토큰과 리프레시 토큰을 출력
                System.out.println("Access Token: " + accessToken);
                System.out.println("Refresh Token: " + refreshToken);

                return accessToken;
            } else {
                throw new RuntimeException("Failed to get access token. Response: " + response.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get access token", e);
        }
    }

    @Override
    public HashMap<String, Object> getUserInfo(String access_Token) throws Throwable {
        String userInfoUri = "https://kapi.kakao.com/v2/user/me";

        // HTTP 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + access_Token);

        // 요청 엔티티 생성
        HttpEntity<?> requestEntity = new HttpEntity<>(headers);

        try {
            // GET 요청으로 사용자 정보를 요청하고 응답을 받음
            ResponseEntity<JsonNode> response = restTemplate.exchange(userInfoUri, HttpMethod.GET, requestEntity, JsonNode.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                JsonNode responseBody = response.getBody();

                // 사용자 정보 출력
                System.out.println("User Info Response: " + responseBody.toString());

                // 사용자 정보를 HashMap으로 반환
                HashMap<String, Object> userInfo = new HashMap<>();
                userInfo.put("name", responseBody.path("properties").path("nickname").asText());
                userInfo.put("email", responseBody.path("kakao_account").path("email").asText());
                // 프로필 이미지 URL 추가
                String profileImage = responseBody.path("properties").path("profile_image").asText();
                userInfo.put("profileImage", profileImage);
                userInfo.put("provider", "kakao");


                return userInfo;
            } else {
                throw new RuntimeException("Failed to get user info. Response: " + response.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to get user info", e);
        }
    }

    public String getAccessTokenFromAttributes(Map<String, Object> attributes) {
        return (String) attributes.get("access_token");
    }
}



