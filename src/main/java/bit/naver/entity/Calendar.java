package bit.naver.entity;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Data
public class Calendar {
    private Long scheduleIdx;
    private Long calIdx;
    private Long userIdx;

    private String title;

    private String description;

    private String start; // 시작 날짜 및 시간 (YYYY-MM-DDTHH:mm 형식)

    private String end; // 종료 날짜 및 시간 (YYYY-MM-DDTHH:mm 형식)

    private int allDay; // 종일 여부 (0: 아니오, 1: 예)

    private String location;
    
    private String reminder; // 알림 시간 (YYYY-MM-DDTHH:mm 형식)

    @NotBlank(message = "배경색을 지정해주세요.")
    private String backgroundColor;
}
