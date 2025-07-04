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
                    
                    if !weatherVM.city.isEmpty {
                        Button(action: {
                            weatherVM.city = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 18)) // 'x' ikonunun boyutunu belirledik
                        }
                    }
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
                    HStack {
                        Text(weatherVM.emojiForWeather(main: weatherVM.mainWeather))
                            .font(.system(size: 60))
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(weatherVM.temperature) in \(weatherVM.city)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(weatherVM.description)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(weatherVM.tempMax)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(weatherVM.tempMin)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            
                        }
                        .padding(.trailing)
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
                
                
                    .alert(isPresented: $weatherVM.showAlert) {
                        Alert(
                            title: Text("Hata"),
                            message: Text(weatherVM.alertMessage),
                            dismissButton: .default(Text("Tamam")) {
                                
                            }
                        )
                    }
            }
        }
    }
}
#Preview {
    HomeView(name: "emin", isLoggedIn: .constant(true))
}
