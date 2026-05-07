//
//  FAFishView.swift
//  Fish Aquarium Care
//
//

import SwiftUI

struct FAFishView: View {
    @ObservedObject var viewModel: AddNewFishViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    var body: some View {
        ZStack {
            Image(.appBgFA)
                .resizable()
                .padding(-1)
                .ignoresSafeArea()
            
            
            VStack {
                Text("My Fish")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.fishes, id: \.id) { fish in
                            VStack(alignment: .leading, spacing: 12) {
                                if let imageData = fish.photoData {
                                    Image(uiImage: UIImage(data: imageData)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height:  120)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                } else {
                                    Image(.fishPlaceholderFA)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height:  120)
                                    
                                }
                                
                                Text(fish.name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                
                                Text(fish.species)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.white.opacity(0.6))
                                    .lineLimit(1)
                                
                                Text("Added \(formattedDate(fish.date))")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundStyle(.white.opacity(0.4))
                            }
                            .padding()
                            .background(.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 18)
                }
                .overlay(alignment: .bottomTrailing) {
                    NavigationLink {
                        AddNewFishView(viewModel: viewModel)
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
    NavigationStack {
        FAFishView(viewModel: AddNewFishViewModel())
    }
}
