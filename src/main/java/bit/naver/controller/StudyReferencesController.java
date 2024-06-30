package bit.naver.controller;

import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.List;
import java.util.Objects;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import bit.naver.entity.CommentsEntity;
import bit.naver.entity.LikeReferencesEntity;
import bit.naver.entity.StudyReferencesEntity;
import bit.naver.entity.Users;
import bit.naver.mapper.UsersMapper;
import bit.naver.security.UsersUserDetailsService;
import bit.naver.service.StudyReferencesService;
import lombok.RequiredArgsConstructor;

// StudyReferencesController 클래스: 클라이언트의 요청을 처리하는 컨트롤러 계층
@Controller
@RequestMapping("/studyReferences")
@RequiredArgsConstructor
public class StudyReferencesController {
	@Autowired
	private UsersMapper usersMapper;

	private final UsersUserDetailsService usersUserDetailsService;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private StudyReferencesService studyReferencesService;

	private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

	@RequestMapping("/referencesList")
	public String getStudyReferencesList(Model model,
			@RequestParam(value = "searchKeyword", required = false) String searchKeyword,
			@RequestParam(value = "searchOption", required = false) String searchOption,
			@RequestParam(value = "limits", required = false, defaultValue = "5") String limits, HttpSession session,
			Principal principal) {
		String username = principal.getName();
		Users user = usersMapper.findByUsername(username);
		String userIdx = String.valueOf(user != null ? user.getUserIdx() : 59); // 사용자 ID 가져오기
		List<StudyReferencesEntity> studyReferencesEntity = studyReferencesService.getStudyReferencesList(userIdx,
				searchKeyword, searchOption, limits);
		model.addAttribute("studyReferencesEntity", studyReferencesEntity);
		model.addAttribute("userIdx", userIdx); // 나중에 59만 로그인한사람의 userIdx로 바꿔주기
		model.addAttribute("limits", limits);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchOption", searchOption);
		model.addAttribute("user", user);
		session.setAttribute("userVo", user);

		return "/studyReferences/referencesList";
	}

	@RequestMapping("/referencesRead")
	public String getStudyReferencesRead(Model model, @RequestParam("referenceIdx") Long referenceIdx,
			HttpSession session) {
		Users user = (Users) session.getAttribute("userVo");
		String userIdx = String.valueOf(user.getUserIdx()); // 사용자 ID 가져오기
		StudyReferencesEntity studyReferencesEntity = studyReferencesService.getStudyReferenceById(referenceIdx,
				userIdx);
		List<CommentsEntity> studyRefencesComment = studyReferencesService.getCommentsByReferenceIdx(referenceIdx);

		model.addAttribute("studyReferencesEntity", studyReferencesEntity);
		model.addAttribute("studyRefencesComment", studyRefencesComment);
		model.addAttribute("userIdx", userIdx); // 나중에 59만 로그인한사람의 userIdx로 바꿔주기

		return "/studyReferences/referencesRead";
	}

	@RequestMapping("/deleteComment")
	@ResponseBody
	public String deleteComment(@RequestParam("commentIdx") String commentIdx) {
		// System.out.println("comment Idx >>> " + commentIdx); 값 제대로 넘어오는지 확인하기 위해
		return studyReferencesService.deleteComment(commentIdx);
	}

	@RequestMapping("/insertComment")
	@ResponseBody
	public String insertComment(@ModelAttribute CommentsEntity content, HttpSession session) {
		Users user = (Users) session.getAttribute("userVo");
		Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
		content.setUserIdx(userIdx); // 임의로 userIdx값 줌
		return studyReferencesService.insertComment(content);
	}

	@RequestMapping("/insertLike")
	@ResponseBody
	public int insertLike(@ModelAttribute LikeReferencesEntity entity) {
		return studyReferencesService.insertLike(entity);
	}

	@RequestMapping("/deleteLike")
	@ResponseBody
	public int deleteLike(@ModelAttribute LikeReferencesEntity entity) {
		// System.out.println("ENTITY >>>" + entity.toString());
		return studyReferencesService.deleteLike(entity);
	}

	@RequestMapping("/updateReport")
	@ResponseBody
	public int updateReport(@ModelAttribute StudyReferencesEntity entity) {
		return studyReferencesService.updateReport(entity);
	}

	@GetMapping("/referencesWrite")
	public String referencesWrite(@ModelAttribute StudyReferencesEntity entity) {
		return "/studyReferences/referencesWrite";
	}

