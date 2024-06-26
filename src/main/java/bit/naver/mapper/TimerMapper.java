package bit.naver.mapper;

import bit.naver.entity.TimerEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface TimerMapper {

    @Options(useGeneratedKeys = true, keyProperty = "record_idx", keyColumn = "record_idx")
    void insertStartTime(TimerEntity timerEntity);

    int updateEndTime(TimerEntity timer);
    int updateMemo(TimerEntity timer);

    List<TimerEntity> getStudyTimeBetweenDates(@Param("userIdx") Long userIdx,
                                               @Param("startDate") LocalDate startDate,
                                               @Param("endDate") LocalDate endDate);

    List<TimerEntity> getMonthlyStudyTime(@Param("userIdx") Long userIdx,
                                          @Param("startOfMonth") LocalDate startOfMonth,
                                          @Param("endOfMonth") LocalDate endOfMonth);
}
