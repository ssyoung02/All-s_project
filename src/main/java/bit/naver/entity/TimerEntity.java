package bit.naver.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class TimerEntity {
    private Long record_idx;
    private Long user_idx;
    private LocalDateTime date;
    private LocalDateTime start_time;
    private LocalDateTime end_time;
    private Integer study_time;
    private String memo;
}
