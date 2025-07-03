import SwiftUI

struct HomeView: View {
    let name: String
    @Binding var isLoggedIn: Bool
    @StateObject private var weatherVM = WeatherViewModel()
    

    func emojiForWeather(main: String) -> String {
        switch main {
        case "Clear":
            return "☀️"
        case "Clouds":
            return "☁️"
        case "Rain":
            return "🌧️"
        case "Thunderstorm":
            return "⛈️"
        case "Drizzle":
            return "🌦️"
        case "Snow":
            return "❄️"
        case "Mist", "Fog":
            return "🌫️"
        default:
            return "☀️"
        }
    }
    
    var body: some View {
        ZStack {
            // 🌈 Gradient Arka Plan
            LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // 👋 Karşılama
                Text("Merhaba, \(name)!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(radius: 3)

                // 🔍 Şehir arama alanı
                HStack {
                    TextField("Şehir adı gir", text: $weatherVM.city)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)

                    Button(action: {
                        weatherVM.fetchWeather()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                Spacer()
                // ☁️ Hava durumu kartı
                VStack(spacing: 10) {
                    Text(emojiForWeather(main: weatherVM.mainWeather))
                        .font(.system(size: 60))


                    Text(weatherVM.temperature)
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white)

                    Text(weatherVM.description)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 20)

                Spacer()

                // 🔴 Çıkış butonu
                Button("Çıkış Yap") {
                    withAnimation {
                        isLoggedIn = false
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .padding(.bottom)
            }
            .padding()
        }
    }
}

#Preview {
    HomeView(name: "emin", isLoggedIn: .constant(true))
}
