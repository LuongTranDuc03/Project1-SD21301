package project.duan1_sd21301.util.phuc;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

/**
 * Client gọi API provinces.open-api.vn để lấy danh sách tỉnh/xã.
 * Trả về JSON string thuần túy, không parse (như yêu cầu của Markdown).
 */
public class ProvinceApiClient {

    private static final String BASE_URL = "https://provinces.open-api.vn/api/v2/p";
    private final HttpClient httpClient;

    public ProvinceApiClient() {
        this.httpClient = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_2)
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    /**
     * Lấy toàn bộ danh sách tỉnh/thành.
     */
    public String getAllProvinces() throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + "/"))
                .GET()
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }

    /**
     * Lấy 1 tỉnh kèm theo danh sách xã/phường (depth=2).
     */
    public String getProvinceWithWards(int provinceCode) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + "/" + provinceCode + "?depth=2"))
                .GET()
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }
}
