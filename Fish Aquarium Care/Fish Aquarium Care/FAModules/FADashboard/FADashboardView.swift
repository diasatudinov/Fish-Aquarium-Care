//
//  FADashboardView.swift
//  Fish Aquarium Care
//
//

import SwiftUI

struct Task {
    var id = UUID()
    var type: EventType
}

enum EventType {
    case waterChange
}

struct FADashboardView: View {
    @ObservedObject var viewModel: FADashboardViewModel
    private enum DashboardViewState {
        case edit, normal
    }
    
    @State private var state: DashboardViewState = .normal
    @State private var title = "My Aquarium"
    @State private var volume = "150 L"
    @State private var type = "Freshwater"
    @State private var fishCount = "12"
    @State private var lastCleaned = "5 days"
    @State private var temperature = "24°C"
    @State private var ph = "7.2"
    @State private var ammonia = "0.0 ppm"
    @State private var nitrates = "10 ppm"
    
    var body: some View {
        ZStack {
            Image(.appBgFA)
                .resizable()
                .padding(-1)
                .ignoresSafeArea()
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        HStack {
                            textField(font: .system(size: 30, weight: .bold), textBinding: $title, text: viewModel.dashboard.title)
                            
                            Button {
                                if state == .edit {
                                    var dashboard = AquariumDashboardModel(
                                        title: title,
                                        volume: volume,
                                        type: type,
                                        fishCount: fishCount,
                                        lastCleaned: lastCleaned,
                                        temperature: temperature,
                                        ph: ph,
                                        ammonia: ammonia,
                                        nitrates: nitrates,
                                        tasks: [])
                                    dashboard.tasks = viewModel.dashboard.tasks
                                    viewModel.editDashboardData(dashboard)
                                    state = .normal
                                } else {
                                    title = viewModel.dashboard.title
                                    volume = viewModel.dashboard.volume
                                    type = viewModel.dashboard.type
                                    fishCount = viewModel.dashboard.fishCount
                                    lastCleaned = viewModel.dashboard.lastCleaned
                                    temperature = viewModel.dashboard.temperature
                                    ph = viewModel.dashboard.ph
                                    ammonia = viewModel.dashboard.ammonia
                                    nitrates = viewModel.dashboard.nitrates
                                    state = .edit
                                }
                            } label: {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                    .padding(9)
                                    .background(.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                textField(title: "Volume",font: .system(size: 20, weight: .bold), textBinding: $volume, text: viewModel.dashboard.volume)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                textField(title: "Type",font: .system(size: 20, weight: .bold), textBinding: $type, text: viewModel.dashboard.type)
                            }
                            
                            HStack {
                                textField(title: "Fish Count",font: .system(size: 20, weight: .bold), textBinding: $fishCount, text: viewModel.dashboard.fishCount)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                textField(title: "Last Cleaned",font: .system(size: 20, weight: .bold), textBinding: $lastCleaned, text: viewModel.dashboard.lastCleaned)
                            }
                        }
                        .padding(24)
                        .background(.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .tabBarAccent.opacity(0.1), radius: 20, x: 0, y: 20)
                        .shadow(color: .tabBarAccent.opacity(0.1), radius: 10, x: 0, y: 8)
                        
                        Text("Water Parameters")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.white)
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                textField(icon: "tempIcon", title: "Temperature",font: .system(size: 20, weight: .bold), textBinding: $temperature, text: viewModel.dashboard.temperature)
                                    .padding(16)
                                    .background(.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                                    )
                                
                                textField(icon: "phIcon", title: "pH",font: .system(size: 20, weight: .bold), textBinding: $ph, text: viewModel.dashboard.ph)
                                    .padding(16)
                                    .background(.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            HStack(spacing: 16) {
                                textField(icon: "ammoniaIcon", title: "Ammonia",font: .system(size: 20, weight: .bold), textBinding: $ammonia, text: viewModel.dashboard.ammonia)
                                    .padding(16)
                                    .background(.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                                    )
                                
                                textField(icon: "nitratesIcon", title: "Nitrates",font: .system(size: 20, weight: .bold), textBinding: $nitrates, text: viewModel.dashboard.nitrates)
                                    .padding(16)
                                    .background(.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                                    )
                                
                            }
                            
                        }
                        
                        Text("Upcoming Tasks")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.white)
                        
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.dashboard.tasks, id: \.id) { task in
                                HStack(spacing: 12) {
                                    
                                    Image(.taskIconFA)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                    
                                    VStack(alignment: .leading) {
                                        Text(task.type.rawValue)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(.white)
                                        
                                        Text("in \(daysUntil(task.date)) days")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundStyle(.white.opacity(0.6))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("\(daysUntil(task.date))")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundStyle(.yellow)
                                }
                                .padding(16)
                                .background(.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        
                        
                    }
                    .padding(.leading, 24)
                    .padding(.trailing, 44)
                    .padding(.bottom, 150)
                }
                .overlay(alignment: .bottomTrailing) {
                    NavigationLink {
                        AddEventView() { task in
                            viewModel.addTask(task)
                        }
                        .navigationBarBackButtonHidden()
                    } label: {
                        Image(.plusBtnFA)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                    }
                    .padding(.bottom, 100)
                    .padding(.trailing, 25)
                }
            }
        }
        
    }
    
    private func daysUntil(_ date: Date) -> Int {
        let calendar = Calendar.current

        let today = calendar.startOfDay(for: Date())
        let targetDate = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: today, to: targetDate)

        return components.day ?? 0
    }
    
    @ViewBuilder
    private func textField(icon: String? = nil, title: String? = nil, font: Font, textBinding: Binding<String>, text: String, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                if let icon {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
                
                if let title {
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
                
            }
            
            if state == .edit {
                TextField(textBinding.wrappedValue, text: textBinding)
                    .font(font)
                    .foregroundColor(.white)
                    .frame(maxWidth: title == nil ? .infinity : 130, alignment: .leading)
                    .keyboardType(keyboardType)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4.5)
                    .background(.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                    )
            } else {
                Text(text)
                    .font(font)
                    .foregroundColor(.white)
                    .frame(maxWidth: title == nil ? .infinity : 130, alignment: .leading)
                    .lineLimit(1)
                
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        FADashboardView(viewModel: FADashboardViewModel())
    }
}
