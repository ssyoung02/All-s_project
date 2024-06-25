package bit.naver.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class StudyMembers {
    private Long studyIdx;

    private Long userIdx;

    private String role;

    private String status;

    private String joinReason;

    private String notificationSettings;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private String userName; // Join된 사용자 이름

    // DB에 없는 부분
    private String name;

    public String getStudyTime() {

        return "";
    }
}
