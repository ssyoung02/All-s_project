package bit.naver.entity;

import lombok.Data;

import javax.validation.constraints.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Users implements Serializable {

    private Long userIdx;



    private String username;


    private String password;


    private String email;

    private String name;

    private LocalDate birthdate;

    private String profileImage ;
    private Boolean enabled;
    private Long gradeIdx;
    private String provider;
    private Double latitude;
    private Double longitude;


    private String gender; // String 타입 유지

    private String mobile; //휴대전화번호
    private Boolean socialLogin;
//    private String socialLogin; // 소셜 로그인 방식 ("KAKAO" 또는 "GOOGLE" 등)

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private int total_study_time;
    private int today_study_time;

    public enum Gender { // Gender 열거형 유지
        M, F, OTHER
    }

}
