package bit.naver.entity;

import lombok.Data;

@Data
public class Calendar {
    private int calIdx;
    private int userIdx;
    private String title;
    private String schedule;
    private String startDate;
    private String endDate;
    private int allDay;
    private String location;
    private String category;
    private String reminder;
    private String backgroundColor;
    private enum recurring{
        Daily, WEEKLY, MONTHLY, NONE
    }
    private int shared;
    private enum importance{
        HIGH, MEDIUM, LOW
    }
}
