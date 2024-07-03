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
import org.springframework.web.bind.annotation.CrossOrigin;
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

    @Value("${google.maps.api.key}")
    private String googleMapsApiKey;

    @Autowired
    private WeatherService weatherService;

    @GetMapping("/weather")
    public ResponseEntity<Map<String, Object>> getWeather(
            @RequestParam(value = "lat", required = false) Double lat,
            @RequestParam(value = "lon", required = false) Double lon,
            HttpServletRequest request, Model model) {

        Map<String, Object> weatherData;

        try {
            if (lat != null && lon != null) {
                weatherData = weatherService.getCurrentWeatherByCoordinates(lat, lon);
            } else {
                weatherData = weatherService.getCurrentWeather("Seoul"); // 기본 위치: 서울
            }
            weatherData.put("googleMapsApiKey", googleMapsApiKey); // Google Maps API 키 추가
        } catch (Exception e) {
            log.error("날씨 정보 가져오기 실패", e); // 에러 로그 기록
            weatherData = new HashMap<>();
            weatherData.put("error", "날씨 정보를 가져오지 못했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(weatherData);
        }
        model.addAttribute("googleMapsApiKey", googleMapsApiKey);
        return ResponseEntity.ok(weatherData);
    }
}
