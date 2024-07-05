package bit.naver.controller;

import bit.naver.entity.StudyGroup;
import bit.naver.entity.Users;
import bit.naver.mapper.StudyGroupMapper;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.CustomAccountDeletionService;
import bit.naver.service.GoogleLoginService;
import bit.naver.service.WeatherService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.security.Principal;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/Users")
@RequiredArgsConstructor
public class UsersController {
    //private static final Logger log = Logger.getLogger(UsersController.class); // Logger 객체 선언 및 초기화
    @Autowired
    private WeatherService weatherService;

    @Autowired
    private GoogleLoginService loginService;
    @Autowired
    private UsersMapper usersMapper;
    @Autowired
    private Environment env;
    private final CustomAccountDeletionService accountDeletionService;
    private final UsersUserDetailsService usersUserDetailsService;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private CustomAccountDeletionService customAccountDeletionService;

    @Autowired
    private StudyGroupMapper studyGroupMapper;

    @Value("${google.maps.api.key}")
    private String googleMapsApiKey;

    @PostMapping("/updateLocation")
    @ResponseBody
    public String updateLocation(@RequestParam double latitude,
                                 @RequestParam double longitude,
                                 @AuthenticationPrincipal Object principal, // @AuthenticationPrincipal 어노테이션 사용
                                 HttpSession session) {
        String username;
        if (principal instanceof UserDetails) {
            username = ((UserDetails) principal).getUsername();
        } else if (principal instanceof OAuth2User) {
            Map<String, Object> attributes = ((OAuth2User) principal).getAttributes();
            Map<String, Object> response = (Map<String, Object>) attributes.get("response");
            username =  (String) response.get("email");
        } else {
            // 사용자가 로그인하지 않은 경우 에러 처리
            return "fail";
        }

        Users user = usersMapper.findByUsername(username);

        if (user != null) {
            user.setLatitude(latitude);
            user.setLongitude(longitude);
            usersMapper.updateUser(user);
            return "success";
        } else {
            return "fail"; // 사용자 정보를 찾을 수 없는 경우
        }
    }

    @ModelAttribute("genderOptions") // 성별 옵션을 모델에 추가
    public Users.Gender[] getGenderOptions() {
        return Users.Gender.values();
    }

    // 회원가입 페이지
    @RequestMapping("/Join")
    public String join(Model model) {
        model.addAttribute("user", new Users()); // Users 객체를 모델에 추가
        return "Users/join";
    }

    // 아이디 중복 확인
    @RequestMapping("/checkDuplicate")
    @ResponseBody
    public int checkDuplicate(@RequestParam("username") String username) {
        Users user = usersMapper.findByUsername(username);
        return (user == null || username.isEmpty()) ? 0 : 1;
    }


    @PostMapping("/checkDuplicateEmail") // 이메일 중복 확인 메서드 추가
    @ResponseBody
    public int checkDuplicateEmail(@RequestParam("email") String email) {
        return usersMapper.findByEmail(email) ? 1 : 0;
    }


