package bit.naver.listener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationListener;
import org.springframework.security.web.session.HttpSessionCreatedEvent;
import org.springframework.stereotype.Component;

@Component
public class MyHttpSessionEventPublisher implements ApplicationListener<HttpSessionCreatedEvent> {

    private static final Logger logger = LoggerFactory.getLogger(MyHttpSessionEventPublisher.class);

    @Override
    public void onApplicationEvent(HttpSessionCreatedEvent event) {
        String sessionId = event.getSession().getId();
        logger.info("새로운 세션이 생성되었습니다: {}", sessionId);

        // (선택 사항) 세션 생성 시 추가적인 작업 수행
        // 예: 세션 생성 시간 기록, 동시 세션 수 관리, 사용자 접속 정보 기록 등
    }
}
