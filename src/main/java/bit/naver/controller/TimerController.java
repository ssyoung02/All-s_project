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
import org.springframework.web.bind.annotation.*;

import java.util.Map;

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
        System.out.println("user_idx: " + user_idx);
        Long recordIdx = timerService.startTimer(user_idx);
        return ResponseEntity.ok(recordIdx);
    }

    @PostMapping("/pause")
    public ResponseEntity<String> pauseTimer(@RequestParam("userIdx") Long user_idx, @RequestParam("study_time") int study_time) {
        System.out.println(user_idx+": "+study_time);
        timerService.pauseTimer(user_idx, study_time);
        return ResponseEntity.ok("처리 완료");
    }

    @PostMapping("/updateMemo")
    public ResponseEntity<String> updateMemo(@RequestParam("user_idx") Long user_idx, @RequestParam("memo") String memo) {
        System.out.println(user_idx+": "+memo);
        timerService.updateMemo(user_idx, memo);
        return ResponseEntity.ok("처리 완료");
    }

}
