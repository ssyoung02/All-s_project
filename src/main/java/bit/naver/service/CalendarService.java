package bit.naver.service;

import bit.naver.entity.Calendar;
import bit.naver.mapper.CalendarMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CalendarService {

    @Autowired
    private CalendarMapper calendarMapper;

    public void saveCalendar(Calendar calendar) {
        calendarMapper.insertCalendar(calendar);
    }

    public List<Calendar> getAllCalendars(Long userIdx) {
        return calendarMapper.selectAllCalendarsByUserIdx(userIdx);
    }

    public Calendar getCalendarByIdx(Long scheduleIdx) {
        return calendarMapper.selectCalendarByIdx(scheduleIdx);
    }

    public void updateCalendar(Calendar calendar) {
        calendarMapper.updateCalendar(calendar);
    }

    public void deleteCalendar(Long scheduleIdx) {
        calendarMapper.deleteCalendar(scheduleIdx);
    }
}
