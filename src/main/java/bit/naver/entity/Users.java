package bit.naver.entity;

import lombok.AllArgsConstructor;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.apache.ibatis.mapping.FetchType;
import org.springframework.security.core.GrantedAuthority;

import javax.validation.constraints.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Users implements Serializable {

    private Long userIdx;

    private String username;

    private String password;

    private String email;

    private String name;

    private LocalDate birthdate;

    private String profileImage ;

    private Boolean enabled;

    private String provider;

    private Double latitude;

    private Double longitude;

    private String gender; // String 타입 유지

    private String mobile; //휴대전화번호

    private Boolean socialLogin;
//    private String socialLogin; // 소셜 로그인 방식 ("KAKAO" 또는 "GOOGLE" 등)

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private int totalStudyTime=0;

    private int todayStudyTime=0;

    private String gradeName;

    public enum Gender { // Gender 열거형 유지
        M, F, OTHER
    }

    private String authorityName;

    private String formattedCreatedAt;


    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
        if (createdAt != null) {
            this.formattedCreatedAt = createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        } else {
            this.formattedCreatedAt = "";
        }
    }

}
