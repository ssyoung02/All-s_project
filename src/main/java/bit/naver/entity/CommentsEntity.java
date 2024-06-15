package bit.naver.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CommentsEntity {

    private Long commentIdx;
    private Long userIdx;
    private Long referenceIdx;
    private String content;
    private LocalDateTime createdAt;

    private String name;
    private String TOTALCOUNT;

}
