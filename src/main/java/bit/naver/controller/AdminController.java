package bit.naver.controller;

import bit.naver.entity.StudyReferencesEntity;
import bit.naver.entity.Users;
import bit.naver.mapper.StudiesMapMapper;
import bit.naver.mapper.StudyGroupMapper;
import bit.naver.mapper.StudyReferencesMapper;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import bit.naver.security.UsersUserDetailsService;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UsersMapper usersMapper;
    private final StudyGroupMapper studiesMapper;
    private final StudyReferencesMapper studyReferencesMapper;
    private final UsersUserDetailsService usersUserDetailsService;

    @Autowired
    public AdminController(UsersMapper usersMapper, StudyGroupMapper studiesMapper, StudyReferencesMapper studyReferencesMapper, UsersUserDetailsService usersUserDetailsService) {
        this.usersMapper = usersMapper;
        this.studiesMapper = studiesMapper;
        this.studyReferencesMapper = studyReferencesMapper;
        this.usersUserDetailsService = usersUserDetailsService;
    }

    @GetMapping("/websiteInfo")
    public String getWebsiteInfo(Model model, Principal principal) {
        String username = principal.getName();

        try {
            Users user = usersMapper.findByUsername(username);
            boolean isAdmin = usersMapper.isAdmin(username);

            model.addAttribute("isAdmin", isAdmin);
            model.addAttribute("user", user); // 사용자 정보를 모델에 추가

            // 전체 회원 수, 총 스터디 수, 총 게시글 수 조회
            int totalUsers = usersMapper.countAllUsers();
            int totalStudies = studiesMapper.countAllStudies();
            int totalPosts = studyReferencesMapper.countAllPosts();

            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("totalStudies", totalStudies);
            model.addAttribute("totalPosts", totalPosts);

            return "admin/websiteInfo"; // 관리자 페이지로 이동하는 뷰 이름 반환
        } catch (Exception e) {
            // 사용자를 찾을 수 없는 경우 처리
            model.addAttribute("error", "사용자를 찾을 수 없습니다.");
            return "error"; // 에러 페이지로 이동하는 뷰 이름 반환
        }
    }

    @GetMapping("/userManagement")
    public String getUserManagement(@RequestParam(defaultValue = "1") int page, Model model) {
        try {
            int pageSize = 10;
            int offset = (page - 1) * pageSize;

            List<Users> users = usersMapper.findAllUsersWithAuthoritiesPaged(offset, pageSize);
            int totalUsers = usersMapper.countAllUsersWithAuthorities();
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            users.forEach(user -> {
                if (user.getCreatedAt() != null) {
                    user.setFormattedCreatedAt(user.getCreatedAt().format(formatter));
                }
            });

            // 페이지 네비게이션 처리
            int startPage = Math.max(1, page - 5);
            int endPage = Math.min(startPage + 9, totalPages);

            model.addAttribute("users", users);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);

            return "admin/userManagement";
        } catch (Exception e) {
            model.addAttribute("error", "회원 정보를 가져오는 중 오류가 발생했습니다.");
            e.printStackTrace();
            return "error";
        }
    }

    // 게시판 관리 페이지
    @GetMapping("/boardManagement")
    public String getBoardManagement(@RequestParam(defaultValue = "1") int page, Model model) {
        try {
            int pageSize = 10; // 페이지당 게시글 수
            int offset = (page - 1) * pageSize;

            List<StudyReferencesEntity> reportedReferences = studyReferencesMapper.getReportedStudyReferences(offset, pageSize);
            int totalReportedReferences = studyReferencesMapper.countReportedStudyReferences();
            int totalPages = (int) Math.ceil((double) totalReportedReferences / pageSize);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            reportedReferences.forEach(reference -> {
                if (reference.getCreatedAt() != null) {
                    reference.setFormattedCreatedAt(reference.getCreatedAt().format(formatter));
                }
            });

            // 페이지 네비게이션 처리
            int startPage = Math.max(1, page - 5);
            int endPage = Math.min(startPage + 9, totalPages);

            model.addAttribute("reportedReferences", reportedReferences);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);

            return "admin/boardManagement";
        } catch (Exception e) {
            model.addAttribute("error", "게시글 정보를 가져오는 중 오류가 발생했습니다.");
            e.printStackTrace();
            return "error";
        }
    }
}