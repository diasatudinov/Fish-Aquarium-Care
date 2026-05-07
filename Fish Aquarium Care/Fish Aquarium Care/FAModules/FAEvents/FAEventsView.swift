//
//  FAEventsView.swift
//  Fish Aquarium Care
//
//

import SwiftUI

struct FAEventsView: View {
    @ObservedObject var viewModel: FADashboardViewModel
    var body: some View {
        ZStack {
            Image(.appBgFA)
                .resizable()
                .padding(-1)
                .ignoresSafeArea()
            
            
            VStack {
                Text("Events")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    
                    VStack {
                        ForEach(viewModel.dashboard.tasks, id: \.id) { task in
                           
                            HStack(alignment: .top, spacing: 12) {
                                
                                Text(task.type.icon)
                                    .font(.system(size: 30))
                                
                                VStack(alignment: .leading) {
                                    Text(task.type.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.white)
                                    
                                    Text(task.description)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.6))
                                    
                                    
                                    HStack {
                                        Image(systemName: "calendar")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 12)
                                            
                                        
                                        Text("\(formattedDate(task.date))")
                                            .font(.system(size: 12, weight: .regular))
                                            
                                    }
                                    .foregroundStyle(.white.opacity(0.4))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
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
                    .padding(.bottom, 150)
                }
            }
            .padding(.horizontal)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    FAEventsView(viewModel: FADashboardViewModel())
}
