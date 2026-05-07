// MARK: - ViewModel

final class AddNewFishViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var species: String = ""

    @Published var purchaseDate: Date = Date()
    @Published var hasPurchaseDate: Bool = false

    @Published var size: String = "5"
    @Published var gender: FishGender = .male
    @Published var price: String = "0"

    @Published var tempMin: String = "22"
    @Published var tempMax: String = "26"
    @Published var phMin: String = "6.5"
    @Published var phMax: String = "7.5"

    @Published var selectedFoodTypes: Set<FoodType> = [.flakes]
    @Published var feedingFrequency: FeedingFrequency = .oneTimePerDay

    @Published var notes: String = ""

    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var photoData: Data?

    func toggleFoodType(_ type: FoodType) {
        if selectedFoodTypes.contains(type) {
            selectedFoodTypes.remove(type)
        } else {
            selectedFoodTypes.insert(type)
        }
    }

    func loadPhoto() {
        guard let selectedPhotoItem else { return }

        Task {
            do {
                let data = try await selectedPhotoItem.loadTransferable(type: Data.self)

                await MainActor.run {
                    self.photoData = data
                }
            } catch {
                print("Photo loading error:", error)
            }
        }
    }

    func makeFish() -> AquariumFish {
        AquariumFish(
            name: name,
            species: species,
            purchaseDate: hasPurchaseDate ? purchaseDate : nil,
            size: size,
            gender: gender,
            price: price,
            tempMin: tempMin,
            tempMax: tempMax,
            phMin: phMin,
            phMax: phMax,
            foodTypes: Array(selectedFoodTypes),
            feedingFrequency: feedingFrequency,
            notes: notes,
            photoData: photoData
        )
    }
}