//
//  ContentView.swift
//  ScrollableSlidingTabs
//
//  Created by Shigenari Oshio on 2022/11/30.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    
    private var tabs: [(title: String, color: Color)] = [
        ("For you", .cyan),
        ("Trending", .green),
        ("News", .yellow),
        ("Sports", .orange),
        ("Entertainment", .pink)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<tabs.count, id: \.self) { i in
                            tabButton(index: i)
                                .modifier(if: i == selectedTab) { content in
                                    content
                                        .anchorPreference(
                                            key: AnchorPreferenceKey.self,
                                            value: .bounds
                                        ) { $0 }
                                }
                        }
                    }
                }
                .onChange(of: selectedTab, perform: { selectedTab in
                    withAnimation(.easeInOut) {
                        scrollProxy.scrollTo(selectedTab, anchor: UnitPoint(x: 0.5, y: 0))
                    }
                })
            }
            .backgroundPreferenceValue(AnchorPreferenceKey.self) { anchor in
                if let anchor {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            underline(bounds: geometry[anchor])
                        }
                    }
                }
            }
            
            TabView(selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { i in
                    ZStack {
                        tabs[i].color
                        Text(tabs[i].title)
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .animation(.easeInOut, value: selectedTab)
    }
    
    private func tabButton(index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            Text(tabs[index].title)
                .fontWeight(.bold)
                .foregroundColor(selectedTab == index ? .primary : .gray)
        }
        .id(index)
        .padding()
    }
    
    private func underline(bounds: CGRect) -> some View {
        let padding: CGFloat = 20
        return Rectangle()
            .fill(.blue)
            .cornerRadius(5 / 2)
            .offset(x: bounds.minX + padding / 2, y: bounds.minY)
            .frame(width: bounds.width - padding, height: 5)
    }
    
    private struct AnchorPreferenceKey: PreferenceKey {
        static var defaultValue: Anchor<CGRect>? = nil
        static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
            value = nextValue()
        }
    }
}

private extension View {
    @ViewBuilder func modifier<Content: View>(
        if shouldModify: Bool,
        modifier: (Self) -> Content
    ) -> some View {
        if shouldModify {
            modifier(self)
        } else { self }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
