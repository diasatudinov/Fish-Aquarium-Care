import SwiftUI
import PhotosUI

// MARK: - Model

struct AquariumEvent: Identifiable, Codable, Equatable {
    let id: UUID
    var type: AquariumEventType
    var date: Date
    var description: String
    var photoData: Data?
    var reminderDate: Date?

    init(
        id: UUID = UUID(),
        type: AquariumEventType,
        date: Date,
        description: String,
        photoData: Data? = nil,
        reminderDate: Date? = nil
    ) {
        self.id = id
        self.type = type
        self.date = date
        self.description = description
        self.photoData = photoData
        self.reminderDate = reminderDate
    }
}

enum AquariumEventType: String, CaseIterable, Identifiable, Codable {
    case waterChange = "Water change"
    case feeding = "Feeding"
    case filterCleaning = "Filter Cleaning"
    case treatment = "Treatment"
    case newFish = "New Fish"
    case equipment = "Equipment"
    case other = "Other"

    var id: String {
        rawValue
    }
}