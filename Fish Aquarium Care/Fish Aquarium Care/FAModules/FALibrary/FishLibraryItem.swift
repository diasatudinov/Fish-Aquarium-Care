import SwiftUI

// MARK: - Library Model

struct FishLibraryItem: Identifiable, Equatable {
    let id: Int
    let russianName: String
    let latinName: String
    let size: String
    let temperament: String
    let temperature: String
    let ph: String
    let minVolume: String
    let food: String
    let difficulty: FishDifficulty
    let category: FishCategory
    
    var title: String {
        russianName
    }
    
    var subtitle: String {
        latinName
    }
    
    var emoji: String {
        switch category {
        case .freshwater:
            return "🐠"
        case .marine:
            return "🐟"
        }
    }
}

enum FishCategory: String {
    case freshwater = "Пресноводная"
    case marine = "Морская"
}

enum FishDifficulty: String {
    case easy = "Лёгкая"
    case medium = "Средняя"
    case hard = "Сложная"
    
    var emoji: String {
        switch self {
        case .easy:
            return "🟢"
        case .medium:
            return "🟡"
        case .hard:
            return "🔴"
        }
    }
    
    var title: String {
        "\(emoji) \(rawValue)"
    }
}