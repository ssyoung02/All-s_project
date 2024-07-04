package bit.naver.entity;

import lombok.Data;

@Data
public class StudyList {

    private Long studyIdx;

    private String role;

    private String studyTitle;

    private String descriptionTitle;

    private String description;

    private String status;

    private String image;
}
