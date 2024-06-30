package bit.naver.service;

import bit.naver.mapper.UsersMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

@Service
public class CustomAccountDeletionService {

    private final NaverLoginService naverLoginService;
    private final KakaoLoginService kakaoLoginService;
    private final GoogleLoginService googleLoginService;
    private final UsersMapper usersMapper;

    @Autowired
    public CustomAccountDeletionService(NaverLoginService naverLoginService, KakaoLoginService kakaoLoginService, GoogleLoginService googleLoginService, UsersMapper usersMapper) {
        this.naverLoginService = naverLoginService;
        this.kakaoLoginService = kakaoLoginService;
        this.googleLoginService = googleLoginService;
        this.usersMapper = usersMapper;
    }

    @Transactional
    public void deleteUserAccount(String username, String provider, String accessToken) {
        Long userId = usersMapper.findUserIdByUsername(username);

        // 소셜 계정 토큰 해지
        if (provider != null) {
            switch (provider) {
                case "google":
                    revokeGoogleToken(accessToken);
                    break;
                case "kakao":
                    unlinkKakao(accessToken);
                    break;
                case "naver":
                    unlinkNaver(accessToken);
                    break;
                default:
                    throw new IllegalArgumentException("Unknown provider: " + provider);
            }
        }

        // Delete related data
        usersMapper.deleteUserAuthorities(username);
        usersMapper.deleteUserCalendars(userId);
        usersMapper.deleteUserOAuth2Logins(userId);
        usersMapper.deleteUserPersonalStatements(userId);
        usersMapper.deleteUserResumes(userId);
        usersMapper.deleteUserStudyMembers(userId);
        usersMapper.deleteUserChats(userId);
        usersMapper.deleteUserLikeStudies(userId);
        usersMapper.deleteUserNotifications(userId);
        usersMapper.deleteUserStudyRecords(userId);
        usersMapper.deleteUserStudyReferences(userId);
        usersMapper.deleteUserComments(userId);
        usersMapper.deleteUserLikeReferences(userId);
        usersMapper.deleteUserTodos(userId);

        // Delete user data
        usersMapper.deleteUser(userId);
    }

    private void revokeGoogleToken(String accessToken) {
        String requestUrl = "https://accounts.google.com/o/oauth2/revoke?token=" + accessToken;
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.postForEntity(requestUrl, null, String.class);
    }

    private void unlinkKakao(String accessToken) {
        String requestUrl = "https://kapi.kakao.com/v1/user/unlink";
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);

        HttpEntity<String> entity = new HttpEntity<>("", headers);
        restTemplate.exchange(requestUrl, HttpMethod.POST, entity, String.class);
    }

    private void unlinkNaver(String accessToken) {
        String requestUrl = "https://nid.naver.com/oauth2.0/token?grant_type=delete&client_id=" +
                naverLoginService.getClientId() + "&client_secret=" + naverLoginService.getClientSecret() +
                "&access_token=" + accessToken + "&service_provider=NAVER";
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.postForEntity(requestUrl, null, String.class);
    }
}
