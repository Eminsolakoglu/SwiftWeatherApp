import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case apiError(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case.invalidURL:return "Geçersiz URL"
            case .invalidResponse:return "Geçersiz sunucu yanıtı"
        case .decodingError(let error):return "Decoding Error: \(error.localizedDescription)"
        case .apiError(let message):return "API Error: \(message)"
        case .unknownError:return "Unknown Error"
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager() //Singleton
    
    private init(){} //Dışarıdan örneklemeyi engellenmesi için
    
    func request<T: Decodable>(url: URL) async throws -> T {
        do{
            let(data, response)=try await URLSession.shared.data(from: url)

            guard let httpResponse=response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard(200...299).contains(httpResponse.statusCode) else {
                if let errorResponse=try? JSONDecoder().decode(APIErrorResponse.self,from: data){
                    throw NetworkError.apiError(errorResponse.message ?? "API Error")
                }else{
                    throw NetworkError.invalidResponse
                }
            }
            let decoder=JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
            
        }catch let decodingError as DecodingError{
            throw NetworkError.decodingError(decodingError)
        }catch let networkError{
            throw networkError
        }catch {
            throw NetworkError.unknownError
        }
    }
}
struct APIErrorResponse: Decodable {
    let cod:String?
    let message:String?
}

