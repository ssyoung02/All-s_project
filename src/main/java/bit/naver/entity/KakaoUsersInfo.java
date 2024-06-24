package bit.naver.entity;

import lombok.Data;

@Data
public class KakaoUsersInfo {
    private String name;
    private String email;
    private String profileImage; // 프로필 이미지 URL 필드 추가
    private String provider;

    public KakaoUsersInfo(String name, String email, String profileImage, String provider) {
        this.name = name;
        this.email = email;
        this.profileImage = profileImage;
        this.provider ="kakao";
    }


}