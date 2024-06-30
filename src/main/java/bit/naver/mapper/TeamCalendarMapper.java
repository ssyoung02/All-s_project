package bit.naver.mapper;

import bit.naver.entity.TeamCalendar;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TeamCalendarMapper {
    void insertTeamCalendar(TeamCalendar teamCalendar);
    List<TeamCalendar> selectAllTeamCalendarsByStudyIdx(Long studyIdx);
    TeamCalendar selectTeamCalendarByIdx(Long teamScheduleIdx);
    void updateTeamCalendar(TeamCalendar teamCalendar);
    void deleteTeamCalendar(Long teamScheduleIdx);
}
