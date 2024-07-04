package bit.naver.controller;

import bit.naver.entity.TimerEntity;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.TimerService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.*;

@Controller
@RequestMapping("/include")
@RequiredArgsConstructor
public class TimerController {

    @Autowired
    private UsersMapper usersMapper;

    @Autowired
    private TimerService timerService;

    private final UsersUserDetailsService usersUserDetailsService;



    @PostMapping("/start")
    public ResponseEntity<Long> startTimer(@RequestBody Map<String, Long> request) {
        Long user_idx = request.get("user_idx");

        // 공부 시작 시 activityStatus 업데이트
        Users user = usersMapper.findById(user_idx);
        if (user != null) {
            user.setActivityStatus(Users.ActivityStatus.STUDYING);
            usersMapper.updateActivityStatus(user_idx, user.getActivityStatus());
        }

        System.out.println("user_idx: " + user_idx);
        Long recordIdx = timerService.startTimer(user_idx);
        return ResponseEntity.ok(recordIdx);
    }

    @PostMapping("/pause")
    public ResponseEntity<String> pauseTimer(@RequestParam("userIdx") Long user_idx, @RequestParam("study_time") int study_time, HttpSession session) {
        System.out.println(user_idx + ": " + study_time);
        // 공부 일시 정지 시 activityStatus 업데이트
        Users user = usersMapper.findById(user_idx);
        if (user != null) {
            user.setActivityStatus(Users.ActivityStatus.RESTING);
            usersMapper.updateActivityStatus(user_idx, user.getActivityStatus());
        }

        timerService.pauseTimer(user_idx, study_time);
        return ResponseEntity.ok("처리 완료");
    }

    @GetMapping("/updateTime")
    @ResponseBody
    public Users getUpdateTime(@RequestParam("userIdx") Long userIdx, HttpSession session) {
        try {
            Users updateUser = usersMapper.findById(userIdx);

            // 공부 종료 후 다시 로그인 시 activityStatus 업데이트
            if (session.getAttribute("userVo") != null) {
                Users loggedInUser = (Users) session.getAttribute("userVo");
                loggedInUser.setActivityStatus(Users.ActivityStatus.ACTIVE);
                usersMapper.updateActivityStatus(loggedInUser.getUserIdx(), loggedInUser.getActivityStatus());
                session.setAttribute("userVo", loggedInUser); // 세션 정보 갱신
            }

            System.out.println("updateuser data: " + updateUser);
            return updateUser;
        } catch (Exception e) {
            e.printStackTrace();
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Server Error");
        }
    }

    @PostMapping("/updateMemo")
    public ResponseEntity<String> updateMemo(@RequestParam("user_idx") Long user_idx, @RequestParam("memo") String memo) {
        System.out.println(user_idx+": "+memo);
        timerService.updateMemo(user_idx, memo);
        return ResponseEntity.ok("처리 완료");
    }

    @GetMapping("/study-time")
    @ResponseBody
    public Map<String, List<TimerEntity>> getStudyTime(@RequestParam("userIdx") Long userIdx) {
        try {
            Map<String, List<TimerEntity>> result = timerService.getCurrentAndPreviousWeekStudyTime(userIdx);
            System.out.println("Response data: " + result);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Server Error");
        }
    }

    @GetMapping("/monthly")
    @ResponseBody
    public Map<String, Object> getMonthlyStudyTime(@RequestParam("userIdx") Long userIdx) {
        YearMonth currentMonth = YearMonth.now();
        LocalDate startOfMonth = currentMonth.atDay(1);
        LocalDate endOfMonth = currentMonth.atEndOfMonth();

        List<TimerEntity> monthlyStudyTime = timerService.getMonthlyStudyTime(userIdx, startOfMonth, endOfMonth);

        // Map to store date and study_time, safely handling null values
        Map<LocalDate, Integer> studyTimeMap = new HashMap<>();
        for (TimerEntity entity : monthlyStudyTime) {
            LocalDate date = LocalDate.from(entity.getDate()); // entity.getDate() returns LocalDateTime
            Integer studyTime = entity.getStudy_time(); // getStudy_time() returns Integer or null
            if (studyTime == null) {
                studyTime = 0; // null인 경우 0
            }
            studyTimeMap.put(date, studyTime);
        }

        List<Map<String, Object>> studyTimes = new ArrayList<>();
        for (int day = 1; day <= currentMonth.lengthOfMonth(); day++) {
            LocalDate date = currentMonth.atDay(day);
            Map<String, Object> record = new HashMap<>();
            record.put("date", date.toString());
            record.put("studytime", studyTimeMap.getOrDefault(date, 0));
            studyTimes.add(record);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("monthlyStudyTime", studyTimes);

        return response;
    }

    @GetMapping("/userGrades")
    @ResponseBody
    public String getUserGradeIcon(@RequestParam("user_idx") int userIdx) {
        String gradeIcon = timerService.getGradeIconByUserIdx(userIdx);
        System.out.println("gradeIcon : "+gradeIcon);
        return gradeIcon;
    }

}
