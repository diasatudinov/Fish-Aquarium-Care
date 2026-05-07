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
                    .padding(.bottom, 40)
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
        LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.13, blue: 0.23),
                Color(red: 0.03, green: 0.29, blue: 0.46),
                Color(red: 0.02, green: 0.14, blue: 0.24)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
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