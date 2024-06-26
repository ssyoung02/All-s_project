package bit.naver.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class LikeStudyEntity {

    private Long likeStudyIdx;
    private Long userIdx;
    private Long studyIdx;
    private LocalDateTime createdAt;
}
