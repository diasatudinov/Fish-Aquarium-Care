//
//  FAMenuView.swift
//  Fish Aquarium Care
//
//

import SwiftUI

struct FAMenuContainer: View {
    
    @AppStorage("firstOpenBB") var firstOpen: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                if firstOpen {
                    FAOnboardingView(getStartBtnTapped: {
                        firstOpen = false
                    })
                } else {
                    FAMenuView()
                }
            }
        }
    }
}

struct FAMenuView: View {
    @State var selectedTab = 0
    @StateObject var dashboardVM = FADashboardViewModel()
    @StateObject  var fishVM = AddNewFishViewModel()
    private let tabs = ["Dashboard", "Fish", "Events",  "Library", "Analytics"]
    
    var body: some View {
        ZStack(alignment: .bottom) {

            TabView(selection: $selectedTab) {
                FADashboardView(viewModel: dashboardVM)
                    .tag(0)
                
                FAFishView(viewModel: fishVM)
                    .tag(1)
                
                FAEventsView(viewModel: dashboardVM)
                    .tag(2)
                
                FishLibraryView(viewModel: fishVM)
                    .tag(3)
                
                AnalyticsView(dashboardViewModel: dashboardVM, fishViewModel: fishVM)
                    .tag(4)
            }
            
            customTabBar
        }
        .background(.clear)
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 32) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    selectedTab = index
                } label: {
                    VStack(spacing: 4) {
                        Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 24)
                        
                        Text(tabs[index])
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(selectedTab == index ? .tabBarAccent : .white.opacity(0.6))
                            .padding(.bottom, 10)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.tabBarBg.opacity(0.95))
        .padding(.bottom, 20)
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconFA"
        case 1: return "tab2IconFA"
        case 2: return "tab3IconFA"
        case 3: return "tab4IconFA"
        case 4: return "tab5IconFA"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelectedFA"
        case 1: return "tab2IconSelectedFA"
        case 2: return "tab3IconSelectedFA"
        case 3: return "tab4IconSelectedFA"
        case 4: return "tab5IconSelectedFA"
        default: return ""
        }
    }
}


#Preview {
    FAMenuContainer()
}
