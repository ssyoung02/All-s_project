package bit.naver.listener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationListener;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.web.session.HttpSessionDestroyedEvent;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class MyHttpSessionEventPublisherImpl implements ApplicationListener<HttpSessionDestroyedEvent> {

    private static final Logger logger = LoggerFactory.getLogger(MyHttpSessionEventPublisherImpl.class);

    @Override
    public void onApplicationEvent(HttpSessionDestroyedEvent event) {
        List<SecurityContext> contexts = event.getSecurityContexts();

        if (contexts.isEmpty()) {
            // SecurityContext가 비어있는 경우
            logger.info("익명 사용자 세션 만료됨: {}", event.getSession().getId());
        } else {
            for (SecurityContext context : contexts) {
                Authentication authentication = context.getAuthentication();
                if (authentication != null) {
                    String username = authentication.getName();
                    logger.info("사용자 {}의 세션 만료됨: {}", username, event.getSession().getId());
                } else {
                    logger.info("익명 사용자 세션 만료됨: {}", event.getSession().getId());
                }
            }
        }
    }
}

