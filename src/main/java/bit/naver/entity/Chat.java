package bit.naver.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Chat {

    private Long chatId;
    private Long studyIdx;
    private Long userIdx;
    private String messageContent;
    private LocalDateTime messageRegdate;
    private String userName;

}
