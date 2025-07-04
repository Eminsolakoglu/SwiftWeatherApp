import SwiftUI

struct LoginView: View {
    @Binding var name: String
    @Binding var isLoggedIn: Bool

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Giriş Yap")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(radius: 3)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)

                    HStack {
                        TextField("Adınızı girin", text: $name)
                            .padding(.vertical, 12)
                            .padding(.leading)
                            .autocorrectionDisabled()

                        if !name.isEmpty {
                            Button(action: {
                                name = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 18))
                            }
                            .padding(.trailing, 10) // 'x' ikonunun sağında boşluk bıraktık
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .frame(height: 50)
                .padding(.horizontal)

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
