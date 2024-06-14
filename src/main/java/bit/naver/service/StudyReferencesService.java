package bit.naver.service;

import bit.naver.entity.StudyReferencesEntity;
import bit.naver.mapper.StudyReferencesMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudyReferencesService {

    @Autowired
    private StudyReferencesMapper studyReferencesMapper;

    public List<StudyReferencesEntity> getAllPosts() {
        return studyReferencesMapper.getAllPosts();
    }

    // 전체 게시물 수를 반환하는 메서드
    public int getTotalPosts() {
        return studyReferencesMapper.getTotalPosts();
    }
}
