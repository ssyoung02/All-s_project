package bit.naver.controller;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.entity.Users;
import bit.naver.mapper.StudyGroupMapper;
import bit.naver.mapper.StudyReferencesMapper;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import bit.naver.security.UsersUserDetailsService;

import java.security.Principal;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    @GetMapping("/studyManagement")
    public String getStudyManagement(@RequestParam(defaultValue = "1") int page, Model model) {
        try {
            int pageSize = 10; // 페이지당 스터디 수
            int offset = (page - 1) * pageSize;

            // 신고된 스터디 목록 조회
            List<StudyGroup> reportedStudies = studiesMapper.getReportedStudies(offset, pageSize);
            int totalReportedStudies = studiesMapper.countReportedStudies();
            int totalPages = (int) Math.ceil((double) totalReportedStudies / pageSize);

            // 페이지 네비게이션 처리
            int startPage = Math.max(1, page - 5);
            int endPage = Math.min(startPage + 9, totalPages);

            model.addAttribute("reportedStudies", reportedStudies);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("startPage", startPage);
            model.addAttribute("endPage", endPage);

            return "admin/studyManagement";
        } catch (Exception e) {
            model.addAttribute("error", "스터디 정보를 가져오는 중 오류가 발생했습니다.");
            e.printStackTrace();
            return "error";
        }
    }

    // 스터디 삭제
    @DeleteMapping("/deleteStudy")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteStudy(@RequestBody Map<String, Long> requestData) {
        try {
            Long studyIdx = requestData.get("studyIdx"); // JSON 데이터에서 studyIdx 추출
            // studyIdx가 null인 경우 예외 처리
            if (studyIdx == null) {
                throw new IllegalArgumentException("studyIdx cannot be null");
            }
            studiesMapper.deleteStudy(studyIdx);

            Map<String, Boolean> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Boolean> response = new HashMap<>();
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
        }
    }
    // 선택된 스터디 삭제
    @DeleteMapping("/deleteStudies")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteStudies(@RequestBody Map<String, List<Long>> requestData) {
        try {
            List<Long> studyIds = requestData.get("studyIds");

            // studyIds를 이용하여 선택된 스터디 삭제 로직 구현
            for (Long studyIdx : studyIds) {
                studiesMapper.deleteStudy(studyIdx);
            }

            Map<String, Boolean> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Boolean> response = new HashMap<>();
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
        }
    }

    // 개별 게시글 삭제
    @DeleteMapping("/deleteReference")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteReference(@RequestBody Map<String, Long> requestData) {
        try {
            Long referenceIdx = requestData.get("referenceIdx");
            if (referenceIdx == null) {
                throw new IllegalArgumentException("referenceIdx cannot be null");
            }
            studyReferencesMapper.deleteStudyReference(referenceIdx);

            Map<String, Boolean> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Boolean> response = new HashMap<>();
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
        }
    }


    @DeleteMapping("/deleteReferences")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteReferences(@RequestBody Map<String, List<Long>> requestData) {
        try {
            List<Long> referenceIds = requestData.get("referenceIds");

            // studyIds를 이용하여 선택된 스터디 삭제 로직 구현
            for (Long  referenceIdx : referenceIds) {
                studyReferencesMapper.deleteStudyReference(referenceIdx);
            }

            Map<String, Boolean> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Boolean> response = new HashMap<>();
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
        }
    }

    @DeleteMapping("/deleteUsers")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteUsers(@RequestBody Map<String, List<Long>> requestData) {
        try {
            List<Long> userIds = requestData.get("userIds");
            if (userIds == null || userIds.isEmpty()) {
                throw new IllegalArgumentException("userIds cannot be null or empty");
            }

            // 선택된 회원들을 반복하여 삭제
            for (Long userIdx : userIds) {
                String username=usersMapper.findUsernameByUserIdx(userIdx);

                usersMapper.deleteUserAuthorities(username);
                usersMapper.deleteUserCalendars(userIdx);
                usersMapper.deleteUserOAuth2Logins(userIdx);
                usersMapper.deleteUserPersonalStatements(userIdx);
                usersMapper.deleteUserResumes(userIdx);
                usersMapper.deleteUserStudyMembers(userIdx);
                //usersMapper.deleteUserChats(userIdx);
                usersMapper.deleteUserLikeStudies(userIdx);
                usersMapper.deleteUserNotifications(userIdx);
                usersMapper.deleteUserStudyRecords(userIdx);
                usersMapper.deleteUserStudyReferences(userIdx);
                usersMapper.deleteUserComments(userIdx);
                usersMapper.deleteUserLikeReferences(userIdx);
                usersMapper.deleteUserTodos(userIdx);
                usersMapper.deleteStudies(userIdx);
                usersMapper.deleteUser(userIdx);
            }

            Map<String, Boolean> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Boolean> response = new HashMap<>();
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
        }
    }

    // 개별 회원 강제 탈퇴
    @DeleteMapping("/deleteUser")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> deleteUser(@RequestBody Map<String, Long> requestData) {
        try {
            Long userIdx = requestData.get("userIdx");
            if (userIdx == null) {
                throw new IllegalArgumentException("userIdx cannot be null");
            }
            String username=usersMapper.findUsernameByUserIdx(userIdx);

            usersMapper.deleteUserAuthorities(username);
            usersMapper.deleteUserCalendars(userIdx);
            usersMapper.deleteUserOAuth2Logins(userIdx);
            usersMapper.deleteUserPersonalStatements(userIdx);
            usersMapper.deleteUserResumes(userIdx);
            usersMapper.deleteUserStudyMembers(userIdx);
            //usersMapper.deleteUserChats(userIdx);
            usersMapper.deleteUserLikeStudies(userIdx);
            usersMapper.deleteUserNotifications(userIdx);
            usersMapper.deleteUserStudyRecords(userIdx);
            usersMapper.deleteUserStudyReferences(userIdx);
            usersMapper.deleteUserComments(userIdx);
            usersMapper.deleteUserLikeReferences(userIdx);
            usersMapper.deleteUserTodos(userIdx);
            usersMapper.deleteStudies(userIdx);
            usersMapper.deleteUser(userIdx);

            Map<String, Boolean> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Boolean> response = new HashMap<>();
            response.put("success", false);
            return ResponseEntity.internalServerError().body(response);
        }
    }
}