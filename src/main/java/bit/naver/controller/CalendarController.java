package bit.naver.controller;

import bit.naver.entity.Calendar;
import bit.naver.entity.Users;
import bit.naver.security.UsersUser;
import bit.naver.service.CalendarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CalendarController {

    @Autowired
    private CalendarService calendarService;

    @RequestMapping("/calendar") // 캘린더 메인 페이지 요청 매핑
    public String calendarMain() {
        return "calendar/calendarMain";
    }

    @PostMapping("/calendar/addSchedule") // userIdx 경로 변수 제거
    @ResponseBody  // JSON 형태로 응답을 반환하도록 설정
    public Map<String, String> addSchedule(@Valid @ModelAttribute Calendar calendar,
                                           BindingResult bindingResult,
                                           @AuthenticationPrincipal UsersUser usersUser) {
        Map<String, String> response = new HashMap<>();

        if (bindingResult.hasErrors()) {
            response.put("result", "fail");
            response.put("error", bindingResult.getFieldError().getDefaultMessage());
            return response;
        }

        try {
            Users user = usersUser.getUsers();
            Long userIdx = user.getUserIdx();
            calendar.setUserIdx(userIdx);
            calendar.setCalIdx(userIdx); // calIdx 설정 (userIdx와 동일하게 설정)

            calendarService.saveCalendar(calendar);

            response.put("result", "success");
            response.put("refetch", "true");
        } catch (Exception e) {
            response.put("result", "fail");
            response.put("error", "일정 추가 중 오류가 발생했습니다.");
            e.printStackTrace(); // 오류 로그 출력
        }

        return response;
    }


    @GetMapping("/calendar/events")
    @ResponseBody
    public List<Calendar> getCalendarEvents(@AuthenticationPrincipal UsersUser usersUser) {
        return calendarService.getAllCalendars(usersUser.getUsers().getUserIdx());
    }

    @GetMapping("/calendar/event/{scheduleIdx}")
    @ResponseBody
    public Calendar getCalendarEvent(@PathVariable Long scheduleIdx) {
        return calendarService.getCalendarByIdx(scheduleIdx);
    }

    @PostMapping("/calendar/updateSchedule")
    @ResponseBody
    public Map<String, String> updateSchedule(@Valid @ModelAttribute Calendar calendar,
                                              BindingResult bindingResult,
                                              @AuthenticationPrincipal UsersUser usersUser) {
        // 유효성 검사 실패 시 오류 메시지 반환
        if (bindingResult.hasErrors()) {
            Map<String, String> response = new HashMap<>();
            response.put("result", "fail");
            response.put("error", bindingResult.getFieldError().getDefaultMessage());
            return response;
        }

        // 사용자 인덱스 가져오기
        Long userIdx = usersUser.getUsers().getUserIdx();
        calendar.setUserIdx(userIdx);

        // 캘린더 서비스를 통해 업데이트
        try {
            calendarService.updateCalendar(calendar);
            Map<String, String> response = new HashMap<>();
            response.put("result", "success");
            response.put("refetch", "true");
            return response;
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("result", "fail");
            response.put("error", "일정 수정 중 오류가 발생했습니다.");
            return response;
        }
    }

    @PostMapping("/calendar/deleteSchedule/{eventId}")
    @ResponseBody
    public Map<String, String> deleteSchedule(@PathVariable Long eventId) {
        try {
            calendarService.deleteCalendar(eventId);

            Map<String, String> response = new HashMap<>();
            response.put("result", "success");
            response.put("refetch", "true");
            return response;
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("result", "fail");
            response.put("error", "일정 삭제 중 오류가 발생했습니다.");
            return response;
        }
    }
}
