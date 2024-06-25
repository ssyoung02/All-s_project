package bit.naver.service;

import bit.naver.entity.TeamCalendar;
import bit.naver.mapper.TeamCalendarMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeamCalendarService {

    @Autowired
    private TeamCalendarMapper teamCalendarMapper;

    public void saveCalendar(TeamCalendar teamCalendar) {
        teamCalendarMapper.insertTeamCalendar(teamCalendar);
    }

    public List<TeamCalendar> getAllCalendars(Long studyIdx) {
        return teamCalendarMapper.selectAllTeamCalendarsByStudyIdx(studyIdx);
    }

    public TeamCalendar getCalendarByIdx(Long teamScheduleIdx) {
        return teamCalendarMapper.selectTeamCalendarByIdx(teamScheduleIdx);
    }

    public void updateCalendar(TeamCalendar teamCalendar) {
        teamCalendarMapper.updateTeamCalendar(teamCalendar);
    }

    public void deleteCalendar(Long teamScheduleIdx) {
        teamCalendarMapper.deleteTeamCalendar(teamScheduleIdx);
    }
}