	@PostMapping("/referencesWrite")
	@ResponseBody
	public Long submitPost(@ModelAttribute StudyReferencesEntity entity, @RequestParam(required = false) MultipartFile uploadFile, HttpSession session, HttpServletResponse response) {
		Users user = (Users) session.getAttribute("userVo");
		Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
		entity.setUserIdx(userIdx);

		// 파일 크기 검사
		if (uploadFile != null && uploadFile.getSize() > MAX_FILE_SIZE) {
			return 10L;
		}

		try {
			// 파일이 있는 경우 처리
			if (uploadFile != null && !uploadFile.isEmpty()) {
				String fileName = uploadFile.getOriginalFilename();
				if (fileName.length() > 100) { // 최대 길이 제한
					fileName = fileName.substring(0, 100);
				}
				entity.setFileName(fileName);
				entity.setFileAttachments(uploadFile.getBytes());
			} else {
				entity.setFileName(null);
				entity.setFileAttachments(null);
			}
		} catch (IOException e) {
			e.printStackTrace();
			return -1L;
		}

		// 파일 여부와 관계없이 글 작성 처리
		return studyReferencesService.writePost(entity);
	}



	@RequestMapping("/deletePost")
	@ResponseBody
	public int deletePost(@RequestParam("referenceIdx") int referenceIdx) {
		//System.out.println("referenceIdx: " + referenceIdx);
		return studyReferencesService.deletePost(referenceIdx);
	}

	@RequestMapping("/referencesModify")
	public String modifyPost(Model model, @ModelAttribute StudyReferencesEntity entity, HttpSession session) {
		Users user = (Users) session.getAttribute("userVo");
		String userIdx = String.valueOf(user.getUserIdx()); // 사용자 ID 가져오기
		StudyReferencesEntity studyReferencesEntity = studyReferencesService
				.getStudyReferenceById(entity.getReferenceIdx(), userIdx);
		model.addAttribute("studyReferencesEntity", studyReferencesEntity);

		return "/studyReferences/referencesModify";
	}

	@PostMapping("/updatePost")
	@ResponseBody
	public Long updatePost(@ModelAttribute StudyReferencesEntity entity,
						   @RequestParam("referenceIdx") Long referenceIdx,
						   @RequestParam(value = "uploadFile", required = false) MultipartFile uploadFile,
						   HttpSession session, HttpServletResponse response) {
		Users user = (Users) session.getAttribute("userVo");
		Long userIdx = user.getUserIdx(); // 사용자 ID 가져오기
		entity.setUserIdx(userIdx);
		entity.setReferenceIdx(referenceIdx); //전달받은 IDX값 저장

		// 파일 크기 검사
		if (uploadFile != null && uploadFile.getSize() > MAX_FILE_SIZE) {
			return 10L;
		}

		try {
			// 파일이 있는 경우 처리
			if (uploadFile != null && !uploadFile.isEmpty()) {
				String fileName = uploadFile.getOriginalFilename();
				if (fileName.length() > 100) { // 최대 길이 제한
					fileName = fileName.substring(0, 100);
				}
				entity.setFileName(fileName);
				entity.setFileAttachments(uploadFile.getBytes());
			} else {
				// 파일이 없으면 null로 설정
				entity.setFileName(null);
				entity.setFileAttachments(null);
			}
		} catch (IOException e) {
			e.printStackTrace();
			return -1L;
		}

		// 파일 여부와 관계없이 글 수정 처리
		return studyReferencesService.updatePost(entity);
	}


	@GetMapping("/referencesSite")
	public String referencesSite(@ModelAttribute StudyReferencesEntity entity) {
		return "/studyReferences/referencesSite";
	}

	@GetMapping(value = "/download")
	public void fileDownload(@RequestParam("referenceIdx") Long referenceIdx, HttpSession session,
							 HttpServletResponse response) {
		Users user = (Users) session.getAttribute("userVo");
		String userIdx = String.valueOf(user.getUserIdx()); // 사용자 ID 가져오기
		StudyReferencesEntity entity = studyReferencesService.getStudyReferenceById(referenceIdx, userIdx);

		String mimeType = "application/octet-stream";
		try {
			mimeType = Files.probeContentType(Paths.get(entity.getFileName()));
		} catch (IOException e) {
			e.printStackTrace();
		}

		response.setContentType(mimeType);

		// 파일 이름 인코딩 처리
		String encodedFileName;
		try {
			String userAgent = response.getHeader("User-Agent");
			if (userAgent != null && (userAgent.contains("MSIE") || userAgent.contains("Trident") || userAgent.contains("Edge"))) {
				encodedFileName = URLEncoder.encode(entity.getFileName(), "UTF-8").replaceAll("\\+", "%20");
			} else {
				encodedFileName = new String(entity.getFileName().getBytes("UTF-8"), "ISO-8859-1");
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			encodedFileName = entity.getFileName();
		}

		response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

		try (InputStream inputStream = new ByteArrayInputStream(entity.getFileAttachments());
			 OutputStream outputStream = response.getOutputStream()) {

			byte[] buffer = new byte[1024];
			int bytesRead;
			while ((bytesRead = inputStream.read(buffer)) != -1) {
				outputStream.write(buffer, 0, bytesRead);
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
