package bit.naver.service;


import bit.naver.entity.NaverUsersInfo;
import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.text.ParseException;
import java.util.Map;

@Service
@PropertySource("classpath:application.properties")
public class NaverLoginService implements INaverLoginService {

    private final Environment env;
    private final RestTemplate restTemplate;

    @Autowired
    public NaverLoginService(Environment env) {
        this.env = env;
        this.restTemplate = new RestTemplate();
    }

    @Override
    public NaverUsersInfo getUsersInfoFromNaver(String code, String state) throws Exception {
        String clientId = env.getProperty("oauth2.naver.client-id");
        String clientSecret = env.getProperty("oauth2.naver.client-secret");
        String redirectUri = env.getProperty("oauth2.naver.redirect-uri");

        String tokenUrl = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code" +
                "&client_id=" + clientId +
                "&client_secret=" + clientSecret +
                "&code=" + code +
                "&state=" + state;

        String accessToken = getAccessToken(tokenUrl);
        return getUserInfo(accessToken);
    }

    private String getAccessToken(String tokenUrl) throws IOException {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        HttpEntity<?> entity = new HttpEntity<>(headers);

        ResponseEntity<JsonNode> response = restTemplate.exchange(tokenUrl, HttpMethod.GET, entity, JsonNode.class);
        JsonNode body = response.getBody();

        System.out.println("Response Body: " + body);

        if (body != null && body.has("access_token")) {
            return body.get("access_token").asText();
        } else {
            if (body != null && body.has("error")) {
                String error = body.get("error").asText();
                String errorDescription = body.has("error_description") ? body.get("error_description").asText() : "No description";
                throw new IllegalStateException("Error getting access token: " + error + " - " + errorDescription);
            } else {
                throw new IllegalStateException("Access token not found");
            }
        }
    }
    public String getClientId() {
        return env.getProperty("oauth2.naver.client-id");
    }

    public String getClientSecret() {
        return env.getProperty("oauth2.naver.client-secret");
    }

    private NaverUsersInfo getUserInfo(String accessToken) throws IOException, ParseException {
        String userInfoUri = "https://openapi.naver.com/v1/nid/me";

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + accessToken);
        HttpEntity<?> entity = new HttpEntity<>(headers);

        ResponseEntity<JsonNode> response = restTemplate.exchange(userInfoUri, HttpMethod.GET, entity, JsonNode.class);
        JsonNode body = response.getBody();
        if (body != null) {
            JsonNode responseNode = body.get("response");

            String id = responseNode.has("id") ? responseNode.get("id").asText() : null;
            String email = responseNode.has("email") ? responseNode.get("email").asText() : null;
            String name = responseNode.has("name") ? responseNode.get("name").asText() : null;
            String nickname = responseNode.has("nickname") ? responseNode.get("nickname").asText() : null;
            String profileImage = responseNode.has("profile_image") ? responseNode.get("profile_image").asText() : null;
            String birthday = responseNode.has("birthday") ? responseNode.get("birthday").asText() : null;
            String age = responseNode.has("age") ? responseNode.get("age").asText() : null;
            String gender = responseNode.has("gender") ? responseNode.get("gender").asText() : null;
            String birthYear = responseNode.has("birthyear") ? responseNode.get("birthyear").asText() : null;
            String mobile = responseNode.has("mobile") ? responseNode.get("mobile").asText() : null;
            String provider = "naver";
            // Combine birthYear and birthday to form birthdate
            String birthdate = birthYear + "-" + birthday;

            return new NaverUsersInfo(id, email, name, nickname, profileImage, birthdate, age, gender, birthYear, mobile, provider);
        } else {
            throw new IllegalStateException("Failed to fetch user info from Naver");
        }
    }
    public String getAccessTokenFromAttributes(Map<String, Object> attributes) {
        return (String) attributes.get("access_token");
    }
}
