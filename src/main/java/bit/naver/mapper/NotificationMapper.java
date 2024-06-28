package bit.naver.mapper;

import bit.naver.entity.NotificationEntity;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface NotificationMapper {

    void createNotification(NotificationEntity notification);

    List<NotificationEntity> getAlarmInfo(Long userIdx);

}
