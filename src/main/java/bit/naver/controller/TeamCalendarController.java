package bit.naver.controller;

import bit.naver.entity.TeamCalendar;
import bit.naver.security.UsersUser;
import bit.naver.service.TeamCalendarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/calendar")
public class TeamCalendarController {

    @Autowired
    private TeamCalendarService teamCalendarService;

    // 팀 일정 추가
    @PostMapping("/addTeamSchedule")
    @ResponseBody
    public Map<String, String> addTeamSchedule(@Valid @ModelAttribute TeamCalendar teamCalendar,
                                               BindingResult bindingResult) {
        Map<String, String> response = new HashMap<>();

        if (bindingResult.hasErrors()) {
            response.put("result", "fail");
            response.put("error", bindingResult.getFieldError().getDefaultMessage());
            return response;
        }

        try {
            // studyIdx를 teamCalIdx에 설정
            teamCalendar.setTeamCalIdx(teamCalendar.getStudyIdx());

            teamCalendarService.saveCalendar(teamCalendar);
            response.put("result", "success");
            response.put("refetch", "true");
        } catch (Exception e) {
            response.put("result", "fail");
            response.put("error", "일정 추가 중 오류가 발생했습니다.");
            e.printStackTrace();
        }

        return response;
    }

    // 스터디 그룹의 모든 일정 가져오기
    @GetMapping("/teamEvents/{studyIdx}")
    @ResponseBody
    public ResponseEntity<List<TeamCalendar>> getTeamCalendarEvents(@PathVariable Long studyIdx) {
        List<TeamCalendar> events = teamCalendarService.getAllCalendars(studyIdx);
        return new ResponseEntity<>(events, HttpStatus.OK);
    }

    // 특정 팀 일정 가져오기
    @GetMapping("/teamEvent/{teamScheduleIdx}")
    @ResponseBody
    public ResponseEntity<TeamCalendar> getTeamCalendarEvent(@PathVariable Long teamScheduleIdx) {
        TeamCalendar event = teamCalendarService.getCalendarByIdx(teamScheduleIdx);
        return new ResponseEntity<>(event, HttpStatus.OK);
    }

    // 팀 일정 수정
    @PostMapping("/updateTeamSchedule")
    @ResponseBody
    public Map<String, String> updateTeamSchedule(@Valid @ModelAttribute TeamCalendar teamCalendar,
                                                  BindingResult bindingResult) {
        Map<String, String> response = new HashMap<>();

        if (bindingResult.hasErrors()) {
            response.put("result", "fail");
            response.put("error", bindingResult.getFieldError().getDefaultMessage());
            return response;
        }

        try {
            teamCalendarService.updateCalendar(teamCalendar); // 팀 캘린더 수정
            response.put("result", "success");
            response.put("refetch", "true"); // 캘린더 다시 불러오도록 설정
        } catch (Exception e) {
            response.put("result", "fail");
            response.put("error", "일정 수정 중 오류가 발생했습니다.");
            e.printStackTrace();
        }

        return response;
    }

    // 팀 일정 삭제
    @DeleteMapping("/deleteTeamSchedule/{teamScheduleIdx}")
    @ResponseBody
    public Map<String, String> deleteTeamSchedule(@PathVariable Long teamScheduleIdx) {
        Map<String, String> response = new HashMap<>();

        try {
            teamCalendarService.deleteCalendar(teamScheduleIdx); // 팀 캘린더 삭제
            response.put("result", "success");
            response.put("refetch", "true"); // 캘린더 다시 불러오도록 설정
        } catch (Exception e) {
            response.put("result", "fail");
            response.put("error", "일정 삭제 중 오류가 발생했습니다.");
            e.printStackTrace();
        }

        return response;
    }
}
