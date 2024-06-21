package bit.naver.service;

import bit.naver.entity.Calendar;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CalendarService {

    // 사용자별 캘린더 데이터 저장 (Map 사용)
    private Map<Long, List<Calendar>> userCalendars = new HashMap<>();

    public void saveCalendar(Calendar calendar) {
        long userIdx = calendar.getUserIdx();
        List<Calendar> userCalendarList = userCalendars.computeIfAbsent(userIdx, k -> new ArrayList<>());
        userCalendarList.add(calendar);
    }

    public List<Calendar> getAllCalendars(long userIdx) {
        return userCalendars.getOrDefault(userIdx, new ArrayList<>());
    }
}
