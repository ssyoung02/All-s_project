package bit.naver.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Data
public class TimerEntity {
    private Long record_idx;
    private Long user_idx;

    @JsonFormat(pattern="yyyy-MM-dd")
    private LocalDateTime date;

    @JsonFormat(pattern="yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime start_time;

    @JsonFormat(pattern="yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime end_time;

    private Integer study_time;
    private String memo;

}
