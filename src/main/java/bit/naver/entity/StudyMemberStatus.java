package bit.naver.entity;

import lombok.Data;

@Data
// 스터디 멤버 상태 정보를 담는 DTO 클래스
public class StudyMemberStatus {
    private Long userIdx;
    private String username;
    private String name;
    private String activityStatus;
    private String profile_image;
}
