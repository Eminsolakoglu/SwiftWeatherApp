import Foundation

class WeatherAPI {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchCurrentWeather(for city:String) async throws ->WeatherResponse{
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }
        
        let urlString = "\(Constants.openWeatherBaseURL)/weather?q=\(encodedCity)&appid=\(Constants.openWeatherAPIKey)&units=metric"

        guard let url = URL(string:urlString) else{
            throw NetworkError.invalidURL
        }
        
        return try await networkManager.request(url: url)
    }
}
