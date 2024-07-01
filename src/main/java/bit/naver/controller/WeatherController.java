package bit.naver.controller;

import bit.naver.service.WeatherService;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
public class WeatherController {

    @Autowired
    private WeatherService weatherService;

    @GetMapping("/weather")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Object>> getWeather(
            @RequestParam(value = "lat", required = false) Double lat,
            @RequestParam(value = "lon", required = false) Double lon,
            HttpServletRequest request) {

        Map<String, Object> weatherData;

        try {
            if (lat != null && lon != null) {
                weatherData = weatherService.getCurrentWeatherByCoordinates(lat, lon);
            } else {
                weatherData = weatherService.getCurrentWeather("Seoul"); // 기본 위치: 서울
            }
        } catch (Exception e) {
            log.error("날씨 정보 가져오기 실패", e); // 에러 로그 기록
            weatherData = new HashMap<>();
            weatherData.put("error", "날씨 정보를 가져오지 못했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(weatherData);
        }

        return ResponseEntity.ok(weatherData);
    }

}
