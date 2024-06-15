package bit.naver.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class LikeReferencesEntity {

    private Long likeReferIdx;
    private Long userIdx;
    private Long referenceIdx;
    private LocalDateTime createdAt;
}
