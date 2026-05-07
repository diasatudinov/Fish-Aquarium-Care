//
//  FishDetailsView.swift
//  Fish Aquarium Care
//
//
import SwiftUI

struct FishDetailsView: View {
    
    let item: FishLibraryItem
    @ObservedObject var viewModel: AddNewFishViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    private var isAdded: Bool {
        viewModel.fishes.contains {
            $0.name == item.russianName && $0.species == item.latinName
        }
    }
    
    var body: some View {
        ZStack {
            background
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    fishImage
                    mainInfoCard
                    waterParametersCard
                    infoCard(title: "Diet", text: item.food)
                    infoCard(title: "Tank Size", text: "Minimum \(item.minVolume)")
                    infoCard(title: "Temperament", text: item.temperament)
                    infoCard(title: "Difficulty", text: item.difficulty.title)
                    addButton
                }
                .padding(.horizontal, 24)
                .padding(.top, 58)
                .padding(.bottom, 42)
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        HStack(spacing: 14) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 38, height: 38)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.16), lineWidth: 1)
                            )
                    )
            }
            
            Text(item.russianName)
                .font(.system(size: 23, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    private var fishImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.75))
            
            Text(item.emoji)
                .font(.system(size: 86))
        }
        .frame(height: 165)
    }
    
    private var mainInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.russianName)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text(item.latinName)
                .font(.system(size: 15))
                .italic()
                .foregroundColor(.white.opacity(0.65))
            
            HStack(spacing: 8) {
                detailTag(item.size)
                detailTag(item.temperament)
                detailTag(item.difficulty.title)
            }
            
            Text("Category: \(item.category.rawValue). Recommended minimum tank size is \(item.minVolume).")
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.82))
                .lineSpacing(4)
        }
        .padding(22)
        .background(cardBackground)
    }
    
    private var waterParametersCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Water parameters")
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 18) {
                parameterItem(
                    icon: "thermometer",
                    title: "Temperature",
                    value: "\(item.temperature)°C",
                    color: .yellow
                )
                
                parameterItem(
                    icon: "drop.fill",
                    title: "pH Range",
                    value: item.ph,
                    color: .cyan
                )
            }
        }
        .padding(22)
        .background(cardBackground)
    }
    
    private func parameterItem(
        icon: String,
        title: String,
        value: String,
        color: Color
    ) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(color)
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.55))
                
                Text(value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func infoCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.78))
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
    }
    
    private var addButton: some View {
        Button {
            guard !isAdded else { return }
            viewModel.add(item.toAquariumFish())
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isAdded ? "checkmark" : "plus")
                Text(isAdded ? "Added to My Aquarium" : "Add to My Aquarium")
            }
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color.yellow)
                    .shadow(color: .yellow.opacity(0.45), radius: 16, x: 0, y: 8)
            )
        }
        .disabled(isAdded)
        .padding(.top, 2)
    }
    
    private func detailTag(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.white.opacity(0.75))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.1))
            )
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(Color(red: 0.15, green: 0.36, blue: 0.55).opacity(0.78))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.cyan.opacity(0.18), lineWidth: 1)
            )
    }
    
    private var background: some View {
        Image(.appBgFA)
            .resizable()
            .padding(-1)
            .ignoresSafeArea()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            
            self
        }
    }
}
