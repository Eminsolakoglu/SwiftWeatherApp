import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var isLoggedIn = false

    var body: some View {
        Group{
            if isLoggedIn{
                HomeView(name: name, isLoggedIn: $isLoggedIn)
            }
            else {
                LoginView(name: $name ,isLoggedIn: $isLoggedIn)
            }
        }
        .padding()
    }
}
#Preview {
    ContentView()
}

