//package bit.naver.controller;
//
//import java.time.LocalDateTime;
//import java.time.format.DateTimeFormatter;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.Map;
//import java.util.concurrent.ConcurrentHashMap;
//
//import bit.naver.entity.Chat;
//import bit.naver.entity.StudyMembers;
//import bit.naver.entity.Users;
//import bit.naver.mapper.ChatMapper;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.socket.CloseStatus;
//import org.springframework.web.socket.TextMessage;
//import org.springframework.web.socket.WebSocketSession;
//import org.springframework.web.socket.handler.TextWebSocketHandler;
//
//@Controller
//@Slf4j
//public class WebSocketHandler extends TextWebSocketHandler {
//
//	@Autowired
//	private ChatMapper chatMapper;
//
//	private final ObjectMapper objectMapper = new ObjectMapper();
//	private final Map<Long, List<WebSocketSession>> roomList = new ConcurrentHashMap<>();
//	private final Map<WebSocketSession, Long> userSessionMap = new ConcurrentHashMap<>();
//	private final List<WebSocketSession> sessionList = new ArrayList<>();
//	private static int connectedUsers = 0;
//
//	@Override
//	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
//		connectedUsers++;
//		log.info(session.getId() + " 연결 성공 => 총 접속 인원 : " + connectedUsers + "명");
//
//		Long userId = getUserId(session);
//		userSessionMap.put(session, userId);
//		sessionList.add(session);
//
//		List<StudyMembers> studyList = chatMapper.getStudiesByUserId(userId);
//
//		for (StudyMembers study : studyList) {
//			roomList.computeIfAbsent(study.getStudyIdx(), k -> new ArrayList<>()).add(session);
//		}
//
//		log.info("연결 후 roomList 상태 : " + roomList);
//	}
//
//	@Override
//	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
//		connectedUsers--;
//		log.info(session.getId() + " 연결 종료 => 총 접속 인원 : " + connectedUsers + "명");
//
//		Long userId = userSessionMap.remove(session);
//		sessionList.remove(session);
//
//		List<StudyMembers> studyList = chatMapper.getStudiesByUserId(userId);
//		for (StudyMembers study : studyList) {
//			List<WebSocketSession> sessions = roomList.get(study.getStudyIdx());
//			if (sessions != null) {
//				sessions.remove(session);
//			}
//		}
//
//		log.info("연결 종료 후 roomList 상태 : " + roomList);
//	}
//
//	@Override
//	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
//		String msg = message.getPayload();
//		Chat chatMessage = objectMapper.readValue(msg, Chat.class);
//		Long studyIdx = chatMessage.getStudyIdx();
//		Long userIdx = getUserId(session);
//
//		if ("enter-room".equals(chatMessage.getMessageContent())) {
//			roomList.computeIfAbsent(studyIdx, k -> new ArrayList<>()).add(session);
//			log.info("방 접속 후 roomList 상태 : " + roomList);
//		} else if ("close-room".equals(chatMessage.getMessageContent())) {
//			List<WebSocketSession> sessions = roomList.get(studyIdx);
//			if (sessions != null) {
//				sessions.remove(session);
//			}
//		} else {
//			LocalDateTime currentDateTime = LocalDateTime.now();
//			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
//			String formattedDateTime = currentDateTime.format(formatter);
//
//			chatMessage.setMessageRegdate(currentDateTime);
//			chatMapper.insertMessage(chatMessage);
//
//			String formattedMessage = String.format("%s,%s,%s,%s", userIdx, chatMessage.getMessageContent(), formattedDateTime, "msg");
//
//			for (WebSocketSession sess : roomList.get(studyIdx)) {
//				sess.sendMessage(new TextMessage(formattedMessage));
//			}
//		}
//	}
//
//	private Long getUserId(WebSocketSession session) {
//		Map<String, Object> httpSession = session.getAttributes();
//		Users loginUser = (Users) httpSession.get("user");
//
//		return (loginUser != null) ? loginUser.getUserIdx() : null;
//	}
//}
