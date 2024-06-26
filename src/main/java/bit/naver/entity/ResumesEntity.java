package bit.naver.entity;

import lombok.Data;

@Data
public class ResumesEntity {

    private Long resumeIdx;
    private Long userIdx;
    private byte[] resumePath;
    private String createdAt;
    private String updatedAt;
    private String fileName;

}
