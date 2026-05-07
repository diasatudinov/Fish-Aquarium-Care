//
//  FishLibraryView.swift
//  Fish Aquarium Care
//
//

import SwiftUI

struct FishLibraryView: View {
    
    @ObservedObject var viewModel: AddNewFishViewModel
    @State private var searchText = ""
    
    private var filteredItems: [FishLibraryItem] {
        if searchText.isEmpty {
            return FishLibraryData.items
        } else {
            return FishLibraryData.items.filter {
                $0.russianName.localizedCaseInsensitiveContains(searchText) ||
                $0.latinName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        title
                        searchField
                        
                        VStack(spacing: 18) {
                            ForEach(filteredItems) { item in
                                NavigationLink {
                                    FishDetailsView(
                                        item: item,
                                        viewModel: viewModel
                                    )
                                } label: {
                                    FishLibraryCardView(
                                        item: item,
                                        isAdded: isAdded(item)
                                    ) {
                                        addFish(item)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 70)
                    .padding(.bottom, 150)
                }
            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
    
    private var title: some View {
        Text("Fish Library")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.white)
    }
    
    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.45))
            
            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search fish species...")
                        .foregroundColor(.white.opacity(0.4))
                }
                .foregroundColor(.white)
                .font(.system(size: 15))
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private var background: some View {
        Image(.appBgFA)
            .resizable()
            .padding(-1)
            .ignoresSafeArea()
    }
    
    private func addFish(_ item: FishLibraryItem) {
        guard !isAdded(item) else { return }
        viewModel.add(item.toAquariumFish())
    }
    
    private func isAdded(_ item: FishLibraryItem) -> Bool {
        viewModel.fishes.contains {
            $0.name == item.russianName && $0.species == item.latinName
        }
    }
}

#Preview(body: {
    FishLibraryView(viewModel: AddNewFishViewModel())
})

struct FishLibraryCardView: View {
    
    let item: FishLibraryItem
    let isAdded: Bool
    let onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cyan.opacity(0.16))
                
                Text(item.emoji)
                    .font(.system(size: 34))
            }
            .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                Text(item.subtitle)
                    .font(.system(size: 13))
                    .italic()
                    .foregroundColor(.white.opacity(0.6))
                
                HStack(spacing: 8) {
                    tag(item.size)
                    tag(item.temperament)
                    difficultyTag(item.difficulty)
                }
                
                Button {
                    onAdd()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: isAdded ? "checkmark" : "plus")
                        Text(isAdded ? "Added" : "Add to Aquarium")
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isAdded ? .green : .cyan)
                }
                .disabled(isAdded)
            }
            
            Spacer()
        }
        .padding(14)
        .background(.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.white.opacity(0.75))
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.1))
            )
    }
    
    private func difficultyTag(_ difficulty: FishDifficulty) -> some View {
        Text(difficulty.title)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.green)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.green.opacity(0.12))
            )
    }
}
