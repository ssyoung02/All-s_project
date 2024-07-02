package bit.naver.controller;

import bit.naver.entity.*;
import bit.naver.mapper.NotificationMapper;
import bit.naver.mapper.StudyGroupMapper;
import bit.naver.mapper.StudyRecruitMapper;
import bit.naver.mapper.UsersMapper;
import bit.naver.service.StudyService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.*;
import java.io.File;

@Controller
@RequiredArgsConstructor
@RequestMapping("/studyGroup")
public class StudyGroupController {

    @Autowired
    private StudyGroupMapper studyGroupMapper;

    @Autowired
    private StudyRecruitMapper studyRecruitMapper;

    @Autowired
    private NotificationMapper notificationMapper;

    @Autowired
    private UsersMapper usersMapper;

    @Autowired
    private StudyService studyService;

    private static final Logger logger = LoggerFactory.getLogger(StudyGroupController.class);

    // 스터디 관리 페이지로 이동
    @GetMapping("/studyGroupManagerInfo")
    public String getStudyGroupManagerInfo(Model model, @RequestParam("studyIdx") Long studyIdx) {
        StudyGroup studyGroup = studyGroupMapper.getStudyById(studyIdx);

        // category, gender, age 값을 모델에 추가
        model.addAttribute("studyGroup", studyGroup);
        model.addAttribute("category", studyGroup.getCategory());
        model.addAttribute("gender", studyGroup.getGender());
        model.addAttribute("age", studyGroup.getAge());

        logger.info("Category: " + studyGroup.getCategory());
        logger.info("Gender: " + studyGroup.getGender());
        logger.info("Age: " + studyGroup.getAge());

        return "studyGroup/studyGroupManagerInfo";
    }

    // 스터디 리스트 조회 페이지로 이동
    @RequestMapping("/studyGroupList")
    public String getMyStudies(Model model, HttpSession session,
                               @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                               @RequestParam(value = "searchOption", required = false) String searchOption) {
        // 세션에서 현재 사용자 정보 가져오기 (예: 로그인한 사용자 정보)
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx();

        // DB에서 해당 사용자가 참여 중인 모든 스터디 목록 조회 (승인된 스터디와 승인 대기 중인 스터디 포함)
        List<StudyList> myStudies = studyGroupMapper.getAllMyStudies(userIdx, searchKeyword, searchOption);
        // List<StudyList> myStudies = studyGroupMapper.getAllMyStudies(userIdx);

        // 모델에 검색어와 검색 옵션을 추가
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("searchOption", searchOption);
        model.addAttribute("userIdx", userIdx);
        // 모델에 사용자 스터디 목록 추가
        model.addAttribute("myStudies", myStudies);

        return "studyGroup/studyGroupList";
    }

    // 스터디 생성 폼을 위한 GET 요청 처리
    @GetMapping("/studyGroupCreate")
    public String getStudyGroupCreate(Model model) {
        model.addAttribute("studyGroup", new StudyGroup());
        return "studyGroup/studyGroupCreate";
    }

    @RequestMapping("/studyGroupMain")
    public String getStudyGroupMain(@RequestParam("studyIdx") Long studyIdx, Model model, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx();

        StudyGroup study = studyGroupMapper.getStudyById(studyIdx);
        List<StudyMembers> members = studyGroupMapper.getStudyMembers(studyIdx);
        int currentParticipants = members.size();

        study.setCurrentParticipants(currentParticipants);

        // studyGroup의 role 설정
        for (StudyMembers member : members) {
            if (member.getUserIdx().equals(userIdx)) {
                study.setRole(member.getRole());
                break;
            }
        }
        session.setAttribute("studyIdx", studyIdx); // 세션에 studyIdx 저장

        model.addAttribute("study", study);
        model.addAttribute("members", members);
        return "studyGroup/studyGroupMain"; // 스터디 상세 정보를 보여줄 JSP 페이지
    }

