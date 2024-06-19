package bit.naver.service;

import bit.naver.dto.GoogleUsersInfo;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
@PropertySource("classpath:application.properties")
public class GoogleLoginService {
    private final Environment env;
    private final RestTemplate restTemplate = new RestTemplate();

    @Autowired
    public GoogleLoginService(Environment env) {
        this.env = env;
    }

    public GoogleUsersInfo getUsersInfoFromGoogle(String code) {
        String accessToken = getGoogleAccessToken(code);
        JsonNode userResourceNode = getUserResource(accessToken);

        String name = userResourceNode.get("name").asText();
        String email = userResourceNode.get("email").asText();

        return new GoogleUsersInfo(name, email);
    }
/*
    public void googleLogin(String code) {
        String accessToken = getGoogleAccessToken(code);
        JsonNode userResourceNode = getUserResource(accessToken);
        // 여기서 사용자 정보 처리
        System.out.println("Google User Info: " + userResourceNode);
    }
*/
    private String getGoogleAccessToken(String code) {
        String googleClientId = env.getProperty("oauth2.google.client-id");
        String googleClientSecret = env.getProperty("oauth2.google.client-secret");
        String redirectUri = env.getProperty("oauth2.google.redirect-uri");
        String tokenUri = env.getProperty("oauth2.google.token-uri");

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("code", code);
        params.add("client_id", googleClientId);
        params.add("client_secret", googleClientSecret);
        params.add("redirect_uri", redirectUri);
        params.add("grant_type", "authorization_code");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

        ResponseEntity<JsonNode> response = restTemplate.exchange(tokenUri, HttpMethod.POST, entity, JsonNode.class);
        JsonNode accessTokenNode = response.getBody();

        if (accessTokenNode != null && accessTokenNode.has("access_token")) {
            return accessTokenNode.get("access_token").asText();
        } else {
            throw new IllegalStateException("Access token not found");
        }
    }

    private JsonNode getUserResource(String accessToken) {
        String userInfoUri = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json";

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<?> entity = new HttpEntity<>(headers);

        ResponseEntity<JsonNode> response = restTemplate.exchange(userInfoUri, HttpMethod.GET, entity, JsonNode.class);
        return response.getBody();
    }
}
