package bit.naver.entity;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class StudyReferencesEntity {

    private Long referenceIdx;
    private Long userIdx;
    private String title;
    private Boolean isPrivate;
    private String content;
    private byte[] fileAttachments;
    private String fileName;
    private Integer likesCount;
    private Integer commentsCount;
    private Integer viewsCount;
    private Integer reportCount;
    private String createdAt;
    private LocalDateTime updatedAt;

    private String name;
    private String TOTALCOUNT;

    private Integer isLike;
}
