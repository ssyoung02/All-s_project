package bit.naver.service;

import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.net.URL;
import java.net.HttpURLConnection;

@Service
public class WeatherService {

    @Value("${openweathermap.api.key}")
    private String apiKey;

    private static final Logger logger = LoggerFactory.getLogger(WeatherService.class); // Logger 초기화
    public Map<String, Object> getCurrentWeather(String location) {
        return fetchWeatherData(location);
    }

    public Map<String, Object> getCurrentWeatherByCoordinates(double lat, double lon) {
        return fetchWeatherData("lat=" + lat + "&lon=" + lon);
    }

    private Map<String, Object> fetchWeatherData(String query) {
        Map<String, Object> result = new HashMap<>();

        try {
            String apiUrl = "https://api.openweathermap.org/data/2.5/weather?" + query + "&appid=" + apiKey + "&units=metric&lang=kr";
            logger.info("Weather API Request URL: {}", apiUrl);
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestProperty("x-api-key", apiKey);
            conn.setRequestMethod("GET");

            // API 응답 읽기
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line;
            StringBuilder response = new StringBuilder();
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();

            // JSON 파싱
            JSONParser parser = new JSONParser();
            JSONObject jsonObject = (JSONObject) parser.parse(response.toString());

            // 날씨 정보 추출
            JSONObject main = (JSONObject) jsonObject.get("main");
            double temperature = (double) main.get("temp");
            JSONArray weatherArray = (JSONArray) jsonObject.get("weather");
            JSONObject weather = (JSONObject) weatherArray.get(0);
            String iconCode = (String) weather.get("icon");
            String locationName = (String) jsonObject.get("name");   // 지역 정보 추출

            result.put("temperature", temperature);
            result.put("location", locationName);
            result.put("icon", getWeatherIconUrl(iconCode)); // 아이콘 URL 추가
        } catch (Exception e) {
            e.printStackTrace();
            result.put("error", "날씨 정보를 가져오지 못했습니다.");
        }

        return result;
    }

    public String getWeatherIconUrl(String iconCode) {
        return "http://openweathermap.org/img/wn/" + iconCode + "@2x.png?t=" + new Date().getTime(); // 캐시 방지 추가
    }
}