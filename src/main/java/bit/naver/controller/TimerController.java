package bit.naver.controller;

import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.StudyReferencesService;
import bit.naver.service.TimerService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
    public Long startTimer(@RequestParam("userIdx") Long user_idx) {
        System.out.println("userIdx");
        return timerService.startTimer(user_idx);
    }

    @PostMapping("/pause")
    public String pauseTimer(@RequestParam("userIdx") Long user_idx, @RequestParam("studyTime") int study_time) {
        System.out.println(user_idx+": "+study_time);
        return timerService.pauseTimer(user_idx, study_time);
    }

    @PostMapping("/end")
    public String endTimer(@RequestParam("user_idx") Long user_idx, @RequestParam("studyTime") int study_time) {
        System.out.println(user_idx+": "+study_time);
        return timerService.endTimer(user_idx, study_time);
    }

    @PostMapping("/updateMemo")
    public String updateMemo(@RequestParam("user_idx") Long user_idx, @RequestParam("memo") String memo) {
        System.out.println(user_idx+": "+memo);
        return timerService.updateMemo(user_idx, memo);
    }

}
