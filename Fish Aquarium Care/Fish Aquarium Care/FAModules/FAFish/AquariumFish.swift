import SwiftUI
import PhotosUI

// MARK: - Model

struct AquariumFish: Identifiable {
    let id: UUID
    var name: String
    var species: String
    var purchaseDate: Date?
    var size: String
    var gender: FishGender
    var price: String
    var tempMin: String
    var tempMax: String
    var phMin: String
    var phMax: String
    var foodTypes: [FoodType]
    var feedingFrequency: FeedingFrequency
    var notes: String
    var photoData: Data?

    init(
        id: UUID = UUID(),
        name: String,
        species: String,
        purchaseDate: Date?,
        size: String,
        gender: FishGender,
        price: String,
        tempMin: String,
        tempMax: String,
        phMin: String,
        phMax: String,
        foodTypes: [FoodType],
        feedingFrequency: FeedingFrequency,
        notes: String,
        photoData: Data?
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.purchaseDate = purchaseDate
        self.size = size
        self.gender = gender
        self.price = price
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.phMin = phMin
        self.phMax = phMax
        self.foodTypes = foodTypes
        self.feedingFrequency = feedingFrequency
        self.notes = notes
        self.photoData = photoData
    }
}

enum FishGender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case unknown = "Unknown"

    var id: String { rawValue }
}

enum FoodType: String, CaseIterable, Identifiable {
    case flakes = "Flakes"
    case pellets = "Pellets"
    case liveFood = "Live Food"
    case frozen = "Frozen"
    case vegetables = "Vegetables"

    var id: String { rawValue }
}

enum FeedingFrequency: String, CaseIterable, Identifiable {
    case oneTimePerDay = "1× day"
    case twoTimesPerDay = "2× day"
    case everyOtherDay = "Every other day"

    var id: String { rawValue }
}