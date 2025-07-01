import SwiftUI

struct HomeView: View {
    let name: String
    @Binding var isLoggedIn: Bool
    @StateObject private var weatherVM = WeatherViewModel()

    
    var body: some View {
        
        VStack(spacing: 20){
            
            ZStack(){
                Color.blue
                    .ignoresSafeArea()
                    .frame( height: 80)
                
                    Text("Hello, \(name)!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
            }
            HStack{
                TextField("City Name", text: $weatherVM.city)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                Button("Search"){
                    print("havadurmu aranıyor ,\(weatherVM.city)")
                    weatherVM.fetchWeather()
                }
                .buttonStyle(.borderedProminent)
                .frame(width: 80)
            }
            Text("Tempruarature: \(weatherVM.temperature)")
            Text("Description: \(weatherVM.description)")
            

            
            Button("Quit"){
                print("çıkış yapılıyor")
                isLoggedIn=false
                
            }
            .tint(.red)
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }
}
#Preview {
    HomeView(name: "emin", isLoggedIn: .constant(true))
}
