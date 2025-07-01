import SwiftUI

struct LoginView: View {
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    var body: some View{
        VStack(spacing: 20) {
                Text("Login")
                .font(.largeTitle)
                .bold(true)
                
            TextField("Name",text: $name)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Login"){
                print("Giriş yapılıyor: \(name)")
                isLoggedIn=true
            }
            .tint(.green)
            .disabled(name.isEmpty)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
