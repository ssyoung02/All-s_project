package bit.naver.controller;

import bit.naver.entity.Chat;
import bit.naver.entity.StudyGroup;
import bit.naver.entity.Users;
import bit.naver.mapper.ChatMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/studyGroup")
public class ChatController {

    @Autowired
    private ChatMapper chatMapper;
    // 채팅
    @RequestMapping("/chat")
    public String chat(@RequestParam("studyIdx") Long studyIdx, Model model, HttpSession session, Principal principal) {

        Users user = (Users) session.getAttribute("userVo");
        model.addAttribute("userVo", user);

        StudyGroup study = chatMapper.getStudyDescriptionTitle(studyIdx);
        model.addAttribute("study", study);
        System.out.println("1. " + study.toString());

        List<Users> members = chatMapper.getNames(studyIdx);
        model.addAttribute("members", members);
        System.out.println("2. " + members.toString());

        List<Chat> messages = chatMapper.getAllMessages(); // 모든 메시지를 가져오는 예시 메서드

        // Model에 데이터를 담아서 View로 전달
        model.addAttribute("messages", messages);

        return "studyGroup/chat";
    }

    @PostMapping("/sendMessage")
    // 메시지 전송 처리
    public ResponseEntity<String> sendMessage(@RequestParam("message") String message,
                                              @RequestParam("studyIdx") Long studyIdx,
                                              HttpSession session) {
        // 세션에서 사용자 정보 가져오기
        Users user = (Users) session.getAttribute("userVo");
        System.out.println(user.toString()); // 예시로 세션에서 사용자 정보를 가져오는 것으로 가정

        // 메시지 저장 및 결과 처리
        Chat chatMessage = new Chat();
        chatMessage.setStudyIdx(studyIdx); // 스터디 ID 설정
        chatMessage.setUserIdx(user.getUserIdx()); // 사용자 ID 설정
        chatMessage.setMessageContent(message);
        chatMessage.setUserName(user.getName());
        chatMessage.setMessageRegdate(LocalDateTime.now()); // 메시지 등록 시간 설정

        try {
            chatMapper.insertMessage(chatMessage); // 메시지 저장
            System.out.println(chatMessage.toString());
            return ResponseEntity.ok("Message sent successfully");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to send message");
        }
    }


}
