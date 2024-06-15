package bit.naver.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class StudyReferencesEntity {

    private Long referenceIdx;
    private Long userIdx;
    private String title;
    private Boolean isPrivate;
    private String content;
    private String fileAttachments;
    private Integer likesCount;
    private Integer commentsCount;
    private Integer viewsCount;
    private Integer reportCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String name;
    private String TOTALCOUNT;

    private Integer isLike;
}