    // 스터디 생성을 위한 POST 요청 처리
    @PostMapping("/studyGroupCreate")
    public String insertCreateStudyGroup(@ModelAttribute("studyGroup") StudyGroup study,
                                         @RequestParam("profileImage") MultipartFile profileImage,
                                         BindingResult result, HttpSession session,
                                         HttpServletRequest request) throws Exception {
        if (result.hasErrors()) {
            return "studyGroup/studyGroupCreate";
        }
// 현재 위치 정보 가져오기 (JavaScript에서 받아온 값 사용)
        double latitude = Double.parseDouble(request.getParameter("latitude"));
        double longitude = Double.parseDouble(request.getParameter("longitude"));

        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx();

        // 여기서 studyLeaderIdx를 user의 username에서 가져오는 로직
        // 예시로 구현하면 아래와 같이 userRepository.findByUsername(user.getUsername()).getUserIdx()를 호출
        study.setStudyLeaderIdx(userIdx);
        study.setStartDate(new Date());
        study.setEndDate(new Date());
        study.setStatus(StudyStatus.RECRUITING);
        study.setCreatedAt(new Date());
        study.setLatitude(latitude);
        study.setLongitude(longitude);

        // 프로필 이미지 처리
        if (profileImage != null && !profileImage.isEmpty()) {
            String fileName = profileImage.getOriginalFilename();
            String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toUpperCase();

            // 이미지 파일 확장자 검사
            if (ext.equals("PNG") || ext.equals("GIF") || ext.equals("JPG") || ext.equals("JPEG")) {
                String savePath = request.getServletContext().getRealPath("/resources/studyGroupImages");

                // 디렉토리 존재 여부 확인 및 생성
                File directory = new File(savePath);
                if (!directory.exists()) {
                    directory.mkdirs();
                }

                File uploadFile = new File(savePath + "/" + fileName);
                profileImage.transferTo(uploadFile); // 파일 저장

                study.setImage("/resources/studyGroupImages/" + fileName); // 이미지 경로 설정
            } else {
                session.setAttribute("error", "이미지 파일만 업로드할 수 있습니다.");
                return "studyGroup/studyGroupCreate";
            }
        }

        studyGroupMapper.insertStudy(study);

        // StudyMembers 테이블에 스터디 리더로 데이터 삽입
        StudyMembers studyMember = new StudyMembers();
        studyMember.setStudyIdx(studyGroupMapper.findStudyIdx(userIdx));
        studyMember.setUserIdx(userIdx);
        studyMember.setRole("LEADER");
        studyMember.setStatus("ACCEPTED");
        studyMember.setCreatedAt(LocalDateTime.now());
        studyMember.setUpdatedAt(LocalDateTime.now());

        studyGroupMapper.insertStudyMember(studyMember);

        return "redirect:/studyGroup/studyGroupList";
    }

    // 채팅
    @RequestMapping("/chat")
    public String chat(HttpSession session, Principal principal) {

        Users user = (Users) session.getAttribute("userVo");
        return "studyGroup/chat";
    }

    // 스터디 멤버 관리 페이지로 이동
    @GetMapping("/studyGroupManagerMember")
    public String getStudyGroupManagerMember(Model model, @RequestParam("studyIdx") Long studyIdx) {
        logger.info("Accessing studyGroupManagerMember for studyIdx: {}", studyIdx);

        // 스터디 ID를 통해 스터디 정보를 가져옴
        StudyGroup studyGroup = studyGroupMapper.getStudyById(studyIdx);
        List<StudyMembers> members = studyGroupMapper.getStudyMembers(studyIdx);

        logger.info("StudyGroup: {}", studyGroup);

        // 디버깅을 위한 로그 추가
        for (StudyMembers member : members) {
            System.out.println("Member: " + member.getUserName() + ", Status: " + member.getStatus() + ", JoinReason: " + member.getJoinReason());
        }

        model.addAttribute("studyGroup", studyGroup);
        model.addAttribute("members", members);
        return "studyGroup/studyGroupManagerMember";
    }

