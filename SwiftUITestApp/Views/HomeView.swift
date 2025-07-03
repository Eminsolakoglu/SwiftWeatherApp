// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    let name: String
    @Binding var isLoggedIn: Bool
    @StateObject private var weatherVM = WeatherViewModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Merhaba, \(name)!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(radius: 3)

                HStack {
                    TextField("Şehir adı gir", text: $weatherVM.city)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .autocorrectionDisabled()

                    Button(action: {
                        Task {
                            await weatherVM.fetchWeather()
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                    .disabled(weatherVM.isLoading)
                }
                .padding(.horizontal)

                Spacer()

                // Yükleme göstergesi
                if weatherVM.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(1.5)
                } else if !weatherVM.temperature.isEmpty {
                    // Hava durumu kartı (Sadece başarılı veri geldiğinde göster)
                    VStack(spacing: 10) {
                        Text(weatherVM.emojiForWeather(main: weatherVM.mainWeather))
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
                } else {
                    // Başlangıç veya hata sonrası mesajı
                    Text("Hava durumu bilgisi yok. Bir şehir arayın!") // Daha genel bir mesaj
                        .foregroundColor(.white.opacity(0.7))
                        .font(.title3)
                        .padding()
                }

                Spacer()

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
        // ALERT MODIFIER'I BURAYA EKLEYİN
        .alert(isPresented: $weatherVM.showAlert) {
            Alert(
                title: Text("Hata"),
                message: Text(weatherVM.alertMessage),
                dismissButton: .default(Text("Tamam")) {
                    // Alert kapatıldığında yapılacak ekstra bir işlem varsa buraya yazılır.
                    // Örneğin, şehir adını temizlemek gibi.
                }
            )
        }
    }
}

#Preview {
    HomeView(name: "emin", isLoggedIn: .constant(true))
}
