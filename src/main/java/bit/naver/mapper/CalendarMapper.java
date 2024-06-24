package bit.naver.mapper;

import bit.naver.entity.Calendar;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CalendarMapper {
    void insertCalendar(Calendar calendar);
    List<Calendar> selectAllCalendarsByUserIdx(Long userIdx);
    Calendar selectCalendarByIdx(Long scheduleIdx);
    void updateCalendar(Calendar calendar);
    void deleteCalendar(Long scheduleIdx);
}