    @RequestMapping(value = "/UsersRegister", method = RequestMethod.POST)
    public String usersRegister(@RequestParam("username") String username,
                                @RequestParam("password") String password,
                                @RequestParam("name") String name,
                                @RequestParam("email") String email,
                                @RequestParam("birthdate") String birthdateStr,
                                @RequestParam("gender") String gender,
                                @RequestParam(value = "socialLogin", required = false, defaultValue = "false") Boolean socialLogin,
                                @RequestParam(value = "provider", required = false) String provider,
                                @RequestParam(value = "profileImage", required = false) String profileImage,
                                @RequestParam(value = "mobile") String mobile,
                                RedirectAttributes rttr, HttpSession session) {

        // 입력 값 유효성 검사 (직접 구현)
        if (username.isEmpty() || password.isEmpty() || name.isEmpty() || email.isEmpty() || birthdateStr.isEmpty() || gender.isEmpty() || mobile.isEmpty()) {
           session.setAttribute("error", "모든 필드를 입력해주세요.");
            return "redirect:/Users/Join?error=true";
        }

        // 이메일 중복 검사
        if (usersMapper.findByEmail(email)) { // UsersMapper에 findByEmail 메서드 추가 필요
            session.setAttribute("error", "이미 사용 중인 이메일입니다.");
            return "redirect:/Users/Join?error=true";
        }

        // 아이디 길이 검사
        if (username.length() < 4 ) {
            session.setAttribute("error", "아이디는 4~12자 사이여야 합니다.");
            return "redirect:/Users/Join?error=true";
        }

        // 비밀번호 길이 검사
        if (password.length() < 8 || password.length() > 16) {
            session.setAttribute("error", "비밀번호는 8~16자 사이여야 합니다.");
            return "redirect:/Users/Join?error=true";
        }


        try {
            // 생년월일 변환
            LocalDate birthdate;
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                birthdate = LocalDate.parse(birthdateStr, formatter);
                if(birthdate.isAfter(LocalDate.now())){
                    session.setAttribute("error", "생년월일은 오늘 이전의 날짜여야 합니다.");
                    return "redirect:/Users/Join?error?true";
                }
            } catch (DateTimeParseException e) {
                session.setAttribute("error", "올바른 생년월일 형식이 아닙니다.");
                return "redirect:/Users/Join?error=true";
            }

            // Users 객체 생성 및 데이터 설정
            Users user = new Users();
            user.setUsername(username);
            user.setPassword(passwordEncoder.encode(password));
            user.setEmail(email);
            user.setName(name);
            user.setBirthdate(birthdate);
            user.setGender(gender);
            user.setEnabled(true);
            user.setMobile(mobile);
            // 소셜 로그인 여부 및 제공자 설정
            user.setSocialLogin(socialLogin);
            user.setProvider(socialLogin ? provider : null);

            // 프로필 이미지 설정 (소셜 로그인인 경우에만)
            if (socialLogin && (provider.equals("naver") || provider.equals("kakao") || provider.equals("google"))) {
                if (provider.equals("google")) {
                    user.setProfileImage("https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png");
                } else {
                    user.setProfileImage(profileImage);
                }
            } else {
                user.setProfileImage("user.png");
            }

            ZoneId zoneId = ZoneId.of("Asia/Seoul"); // 서울 타임존 ID
            LocalDateTime currentDateTime = LocalDateTime.now();
            LocalDateTime zonedDateTime = ZonedDateTime.of(currentDateTime, zoneId).toLocalDateTime();
            Timestamp createdAt = Timestamp.valueOf(zonedDateTime);
            Timestamp updatedAt = Timestamp.valueOf(zonedDateTime);
            user.setCreatedAt(createdAt.toLocalDateTime()); // createdAt은 Timestamp 타입
            user.setUpdatedAt(updatedAt.toLocalDateTime());
            System.out.println("서울 타임존 현재 시간: " + currentDateTime);

            // 사용자 정보 저장
            usersMapper.insertUser(user);
            usersMapper.insertUserAuthority(username);
            session.setAttribute("error", "회원가입에 성공했습니다.");

            return "redirect:/main";
        } catch (Exception e) { // 예외 발생 시 처리
            log.error("회원가입 중 오류 발생:", e); // 오류 로깅

            session.setAttribute("error", "회원가입 중 오류가 발생했습니다.");
            return "redirect:/Users/Join"; // 회원가입 페이지로 리다이렉트
        }
    }

    //-----------------------------------------------------------------------------------------------------------------

    // 로그인 페이지
    @RequestMapping("/UsersLoginForm")
    public String usersLoginForm(Model model, HttpSession session) {
        // 랜덤 상태 파라미터 생성
        SecureRandom secureRandom = new SecureRandom();
        byte[] stateBytes = new byte[16];
        secureRandom.nextBytes(stateBytes);
        String loginState = Base64.getUrlEncoder().encodeToString(stateBytes);

        // 세션에 상태 파라미터 저장
        session.setAttribute("loginState", loginState);

        // 모델에 상태 파라미터 추가
        model.addAttribute("loginState", loginState);

        return "Users/UsersLoginForm";
    }

    // 로그인 처리
    @RequestMapping("/Login")
    public String usersLogin(Users user, @RequestParam("loginState") String loginState, Model model,RedirectAttributes rttr, HttpSession session, Principal principal) {

        System.out.println("로그인 버튼 누른 후 작업");

        String sessionLoginState = (String) session.getAttribute("loginState");
        if (sessionLoginState == null || !sessionLoginState.equals(loginState)) {
            log.warn("로그인 실패: 잘못된 요청입니다.");
            rttr.addFlashAttribute("error", "잘못된 요청입니다.");
            return "redirect:/Users/UsersLoginForm";
        }
        if (principal != null && principal instanceof UsernamePasswordAuthenticationToken) {
            // 사용자가 이미 인증된 경우 (구글 로그인 등)
            session.setAttribute("error", "로그인에 성공했습니다");
            String username = principal.getName();
            Users users = usersMapper.findByUsername(username);
            Long userIdx = Long.valueOf(users != null ? users.getUserIdx() : 59);
            List<StudyGroup> myStudies = studyGroupMapper.getJoinedStudies(user.getLatitude(), user.getLongitude(), userIdx);
            session.setAttribute("myStudies", myStudies);


            // 참여 중인 스터디가 있는 경우 첫 번째 스터디 정보를 세션에 추가
            if (!myStudies.isEmpty()) {
                StudyGroup currentStudy = myStudies.get(0);
                session.setAttribute("study", currentStudy);
            }
            return "/main";
        }
        // 입력 값 유효성 검사
        if (user.getUsername().isEmpty() || user.getPassword().isEmpty()) {
            System.out.println("로그인 입력 비었음");
            log.warn("로그인 실패: 아이디 또는 비밀번호가 비어있습니다."); // 로그 추가

            rttr.addFlashAttribute("error", "아이디와 비밀번호를 입력하세요");
            return "redirect:/Users/UsersLoginForm";
        }

        // 사용자 정보 조회 및 비밀번호 검증
        Users userVo = usersMapper.findByUsername(user.getUsername());
        if (userVo != null && passwordEncoder.matches(user.getPassword(), userVo.getPassword())) {
            // 로그인 성공 처리
            System.out.println("로그인 정보 확인 o");

            // activityStatus 업데이트
            userVo.setActivityStatus(Users.ActivityStatus.ACTIVE);
            usersMapper.updateUser(userVo); // 업데이트된 사용자 정보 저장

            // 인증 정보 생성
            Authentication authentication = new UsernamePasswordAuthenticationToken(userVo.getUsername(), userVo.getPassword());

            // SecurityContextHolder에 인증 정보 설정
            SecurityContextHolder.getContext().setAuthentication(authentication);

            // 세션에 사용자 정보 저장
            log.info("로그인 성공 (username: {})", userVo.getUsername()); // 로그 추가

            session.setAttribute("userVo", userVo);
            session.setAttribute("error", "로그인에 성공했습니다");
            System.out.println("로그인 정보 확인 o");

            Long userIdx = Long.valueOf(userVo != null ? userVo.getUserIdx() : 59);
            List<StudyGroup> myStudies = studyGroupMapper.getJoinedStudies(user.getLatitude(), user.getLongitude(), userIdx);
            session.setAttribute("myStudies", myStudies);


            // 참여 중인 스터디가 있는 경우 첫 번째 스터디 정보를 세션에 추가
            if (!myStudies.isEmpty()) {
                StudyGroup currentStudy = myStudies.get(0);
                session.setAttribute("study", currentStudy);
            }
            return "/main";
        } else {
            System.out.println("회원 정보 없음");
            log.warn("로그인 실패: 아이디 또는 비밀번호가 일치하지 않습니다."); // 로그 추가
            // 오류 메시지 설정 (기존 msg1, msg2 대신 error 사용)
            if (userVo == null) {
                rttr.addFlashAttribute("error", "존재하지 않는 아이디입니다.");
            } else {
                rttr.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
            }
            session.setAttribute("loginusername", user.getUsername()); // 아이디 값 유지
            return "redirect:/Users/UsersLoginForm";
        }
    }


    @RequestMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null) {

            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "redirect:/main"; // 로그아웃 후 메인 페이지로 이동
    }
    //------------------------------------------------------------------------------------------------------------------------

    //회원정보 (내정보) 조회 처리 --추후 캘린더 기능, 차트기능, 공부시간 기록에 대한 기능이 추가될 경우 추가 수정

    @RequestMapping("/userInfoProcess")
    public String userInfoProcess(Model model, Principal principal, RedirectAttributes rttr, HttpSession session) {
        if (principal == null) { // principal 객체가 null인지 확인
            log.warn("회원정보 조회 실패: 로그인되지 않은 사용자입니다.");
            System.out.println("InfoProcess 실행실패 Principal: " + principal.getName());
            rttr.addFlashAttribute("error", "로그인 후 이용 가능합니다.");
            return "redirect:/main";
        }
        String username = principal.getName();
        Users user = usersMapper.findByUsername(username);
        session.setAttribute("userVo", user);
        log.info("내정보 조회 실패"); // 로그 추가
        if (user == null) {
            log.warn("회원정보 조회 실패: 사용자 정보를 찾을 수 없습니다. (username: {})"); // 로그 추가
            rttr.addFlashAttribute("error", "회원정보를 찾을 수 없습니다.");
            return "redirect:/main";
        }
        session.setAttribute("userVo", user);
        model.addAttribute("userVo", user);
        return "Users/userInfo";
    }



    @RequestMapping(value = "/userInfo", method = RequestMethod.POST) // GET 방식으로 변경
    public String userInfo(Model model, Principal principal, HttpSession session) {
        System.out.println("userInfo 메서드 실행");
        log.info("내 정보 조회 실패"); // 로그 추가
        String username = principal.getName();

        log.debug("findByUsername 호출 전: username={}", username);

        Users user = usersMapper.findByUsername(username);

        if (user == null) {
            log.error("findByUsername 결과: 사용자 정보를 찾을 수 없습니다. (username: {})", username);
            throw new UsernameNotFoundException("사용자 정보를 찾을 수 없습니다.");
        } else {
            log.debug("findByUsername 결과: user={}", user); // user 객체 내용 로그 출력
        }

        //System.out.println(user.toString());
        if (user == null) {
            throw new UsernameNotFoundException("사용자 정보를 찾을 수 없습니다.");
        }

        model.addAttribute("userVo", user);
        session.setAttribute("userVo", user); // 세션 업데이트

        log.debug("세션 업데이트 후: userVo={}", session.getAttribute("userVo"));

        return "Users/userInfo";
    }


    //------------------------------------------------------------------------------------------------------------------------

    @RequestMapping("/userEdit")
    public String usersUpdateForm(Model model, Principal principal, HttpSession session) { // Principal 추가
        String username = principal.getName(); // principal에서 사용자 이름 가져오기
        Users userVo = usersMapper.findByUsername(username); // 사용자 정보 조회
        model.addAttribute("userVo", userVo);
        session.setAttribute("userVo", userVo);
        return "Users/userEdit";
    }

    // 회원 정보 수정 처리

    @RequestMapping(value = "/userUpdate", method = RequestMethod.POST)
    public String usersUpdate(@RequestParam("username") String username,
                              @RequestParam("password") String password,
                              @RequestParam("email") String email, // 이미지 파일
                              @RequestParam(value = "profileImage", required = false) String profileImage,
                              @RequestParam(value = "mobile") String mobile,
                              HttpSession session, Principal principal) throws Exception {

        // 입력 값 유효성 검사 (직접 구현)
        if (username.isEmpty() || password.isEmpty() || email.isEmpty() || mobile.isEmpty()) {
            session.setAttribute("error", "모든 필드를 입력해주세요.");
            return "redirect:/Users/userEdit";
        }


        // 비밀번호 길이 검사
        if (password.length() < 8 || password.length() > 16) {
            if(!username.equals(email)){
                session.setAttribute("error", "비밀번호는 8~16자 사이여야 합니다.");
                return "redirect:/Users/userEdit";
            }
        }
        try {
            // 4. 이메일 중복 검사
            if (usersMapper.findByEmail(email) && usersMapper.findByUsername(username).getEmail().equals(email)) { // UsersMapper에 findByEmail 메서드 추가 필요
                System.out.println("기존 이메일과 동일한 이메일주소입니다.");
                session.setAttribute("error", "회원님 이미 사용 중인 이메일로 변경되었습니다");
            }
            if (usersMapper.findByEmail(email) && !usersMapper.findByUsername(username).getEmail().equals(email)) {
                session.setAttribute("error", "이미 사용 중인 이메일입니다.");
                return "redirect:/Users/userEdit";
            }


            // Users 객체 생성 및 데이터 설정
            Users user = usersMapper.findByUsername(principal.getName());
            user.setPassword(passwordEncoder.encode(password));
            user.setEmail(email);
            user.setEnabled(true);
            user.setMobile(mobile);
            user.setProfileImage(profileImage);
            ZoneId zoneId = ZoneId.of("Asia/Seoul"); // 서울 타임존 ID-
            LocalDateTime currentDateTime = LocalDateTime.now();
            LocalDateTime zonedDateTime = ZonedDateTime.of(currentDateTime, zoneId).toLocalDateTime();
            Timestamp updatedAt = Timestamp.valueOf(zonedDateTime);
            user.setUpdatedAt(updatedAt.toLocalDateTime());
            System.out.println("회원 수정시 서울 타임존 현재 시간: " + currentDateTime);
            // 사용자 정보 저장
            usersMapper.updateUser(user);
            Users userAfterUpdate = usersMapper.findByUsername(username);
            session.setAttribute("userVo", userAfterUpdate);
            session.setAttribute("userVoUpdated", userAfterUpdate.getProfileImage());

            session.setAttribute("error", "회원수정에 성공했습니다.");

            return "redirect:/main";
        } catch (Exception e) { // 예외 발생 시 처리
            log.error("회원수정 중 오류 발생:", e); // 오류 로깅

            session.setAttribute("error", "회원수정 중 오류가 발생했습니다.");
            return "redirect:/Users/userEdit"; // 회원수정 페이지로 리다이렉트
        }
    }


    //---------------------------------------------------------------------------------------------------------------------

    // 프로필 이미지 수정 페이지
    @RequestMapping("/UsersImageForm")
    public String usersImageForm() {
        return "Users/UsersImageForm";
    }

    @PostMapping("/UsersImageUpdate") // 이미지 업로드 요청 처리
    public String memberImageUpdate(@RequestParam("username") String username,
                                    @RequestParam("profileImage") MultipartFile profileImage,
                                    HttpServletRequest request,
                                    RedirectAttributes rttr, HttpSession session) throws Exception {

        if (profileImage != null && !profileImage.isEmpty()) {
            String fileName = profileImage.getOriginalFilename();
            String ext = fileName.substring(fileName.lastIndexOf(".") + 1).toUpperCase();

            // 이미지 파일 확장자 검사
            if (ext.equals("PNG") || ext.equals("GIF") || ext.equals("JPG") || ext.equals("JPEG")) {
                String savePath = request.getServletContext().getRealPath("/resources/profileImages");
                File uploadFile = new File(savePath + "/" + fileName);
                profileImage.transferTo(uploadFile); // 파일 저장

                // 사용자 정보 업데이트
                Users user = usersMapper.findByUsername(username);
                user.setProfileImage("/resources/profileImages/" + fileName); // 이미지 경로 설정
                usersMapper.updateUser(user);
                Users userAfterUpdate = usersMapper.findByUsername(username);
                session.setAttribute("userVoUpdated", userAfterUpdate.getProfileImage());

                session.setAttribute("userVo", user);
                session.setAttribute("error", "프로필 이미지가 업데이트되었습니다.");
            } else {
                session.setAttribute("error", "이미지 파일만 업로드할 수 있습니다.");
            }
        } else {
            session.setAttribute("error", "파일을 선택해주세요.");
        }

        return "redirect:/Users/userEdit?msg=true"; // 회원 정보 수정 페이지로 리다이렉트
    }
    //----------------------------------------------------------------------------------------------------------------------------------------
    //회원탈퇴기능
    @RequestMapping("/userdelete")
    public String userDelete(){

        return "Users/userDelete";
    }



    @PostMapping("/delete")
    public String deleteAccount(RedirectAttributes rttr) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            String username = authentication.getName();
            String provider = null;
            String accessToken = null;

            if (authentication.getPrincipal() instanceof OAuth2User) {
                OAuth2User oauth2User = (OAuth2User) authentication.getPrincipal();
                provider = (String) oauth2User.getAttributes().get("registration_id");
                accessToken = (String) oauth2User.getAttributes().get("access_token");
            };
            System.out.println("username :" + username + "registration_id"+provider + "access_token"+accessToken);
            customAccountDeletionService.deleteUserAccount(username, provider, accessToken);
            SecurityContextHolder.clearContext();
            rttr.addFlashAttribute("msg", "회원 탈퇴가 성공적으로 처리되었습니다.");
        }
        return "redirect:/login?accountDeleted";
    }

    @GetMapping("/isAdmin")
    @ResponseBody
    public boolean isAdmin(Principal principal) {
        if (principal != null) {
            String username = principal.getName();
            return usersMapper.isAdmin(username);
        }
        return false;
    }
