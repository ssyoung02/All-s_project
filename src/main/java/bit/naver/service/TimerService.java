package bit.naver.service;

import bit.naver.entity.TimerEntity;
import bit.naver.mapper.TimerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
            return "삭제에 성공하였습니다.";
        }else{
            return "삭제에 실패하였습니다.";
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


}
