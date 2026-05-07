//
//  AddNewFishViewModel.swift
//  Fish Aquarium Care
//
//

import SwiftUI
import PhotosUI

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

    @Published var selectedImage: UIImage?
    @Published var showingImagePicker = false
    
    @Published var fishes: [AquariumFish] = [] {
        didSet {
            saveFishes()
        }
    }
    
    private var fishesFileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("fishesFileURL.json")
    }
    
    init() {
        loadFishes()
    }
    
    private func saveFishes() {
        let url = fishesFileURL
        do {
            let data = try JSONEncoder().encode(fishes)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save teams:", error)
        }
    }
    
    private func loadFishes() {
        let url = fishesFileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let dashboardData = try JSONDecoder().decode([AquariumFish].self, from: data)
            fishes = dashboardData
        } catch {
            print("Failed to load teams:", error)
        }
    }
    
    func toggleFoodType(_ type: FoodType) {
        if selectedFoodTypes.contains(type) {
            selectedFoodTypes.remove(type)
        } else {
            selectedFoodTypes.insert(type)
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
            photoData: selectedImage?.jpegData(compressionQuality: 0.8)
        )
    }
    
    func add(_ fish: AquariumFish) {
        fishes.append(fish)
    }
}
