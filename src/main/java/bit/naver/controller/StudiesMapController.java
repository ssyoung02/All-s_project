package bit.naver.controller;


import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyList;
import bit.naver.entity.StudyMembers;
import bit.naver.entity.Users;
import bit.naver.mapper.StudyGroupMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@RestController // @Controller -> @RestController 로 변경
@RequestMapping("/studies")
@RequiredArgsConstructor
public class StudiesMapController {


    private final StudyGroupMapper studiesMapMapper;

    @GetMapping("/getMyStudies")
    public List<StudyGroup> getMyStudies(HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx();

        // 사용자 위치 정보가 없는 경우 기본 값 설정 (예: 서울 시청)
        Double userLatitude = Optional.ofNullable(user)
                .map(Users::getLatitude)
                .orElse(37.566535); // 서울시청 위도
        Double userLongitude = Optional.ofNullable(user)
                .map(Users::getLongitude)
                .orElse(127.027501); // 서울시청 경도

        return studiesMapMapper.getJoinedStudies(userLatitude, userLongitude, userIdx); // getJoinedStudies 메서드 호출
    }
    @GetMapping("/listOnMap")
    public List<StudyGroup> getStudyList() {
        return studiesMapMapper.findAllStudies();
    }

    // 스터디 목록 조회 (로그인하지 않은 사용자용)
    @GetMapping("/listOnAnonymousMap") // GET 방식으로 변경
    public List<StudyGroup> getStudyListOnAnonymousMap() {
        return studiesMapMapper.findAllStudies();
    }

    // 스터디 상세 페이지 조회
    @GetMapping("/detail/{studyIdx}")
    public String getStudyDetail(@PathVariable Long studyIdx, Model model) {
        StudyGroup studyGroup = studiesMapMapper.getStudyById(studyIdx);
        List<StudyMembers> studyMembers = studiesMapMapper.getStudyMembers(studyIdx);
        model.addAttribute("studyGroup", studyGroup);
        model.addAttribute("studyMembers", studyMembers);
        return "studies/studyDetail"; // 스터디 상세 페이지 뷰 이름
    }

    @GetMapping("/nearestStudies")
    public List<StudyGroup> getNearestStudies(HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        // 사용자 위치 정보가 없는 경우 기본 값 설정 (예: 서울 시청)
        double userLatitude = Optional.ofNullable(user)
                .map(Users::getLatitude)
                .orElse(37.566535); // 서울시청 위도
        double userLongitude = Optional.ofNullable(user)
                .map(Users::getLongitude)
                .orElse(127.027501); // 서울시청 경도

        return studiesMapMapper.findNearestStudies(userLatitude, userLongitude, 3); // 3개 조회
    }
}