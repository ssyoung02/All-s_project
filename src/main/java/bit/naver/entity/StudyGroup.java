package bit.naver.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class StudyGroup {


    private Long studyIdx;

    private Long studyLeaderIdx;

    private String studyTitle;

    private String descriptionTitle;

    private int likesCount;

    private int reportCount;

    private String description;

    private String category;

    private boolean studyOnline;

    private String meetingTime;

    private Double latitude;

    private Double longitude;

    private String age;

    private int capacity;

    private String gender;

    private Date startDate;

    private Date endDate;

    private String image;

    private StudyStatus status;

    private Date createdAt;

    // DB에 없는 엔티티
    private String leaderName;


}
