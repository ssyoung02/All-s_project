package bit.naver.mapper;

import bit.naver.entity.TimerEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;

@Mapper
public interface TimerMapper {

    @Options(useGeneratedKeys = true, keyProperty = "record_idx", keyColumn = "record_idx")
    void insertStartTime(TimerEntity timerEntity);

    int updateEndTime(TimerEntity timer);
    int updateMemo(TimerEntity timer);

    Long totalStudyTime(Long user_idx);
    Long todayStudyTime(Long user_idx);
}
