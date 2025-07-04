import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case apiError(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Geçersiz URL."
        case .invalidResponse: return "Geçersiz sunucu yanıtı. Lütfen tekrar deneyin."
        case .decodingError(let error): return "Veri okunurken bir hata oluştu: \(error.localizedDescription)"
        case .apiError(let message):
            if message.localizedCaseInsensitiveContains("city not found") || message.localizedCaseInsensitiveContains("not found") || message.localizedCaseInsensitiveContains("nothing to geocode") {
                return "Şehir bulunamadı. Lütfen geçerli bir şehir adı giriniz."
            }
            return "API Hatası: \(message)"
        case .unknownError: return "Bilinmeyen bir hata oluştu. Lütfen daha sonra tekrar deneyin."
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager() // Singleton
    
    private init() {} // Dışarıdan örneklemeyi engellenmesi için
    
    func request<T: Decodable>(url: URL) async throws -> T {
        // data ve response'u tek seferde al
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Başarılı HTTP durum kodlarını kontrol et (200-299)
        guard (200...299).contains(httpResponse.statusCode) else {
            // Hata durumu: API yanıtını çözümlemeye çalış
            print("API Hata Yanıtı HTTP Durum Kodu: \(httpResponse.statusCode)") // Debug çıktısı
            
            if let apiErrorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                print("API Hata Mesajı (Çözümlendi): \(apiErrorResponse.message ?? "Mesaj yok")") // Debug çıktısı
                throw NetworkError.apiError(apiErrorResponse.message ?? "Bilinmeyen API Hatası")
            } else {
                // Eğer APIErrorResponse olarak çözümlenemiyorsa (farklı format veya boş yanıt),
                // ve HTTP durumu 404 ise özel bir hata fırlat.
                print("API Hata Yanıtı (Ham Data Çözümlenemedi): \(String(data: data, encoding: .utf8) ?? "Geçersiz UTF-8 data")") // Debug çıktısı
                if httpResponse.statusCode == 404 {
                    throw NetworkError.apiError("City not found or invalid request") // Yaygın 404 API mesajı
                } else {
                    throw NetworkError.invalidResponse // Diğer durumlarda genel geçersiz yanıt hatası
                }
            }
        }
        
        // Decoding (Başarılı HTTP yanıtı sonrası)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.unknownError
        }
    }
}

struct APIErrorResponse: Decodable {
    let cod: String?
    let message: String?
}
