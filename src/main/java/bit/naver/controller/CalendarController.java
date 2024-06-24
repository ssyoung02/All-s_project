package bit.naver.controller;

import bit.naver.entity.Calendar;
import bit.naver.entity.Users;
import bit.naver.security.UsersUser;
import bit.naver.service.CalendarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CalendarController {

    @Autowired
    private CalendarService calendarService;

    @RequestMapping("/calendar/calendarMain")
    public String calendarMain() {
        return "calendar/calendarMain";
    }

    @PostMapping("/calendar/addSchedule")
    @ResponseBody  // JSON 형태로 응답을 반환하도록 설정
    public Map<String, String> addSchedule(@ModelAttribute Calendar calendar,
                                           @RequestParam("startTime") String startTime,
                                           @RequestParam("endTime") String endTime,
                                           @AuthenticationPrincipal UsersUser usersUser) {

        Users user = usersUser.getUsers();
        Long userIdx = user.getUserIdx();

        // calendar 객체에 userIdx 설정
        calendar.setUserIdx(userIdx);
        calendar.setCalIdx(userIdx);

        // 날짜 및 시간 문자열 조합 (start, end)
        String startDateTime = calendar.getStart() + "T" + startTime;
        String endDateTime = (calendar.getEnd() != null && endTime != null) ?
                calendar.getEnd() + "T" + endTime : null;

        calendar.setStart(startDateTime);
        calendar.setEnd(endDateTime);

        //int allDayInt = Integer.parseInt(calendar.getAllDay());
        //calendar.setAllDay(allDayInt);

        calendarService.saveCalendar(calendar);

        // 성공 응답 반환
        Map<String, String> response = new HashMap<>();
        response.put("result", "success");
        return response;
    }

    @GetMapping("/calendar/events")
    @ResponseBody
    public List<Calendar> getCalendarEvents(@AuthenticationPrincipal UsersUser usersUser) {
        return calendarService.getAllCalendars(usersUser.getUsers().getUserIdx());
    }
}