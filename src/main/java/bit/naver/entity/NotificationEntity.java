package bit.naver.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class NotificationEntity {


    private Long notificationIdx;


    private Long leaderIdx;

    private Long studyIdx;

    private Long referenceIdx;

    private NotifyType notifyType;

    private LocalDateTime createdAt;

    public enum NotifyType {
        STUDY_INVITE, SCHEDULE, NEW_POST, NEW_COMMENT, STUDY_UPDATE
    }

    // 알람 메시지를 생성하는 메서드
    public String getAlarmMessage() {
        switch (this.notifyType) {
            case STUDY_INVITE:
                return "스터디 모집 알림이 있습니다.";
            case SCHEDULE:
                return "새로운 일정이 추가되었습니다.";
            case NEW_POST:
                return "새로운 게시물이 작성되었습니다.";
            case NEW_COMMENT:
                return "댓글이 달렸습니다.";
            case STUDY_UPDATE:
                return "스터디 내용이 업데이트되었습니다.";
            default:
                return "새로운 알림이 있습니다.";
        }
    }
}
