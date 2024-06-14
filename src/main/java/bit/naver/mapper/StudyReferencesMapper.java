package bit.naver.mapper;

import bit.naver.entity.StudyReferencesEntity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface StudyReferencesMapper {
    @Select("SELECT * FROM StudyReferences")
    List<StudyReferencesEntity> getAllPosts();

    // 전체 게시물 수를 반환하는 메서드
    @Select("SELECT COUNT(*) FROM StudyReferences")
    int getTotalPosts();
}