    @PostMapping("/removeMember")
    @ResponseBody
    public Map<String, Object> removeMember(@RequestParam("studyIdx") Long studyIdx, @RequestParam("userIdx") Long userIdx) {
        Map<String, Object> response = new HashMap<>();
        try {
            studyGroupMapper.removeMember(studyIdx, userIdx);
            studyGroupMapper.decrementCurrentParticipants(studyIdx);  // 멤버 탈퇴 시 현재 참가자 수 감소
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @PostMapping("/approveMember")
    @ResponseBody
    public Map<String, Object> approveMember(@RequestParam("studyIdx") Long studyIdx, @RequestParam("userIdx") Long userIdx) {
        Map<String, Object> response = new HashMap<>();
        try {
            studyGroupMapper.approveMember(studyIdx, userIdx);
            studyGroupMapper.incrementCurrentParticipants(studyIdx);  // 멤버 승인 시 현재 참가자 수 증가
            response.put("success", true);
            response.put("message", "가입 승인이 완료되었습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "가입 승인에 실패했습니다: " + e.getMessage());
        }
        return response;
    }

    @PostMapping("/rejectMember")
    @ResponseBody
    public Map<String, Object> rejectMember(@RequestParam("studyIdx") Long studyIdx, @RequestParam("userIdx") Long userIdx) {
        Map<String, Object> response = new HashMap<>();
        try {
            studyGroupMapper.updateMemberStatus(studyIdx, userIdx, "REJECTED");
            response.put("success", true);
            response.put("message", "가입 승인을 거절하였습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "가입 승인 거절에 실패했습니다: " + e.getMessage());
        }
        return response;
    }

    // 스터디 관리 - 일정
    @GetMapping("/studyGroupManagerSchedule")
    public String getStudyGroupManagerSchedule(@RequestParam("studyIdx") Long studyIdx, Model model) {
        StudyGroup studyGroup = studyGroupMapper.getStudyById(studyIdx);
        model.addAttribute("studyGroup", studyGroup);
        return "studyGroup/studyGroupManagerSchedule";
    }

    // 스터디 관리 페이지로 이동
    @GetMapping("/studyGroupManagerManagement")
    public String getStudyGroupManagerManagement(Model model, @RequestParam("studyIdx") Long studyIdx) {
        // 스터디 ID를 통해 스터디 정보를 가져옴
        StudyGroup studyGroup = studyGroupMapper.getStudyById(studyIdx);
        model.addAttribute("studyGroup", studyGroup);
        return "studyGroup/studyGroupManagerManagement";
    }

    @PostMapping("/deleteStudyGroup")
    @ResponseBody
    public Map<String, Object> deleteStudyGroup(@RequestParam("studyIdx") Long studyIdx) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 종속 레코드 삭제
            studyGroupMapper.deleteTeamCalendarsByStudyIdx(studyIdx);
            studyGroupMapper.deleteStudyMembersByStudyIdx(studyIdx);

            // 부모 레코드 삭제
            studyGroupMapper.deleteStudy(studyIdx);
            response.put("success", true);
            response.put("message", "스터디가 성공적으로 삭제되었습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "스터디 삭제에 실패했습니다: " + e.getMessage());
        }
        return response;
    }

    @RequestMapping("/recruitReadForm")
    public String getRecruitReadForm(@RequestParam("studyIdx") Long studyIdx, Model model, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx();

        StudyGroup study = studyGroupMapper.getStudyById(studyIdx);
        boolean isMember = studyGroupMapper.isMember(studyIdx, userIdx);

        model.addAttribute("study", study);
        model.addAttribute("isMember", isMember);

        return "studyRecruit/recruitReadForm";
    }

    // 스터디 업데이트
    @PostMapping("/updateStudyGroup")
    @ResponseBody
    public Map<String, Object> updateStudyGroup(@RequestParam("studyIdx") Long studyIdx,
                                                @RequestParam("descriptionTitle") String descriptionTitle,
                                                @RequestParam("description") String description,
                                                @RequestParam("category") String category,
                                                @RequestParam("age") String age,
                                                @RequestParam("gender") String gender,
                                                @RequestParam("studyOnline") boolean studyOnline,
                                                @RequestParam(value = "image", required = false) MultipartFile image,
                                                HttpSession session, HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        try {
            StudyGroup studyGroup = studyGroupMapper.getStudyById(studyIdx);
            studyGroup.setStudyIdx(studyIdx);
            studyGroup.setDescriptionTitle(descriptionTitle);
            studyGroup.setDescription(description);
            studyGroup.setCategory(category);
            studyGroup.setAge(age);
            studyGroup.setGender(gender);
            studyGroup.setStudyOnline(studyOnline);

            if (image != null && !image.isEmpty()) {
                String savePath = request.getServletContext().getRealPath("/resources/studyGroupImages");
                File directory = new File(savePath);
                if (!directory.exists()) {
                    directory.mkdirs();
                }
                String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
                File uploadFile = new File(savePath + "/" + fileName);
                image.transferTo(uploadFile); // 파일 저장
                studyGroup.setImage("/resources/studyGroupImages/" + fileName); // 이미지 경로 설정
            }

            studyGroupMapper.updateStudyGroup(studyGroup);
            response.put("success", true);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    private String saveImage(MultipartFile image, HttpSession session) {
        // 이미지 저장 로직 구현 (파일 시스템 또는 클라우드 스토리지 사용)
        // 예: 파일 시스템에 저장 후 URL 반환
        String imagePath = "/images/" + image.getOriginalFilename();
        // 실제 파일 저장 코드 필요
        return imagePath;
    }

    @PostMapping("/updateStudyGroupInfo")
    @ResponseBody
    public Map<String, Object> updateStudyGroupInfo(@RequestParam("studyIdx") Long studyIdx,
                                                    @RequestParam("studyTitle") String studyTitle,
                                                    @RequestParam("description") String description) {
        Map<String, Object> response = new HashMap<>();
        try {
            StudyGroup studyGroup = studyGroupMapper.getStudyById(studyIdx);
            studyGroup.setStudyTitle(studyTitle);
            studyGroup.setDescription(description);

            studyGroupMapper.updateStudyGroupInfo(studyGroup);
            response.put("success", true);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    // 알림 정보
    @ResponseBody
    @PostMapping("/getAlarmInfo")
    public List<NotificationEntity> getAlarmInfo(HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");

        List<NotificationEntity> data = notificationMapper.getAlarmInfo(user.getUserIdx());
        return data;
    }

    // 알림 삭제 처리
    @PostMapping("/deleteNotification/{notificationIdx}")
    @ResponseBody
    public String deleteNotification(@PathVariable("notificationIdx") Long notificationIdx) {
        try {
            notificationMapper.deleteNotification(notificationIdx);
            return "알림이 성공적으로 삭제되었습니다.";
        } catch (Exception e) {
            e.printStackTrace();
            return "알림 삭제 중 오류가 발생했습니다.";
        }
    }


    @GetMapping("/studyGroupMain/members/{studyIdx}")
    @ResponseBody
    public ResponseEntity<List<StudyMemberStatus>> getStudyGroupMemberStatus(@PathVariable Long studyIdx, HttpSession session) {
        Users user = (Users) session.getAttribute("userVo");
        Long userIdx = user.getUserIdx();

        // 현재 사용자가 스터디 멤버인지 확인
        StudyMembers member = studyGroupMapper.getStudyMember(studyIdx, userIdx);
        if (member == null || !member.getStatus().equals("ACCEPTED")) { // ACCEPTED 상태인지 확인
            return ResponseEntity.ok(Collections.emptyList()); // 멤버가 아니면 빈 리스트 반환
        }

        // 스터디 멤버들의 activity_status 조회
        List<StudyMembers> members = studyGroupMapper.getStudyMembers(studyIdx);
        List<StudyMemberStatus> memberStatusList = new ArrayList<>();
        for (StudyMembers studyMember : members) {
            Users memberUser = usersMapper.findById(studyMember.getUserIdx());
            if (memberUser != null) {
                StudyMemberStatus status = new StudyMemberStatus();
                status.setUserIdx(memberUser.getUserIdx());
                status.setUsername(memberUser.getUsername());
                status.setName(memberUser.getName());
                status.setActivityStatus(memberUser.getActivityStatus().getValue());
                status.setProfile_image(memberUser.getProfileImage());
                memberStatusList.add(status);
            }
        }

        return ResponseEntity.ok(memberStatusList);
    }
}