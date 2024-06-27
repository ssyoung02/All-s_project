package bit.naver.entity;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Data;

@Data
public class StudyReferencesEntity {

    private Long referenceIdx;
    private Long userIdx;
    private String username;
    private String title;
    private Boolean isPrivate;
    private String content;
    private byte[] fileAttachments;
    private String fileName;
    private Integer likesCount;
    private Integer commentsCount;
    private Integer viewsCount;
    private Integer reportCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String name;
    private String TOTALCOUNT;

    private Integer isLike;

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
