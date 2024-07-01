package bit.naver.service;

import bit.naver.entity.TimerEntity;
import bit.naver.mapper.TimerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TimerService {
    @Autowired
    private TimerMapper timerMapper;
    final TimerEntity timerEntity = new TimerEntity();

    public Long startTimer(Long user_idx){

        timerEntity.setUser_idx(user_idx);
        timerMapper.insertStartTime(timerEntity);

        return timerEntity.getRecord_idx();
    }

    public String pauseTimer(Long user_idx, int study_time) {
        timerEntity.setUser_idx(user_idx);
        timerEntity.setStudy_time(study_time);
        int result = timerMapper.updateEndTime(timerEntity);
        if (result == 1) {
            return "성공하였습니다.";
        }else{
            return "실패하였습니다.";
        }
    }

    public String updateMemo(Long user_idx, String memo) {
        timerEntity.setUser_idx(user_idx);
        timerEntity.setMemo(memo);
        int result =timerMapper.updateMemo(timerEntity);
        if(result == 1){
            return "시간 메모가 기록되었습니다";
        }else {
            return "메모 기록에 실패했습니다";
        }
    }

    public List<TimerEntity> getWeeklyStudyTime(Long userIdx, LocalDate startDate, LocalDate endDate) {
        System.out.println(userIdx);
        System.out.println(startDate);
        System.out.println(endDate);

        return timerMapper.getStudyTimeBetweenDates(userIdx, startDate, endDate);
    }

    public Map<String, List<TimerEntity>> getCurrentAndPreviousWeekStudyTime(Long userIdx) {
        LocalDate today = LocalDate.now();

        // 한 주의 시작을 일요일로 하여 start, end 구하기
        LocalDate startOfCurrentWeek = today.minusDays((today.getDayOfWeek().getValue() % 7));
        LocalDate endOfCurrentWeek = startOfCurrentWeek.plusDays(6);

        // 전 주의 날짜 구하기
        LocalDate startOfPreviousWeek = startOfCurrentWeek.minusDays(7);
        LocalDate endOfPreviousWeek = startOfCurrentWeek.minusDays(1);

        // 이번주, 전주 공부 시간 구하기
        List<TimerEntity> currentWeek = getWeeklyStudyTime(userIdx, startOfCurrentWeek, endOfCurrentWeek);
        List<TimerEntity> previousWeek = getWeeklyStudyTime(userIdx, startOfPreviousWeek, endOfPreviousWeek);

        Map<String, List<TimerEntity>> result = new HashMap<>();
        result.put("currentWeek", currentWeek);
        result.put("previousWeek", previousWeek);

        return result;
    }

    public List<TimerEntity> getMonthlyStudyTime(Long userIdx, LocalDate startOfMonth, LocalDate endOfMonth) {
        return timerMapper.getMonthlyStudyTime(userIdx, startOfMonth, endOfMonth);
    }

    public String getGradeIconByUserIdx(int userIdx) {
        String gradeIcon = timerMapper.getGradeIconByTotalStudyTime(userIdx);
        System.out.println("gradeIcon: "+gradeIcon);
        return gradeIcon;
    }

}