/*
    @GetMapping("/userLocation") // GET 방식으로 변경
    @ResponseBody // JSON 형태로 응답
    public Map<String, Object> userLocation(Principal principal) {
        System.out.println("userLocation 메서드 실행"); // 이 부분은 삭제해도 무방합니다.
        log.info("사용자 위치 정보 조회 시작 (username: {})", principal.getName());

        Users user = usersMapper.findByUsername(principal.getName());

        if (user == null) {
            log.error("사용자 정보를 찾을 수 없습니다. (username: {})", principal.getName());
            throw new UsernameNotFoundException("사용자 정보를 찾을 수 없습니다.");
        }

        log.debug("DB에서 가져온 사용자 정보: {}", user); // 사용자 정보 전체 로그 출력

        if (user.getLatitude() != null && user.getLongitude() != null) {
            Map<String, Object> userLocation = new HashMap<>();
            userLocation.put("latitude", user.getLatitude());
            userLocation.put("longitude", user.getLongitude());
            log.info("사용자 위치 정보 조회 성공 (latitude: {}, longitude: {})", user.getLatitude(), user.getLongitude());
            return userLocation;
        } else {
            log.warn("사용자의 위도/경도 정보가 없습니다. (username: {})", principal.getName());

            // 사용자 정보를 찾을 수 없거나 위도/경도 값이 없는 경우 기본 위치 반환
            Map<String, Object> defaultLocation = new HashMap<>();
            defaultLocation.put("latitude", 37.5665);
            defaultLocation.put("longitude", 126.9780);
            return defaultLocation;
        }
    }*/
    //------------------------------------------------------------------------------------------------------------------------
    // 접근 거부 페이지
    @GetMapping("/access-denied")
    public String accessDenied() {
        return "access-denied";
    }


}