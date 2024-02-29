import SwiftUI

private let tabs: [Tab] = [
    .init(title: "For you", color: .cyan),
    .init(title: "Trending", color: .green),
    .init(title: "News", color: .yellow),
]

struct FixedTopTabBarView: View {
    
    @State private var selectedTabId: UUID? = tabs[0].id
    
    @Namespace private var tabNamespace
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab
            HStack {
                ForEach(tabs) { tab in
                    Button {
                        selectedTabId = tab.id
                    } label: {
                        Text(tab.title)
                            .bold()
                            .foregroundStyle(
                                selectedTabId == tab.id ? .white : .primary
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .matchedGeometryEffect(
                        id: tab.id, in: tabNamespace, isSource: true
                    )
                }
            }
            .background {
                if let selectedTabId,
                   let color = tabs.first(where: { $0.id == selectedTabId })?.color {
                    Rectangle()
                        .fill(color)
                        .matchedGeometryEffect(
                            id: selectedTabId, in: tabNamespace, isSource: false
                        )
                }
            }
            
            // Content
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(tabs) { tab in
                        ScrollView {
                            ZStack {
                                tab.color
                                VStack {
                                    ForEach(0..<100, id: \.self) { num in
                                        Text(num.description)
                                            .padding()
                                    }
                                }
                            }
                            .containerRelativeFrame(.horizontal)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $selectedTabId)
        }
        .ignoresSafeArea(edges: [.bottom])
        .animation(.easeInOut, value: selectedTabId)
    }
}

#Preview {
    FixedTopTabBarView()
}
