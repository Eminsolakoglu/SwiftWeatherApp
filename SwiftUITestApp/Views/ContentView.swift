import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var isLoggedIn = false

    var body: some View {
      
            if isLoggedIn{
                HomeView(name: name, isLoggedIn: $isLoggedIn)
            }
            else {
                LoginView(name: $name ,isLoggedIn: $isLoggedIn)
            }
        
    }
}
#Preview {
    ContentView()
}

