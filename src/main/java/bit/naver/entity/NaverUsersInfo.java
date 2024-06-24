package bit.naver.entity;

import lombok.Data;

@Data
public class NaverUsersInfo {
    private String id;
    private String email;
    private String name;
    private String nickname;
    private String profileImage;
    private String birthday;
    private String age;
    private String gender;
    private String birthYear;
    private String mobile;
    private String birthdate; // Combined birthdate
    private String provider;

    // Existing constructor (if any)

    // New constructor with birthdate
    public NaverUsersInfo(String id, String email, String name, String nickname, String profileImage,
                          String birthdate, String age, String gender, String birthYear, String mobile, String provider) {
        this.id = id;
        this.email = email;
        this.name = name;
        this.nickname = nickname;
        this.profileImage = profileImage;
        this.birthdate = birthdate;
        this.age = age;
        this.gender = gender;
        this.birthYear = birthYear;
        this.mobile = mobile;
        this.provider="naver";

    }

}
