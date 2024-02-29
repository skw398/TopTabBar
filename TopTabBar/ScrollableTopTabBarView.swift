import SwiftUI

private let tabs: [Tab] = [
    .init(title: "For you", color: .cyan),
    .init(title: "Trending", color: .green),
    .init(title: "News", color: .yellow),
    .init(title: "Sports", color: .orange),
    .init(title: "Entertainment", color: .pink)
]

struct ScrollableTopTabBarView: View {
    
    @State private var selectedTabId: UUID? = tabs[0].id
    
    @Namespace private var tabNamespace
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
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
                            .id(tab.id)
                            .padding()
                            .matchedGeometryEffect(
                                id: tab.id, in: tabNamespace, isSource: true
                            )
                        }
                    }
                }
                .onChange(of: selectedTabId, { _, newTabId in
                    if let newTabId,
                       let index = tabs.firstIndex(where: { $0.id == newTabId }) {
                        withAnimation(.easeInOut) {
                            scrollProxy.scrollTo(
                                newTabId,
                                anchor: UnitPoint(
                                    x: CGFloat(index) / CGFloat(tabs.count), y: 0
                                )
                            )
                        }
                    }
                })
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
    ScrollableTopTabBarView()
}
