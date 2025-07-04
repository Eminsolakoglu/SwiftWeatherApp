// ViewModels/WeatherViewModel.swift
import Foundation
import Combine // Eğer kullanmaya devam ediyorsanız

//@MainActor
class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var temperature: String = ""
    @Published var description: String = ""
    @Published var mainWeather: String = ""
    @Published var isLoading: Bool = false
    @Published private var weatherData: WeatherResponse?


    // Alert durumunu yönetecek yeni değişkenler
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = "" // Kullanıcıya gösterilecek hata mesajı

    private let weatherAPI: WeatherAPI

    init(weatherAPI: WeatherAPI = WeatherAPI()) {
        self.weatherAPI = weatherAPI
    }


    func fetchWeather() async {
        isLoading = true
        // alertMessage'i her yeni istekte temizleyelim
        alertMessage = ""
        showAlert = false

        guard !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.alertMessage = "Lütfen bir şehir adı giriniz."
            self.showAlert = true // Alert'i göster
            isLoading = false
            return
        }

        do {
            let response = try await weatherAPI.fetchCurrentWeather(for: city)
            self.weatherData = response

            self.temperature = "\(Int(response.main.temp))°C"
            self.description = response.weather.first?.description.capitalized ?? "-"
            self.mainWeather = response.weather.first?.main ?? "-"

        } catch {
            // Hata yakalama ve kullanıcıya gösterme
                if let networkError = error as? NetworkError  {
                    self.alertMessage = networkError.localizedDescription // Diğer network hataları
                }
             else {
                self.alertMessage = "Bilinmeyen bir hata oluştu: \(error.localizedDescription)"
            }
            self.showAlert = true // Alert'i göster
            print("Hava durumu çekme hatası: \(error.localizedDescription)") // Terminale debug için yazdır
        }
        isLoading = false
    }

    func emojiForWeather(main: String) -> String {
        switch main {
        case "Clear":
            return "☀️"
        case "Clouds":
            return "☁️"
        case "Rain":
            return "🌧️"
        case "Drizzle":
            return "🌦️"
        case "Thunderstorm":
            return "⛈️"
        case "Snow":
            return "❄️"
        case "Mist", "Fog":
            return "🌫️"
        default:
            return "🌡️"
        }
    }
    var tempMax: String {
        if let max = weatherData?.main.tempMax {
            return String(format: "%.0f°C", max)
        } else {
            return "-"
        }
    }

    var tempMin: String {
        if let min = weatherData?.main.tempMin {
            return String(format: "%.0f°C", min)
        } else {
            return "-"
        }
    }

}
