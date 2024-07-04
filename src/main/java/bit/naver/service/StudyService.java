package bit.naver.service;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyMemberStatus;
import bit.naver.entity.StudyMembers;
import bit.naver.entity.Users;
import bit.naver.mapper.StudyGroupMapper;
import bit.naver.mapper.UsersMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class StudyService {
    @Autowired
    private UsersMapper usersMapper;
    @Autowired
    private StudyGroupMapper studyMapper;
    @Autowired
    private StudyGroupMapper studyGroupMapper;


    public boolean isStudyMember(Long userIdx, Long studyIdx) {
        StudyMembers member = studyMapper.getStudyMember(studyIdx, userIdx);
        return member != null && member.getStatus().equals("ACCEPTED"); // ACCEPTED 상태인 멤버만 참여 중으로 간주
    }
    public List<StudyMemberStatus> getStudyMemberStatus(Long studyIdx) {
        // 예외 처리: 스터디 정보가 없는 경우
        StudyGroup studyGroup = studyMapper.getStudyById(studyIdx);
        if (studyGroup == null) {
            System.out.println("스터디 정보를 찾을 수 없습니다. studyIdx: " + studyIdx);
            return null;
        }

        List<StudyMembers> members = studyMapper.getStudyMembers(studyIdx);
        List<StudyMemberStatus> memberStatusList = new ArrayList<>();

        for (StudyMembers member : members) {
            Users user = usersMapper.findById(member.getUserIdx());
            if (user != null) {
                StudyMemberStatus status = new StudyMemberStatus();
                status.setUserIdx(user.getUserIdx());
                status.setUsername(user.getUsername());
                status.setActivityStatus(user.getActivityStatus().getValue());
                memberStatusList.add(status);
            }
        }

        return memberStatusList;
    }

    public List<StudyGroup> getAllStudiesWithDistance(double userLatitude, double userLongitude) {
        List<StudyGroup> studyGroups = studyMapper.getAllStudies(userLatitude, userLongitude);
        for (StudyGroup study : studyGroups) {
            if (Double.isNaN(study.getDistance())) { // 거리가 NaN인 경우 기본값으로 설정
                study.setDistance(0.0);
            }
        }
        return studyGroups;
    }
}
