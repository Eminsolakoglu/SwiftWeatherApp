import SwiftUI

struct LoginView: View {
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            // 🌈 Arka plan gradient
            LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // 👋 Başlık
                Text("Giriş Yap")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                
                // 🧑‍💼 Ad girişi
                TextField("Adınızı girin", text: $name)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .font(.title3)
                
                // ✅ Giriş butonu
                Button(action: {
                    withAnimation {
                        print("Giriş yapılıyor: \(name)")
                        isLoggedIn = true
                    }
                }) {
                    Text("Giriş Yap")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(name.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(name.isEmpty)
            }
            .padding()
        }
    }
}

#Preview {
    LoginView(name: .constant(""), isLoggedIn: .constant(false))
}
