package bit.naver.controller;

import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import lombok.RequiredArgsConstructor;
import org.jboss.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class StudyController {
    private static final Logger log = Logger.getLogger(StudyController.class); // Logger 객체 선언 및 초기화
    @Autowired
    private UsersMapper usersMapper;

    @Value("${kakao.map.api.key}") // application.properties에서 API 키 값 가져오기
    private String kakaoMapApiKey;

    private final UsersUserDetailsService usersUserDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    //어드민 - 웹사이트 정보
    @RequestMapping("/admin/websiteInfo")
    public String WebsiteInfo() {
        return "admin/websiteInfo";
    }

    //어드민 - 회원 관리
    @RequestMapping("/admin/userManagement")
    public String UserManagement() {
        return "admin/userManagement";
    }

    //어드민 - 게시판 관리
    @RequestMapping("/admin/boardManagement")
    public String BoardManagement() {
        return "admin/boardManagement";
    }

    //어드민 - 스터디 관리
    @RequestMapping("/admin/studyManagement")
    public String StudyManagement() {
        return "admin/studyManagement";
    }

/*
    //내 공부노트
    @RequestMapping("/studyNote/noteList")
    public String NoteList() {
        return "studyNote/noteList";
    }

    //공부노트 - 글쓰기
    @RequestMapping("/studyNote/noteWrite")
    public String NoteWrite() {
        return "studyNote/noteWrite";
    }

    //공부노트 - 상세
    @RequestMapping("/studyNote/noteRead")
    public String NoteRead() {
        return "studyNote/noteRead";
    }

    //공부노트 - 수정
    @RequestMapping("/studyNote/noteModify")
    public String NoteModify() {
        return "studyNote/noteModify";
    }
*/

//    //캘린더
//    @RequestMapping("/calender/calender")
//    public String Calender() {
//        return "calendarMain";
//    }


//    //내 스터디
//    @RequestMapping("/studyGroup/studyGroupList")
//    public String StudyGroupList() {
//        return "studyGroup/studyGroupList";
//    }
//
//    //내 스터디 - 글쓰기
//    @RequestMapping("/studyGroup/studyGroupCreate")
//    public String StudyGroupCreate() {
//        return "studyGroup/studyGroupCreate";
//    }
//
//    //내 스터디 - 그룹 상세
//    @RequestMapping("/studyGroup/studyGroupMain")
//    public String StudyGroupMain() {
//        return "studyGroup/studyGroupMain";
//    }

    //내 스터디 - 그룹 관리 - 스터디 정보
    @RequestMapping("/studyGroup/studyGroupManagerInfo")
    public String StudyGroupManagerInfo(Model model) {
        model.addAttribute("kakaoMapApiKey", kakaoMapApiKey); // API 키를 모델에 추가
        return "studyGroup/studyGroupManagerInfo";
    }

    //내 스터디 - 그룹 관리 - 멤버 관리
    @RequestMapping("/studyGroup/studyGroupManagerMember")
    public String StudyGroupManagerMember() {
        return "studyGroup/studyGroupManagerMember";
    }

    //내 스터디 - 그룹 관리 - 스케쥴 관리
    @RequestMapping("/studyGroup/studyGroupManagerSchedule")
    public String StudyGroupManagerSchedule() {
        return "studyGroup/studyGroupManagerSchedule";
    }

    //내 스터디 - 그룹 관리 - 스터디 관리
    @RequestMapping("/studyGroup/studyGroupManagerManagement")
    public String StudyGroupManagerManagement() {
        return "studyGroup/studyGroupManagerManagement";
    }


//    //스터디 모집
//    @RequestMapping("/studyRecruit/recruitList")
//    public String RecruitList() {
//        return "studyRecruit/recruitList";
//    }

//    //스터디 모집 - 상세
//    @RequestMapping("/studyRecruit/recruitReadForm")
//    public String RecruitReadForm() {
//        return "studyRecruit/recruitReadForm";
//    }
//    //캘린더
//    @RequestMapping("/calender/calender")
//    public String Calender() {
//        return "calender/calender";
//    }
//
//
//    //내 스터디
//    @RequestMapping("/studyGroup/studyGroupList")
//    public String StudyGroupList() {
//        return "studyGroup/studyGroupList";
//    }
//
//    //내 스터디 - 글쓰기
//    @RequestMapping("/studyGroup/studyGroupCreate")
//    public String StudyGroupCreate() {
//        return "studyGroup/studyGroupCreate";
//    }
//
//    //내 스터디 - 그룹 상세
//    @RequestMapping("/studyGroup/studyGroupMain")
//    public String StudyGroupMain() {
//        return "studyGroup/studyGroupMain";
//    }
//
//    //내 스터디 - 그룹 관리 - 스터디 정보
//    @RequestMapping("/studyGroup/studyGroupManagerInfo")
//    public String StudyGroupManagerInfo() {
//        return "studyGroup/studyGroupManagerInfo";
//    }
//
//    //내 스터디 - 그룹 관리 - 멤버 관리
//    @RequestMapping("/studyGroup/studyGroupManagerMember")
//    public String StudyGroupManagerMember() {
//        return "studyGroup/studyGroupManagerMember";
//    }
//
//    //내 스터디 - 그룹 관리 - 스케쥴 관리
//    @RequestMapping("/studyGroup/studyGroupManagerSchedule")
//    public String StudyGroupManagerSchedule() {
//        return "studyGroup/studyGroupManagerSchedule";
//    }
//
//    //내 스터디 - 그룹 관리 - 스터디 관리
//    @RequestMapping("/studyGroup/studyGroupManagerManagement")
//    public String StudyGroupManagerManagement() {
//        return "studyGroup/studyGroupManagerManagement";
//    }
//
//
//    //스터디 모집
//    @RequestMapping("/studyRecruit/recruitList")
//    public String RecruitList() {
//        return "studyRecruit/recruitList";
//    }
//
//    //스터디 모집 - 상세
//    @RequestMapping("/studyRecruit/recruitReadForm")
//    public String RecruitReadForm() {
//        return "studyRecruit/recruitReadForm";
//    }
//    //캘린더
//    @RequestMapping("/calender/calender")
//    public String Calender() {
//        return "calender/calender";
//    }
//
//
//    //내 스터디
//    @RequestMapping("/studyGroup/studyGroupList")
//    public String StudyGroupList() {
//        return "studyGroup/studyGroupList";
//    }
//
//    //내 스터디 - 글쓰기
//    @RequestMapping("/studyGroup/studyGroupCreate")
//    public String StudyGroupCreate() {
//        return "studyGroup/studyGroupCreate";
//    }
//
//    //내 스터디 - 그룹 상세
//    @RequestMapping("/studyGroup/studyGroupMain")
//    public String StudyGroupMain() {
//        return "studyGroup/studyGroupMain";
//    }
//
//    //내 스터디 - 그룹 관리 - 스터디 정보
//    @RequestMapping("/studyGroup/studyGroupManagerInfo")
//    public String StudyGroupManagerInfo() {
//        return "studyGroup/studyGroupManagerInfo";
//    }
//
//    //내 스터디 - 그룹 관리 - 멤버 관리
//    @RequestMapping("/studyGroup/studyGroupManagerMember")
//    public String StudyGroupManagerMember() {
//        return "studyGroup/studyGroupManagerMember";
//    }
//
//    //내 스터디 - 그룹 관리 - 스케쥴 관리
//    @RequestMapping("/studyGroup/studyGroupManagerSchedule")
//    public String StudyGroupManagerSchedule() {
//        return "studyGroup/studyGroupManagerSchedule";
//    }
//
//    //내 스터디 - 그룹 관리 - 스터디 관리
//    @RequestMapping("/studyGroup/studyGroupManagerManagement")
//    public String StudyGroupManagerManagement() {
//        return "studyGroup/studyGroupManagerManagement";
//    }
//
//
//    //스터디 모집
//    @RequestMapping("/studyRecruit/recruitList")
//    public String RecruitList() {
//        return "studyRecruit/recruitList";
//    }
//
//    //스터디 모집 - 상세
//    @RequestMapping("/studyRecruit/recruitReadForm")
//    public String RecruitReadForm() {
//        return "studyRecruit/recruitReadForm";
//    }


    //공부 자료
//    @RequestMapping("/studyReferences/referencesList")
//    public String ReferencesList() { return "studyReferences/referencesList"; }
//    //관련 사이트
//    @RequestMapping("/studyReferences/referencesSite")
//    public String ReferencesSite() { return "studyReferences/referencesSite"; }


//    //나의 정보
//    @RequestMapping("/Users/userInfo")
//    public String UserInfo() { return "Users/userInfo"; }
//    //정보 수정
//    @RequestMapping("/Users/userEdit")
//    public String UserEdit() { return "Users/userEdit"; }
//    //회원 탈퇴
//    @RequestMapping("/Users/userDelete")
//    public String UserDelete() { return "Users/userDelete"; }
}