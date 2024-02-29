import SwiftUI

@main
struct TopTabBarApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ScrollableTopTabBarView()
                    .tabItem {
                        Text("ScrollableTopTabBarView")
                    }
                FixedTopTabBarView()
                    .tabItem {
                        Text("FixedTopTabBarView")
                    }
            }
        }
    }
}
