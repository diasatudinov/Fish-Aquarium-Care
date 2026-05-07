//
//  FishLibraryItem.swift
//  Fish Aquarium Care
//
//


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
    case freshwater = "Freshwater"
    case marine = "Marine"
}

enum FishDifficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
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

extension FishLibraryItem {
    func toAquariumFish() -> AquariumFish {
        let tempParts = temperature.split(separator: "–").map(String.init)
        let phParts = ph.split(separator: "–").map(String.init)
        
        return AquariumFish(
            name: russianName,
            species: latinName,
            purchaseDate: nil,
            size: size,
            gender: .unknown,
            price: "0",
            tempMin: tempParts.first ?? "",
            tempMax: tempParts.last ?? "",
            phMin: phParts.first ?? "",
            phMax: phParts.last ?? "",
            foodTypes: foodTypes,
            feedingFrequency: .oneTimePerDay,
            notes: """
                        Temperament: \(temperament)
                        Minimum tank size: \(minVolume)
                        Diet: \(food)
                        Difficulty: \(difficulty.title)
                        Category: \(category.rawValue)
                        """,
            photoData: nil
        )
    }
    
    private var foodTypes: [FoodType] {
        switch food {
        case "Herbivore":
            return [.vegetables]
        case "Live food":
            return [.liveFood]
        default:
            return [.flakes]
        }
    }
}

enum FishLibraryData {
    static let items: [FishLibraryItem] = [
        .init(
            id: 1,
            russianName: "Guppy",
            latinName: "Poecilia reticulata",
            size: "3–6 cm",
            temperament: "Peaceful",
            temperature: "22–28",
            ph: "6.8–7.8",
            minVolume: "40 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 2,
            russianName: "Swordtail",
            latinName: "Xiphophorus hellerii",
            size: "8–12 cm",
            temperament: "Peaceful",
            temperature: "22–26",
            ph: "7.0–8.0",
            minVolume: "60 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 3,
            russianName: "Platy",
            latinName: "Xiphophorus maculatus",
            size: "4–6 cm",
            temperament: "Peaceful",
            temperature: "20–25",
            ph: "7.0–8.0",
            minVolume: "40 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 4,
            russianName: "Molly",
            latinName: "Poecilia sphenops",
            size: "6–10 cm",
            temperament: "Peaceful",
            temperature: "24–28",
            ph: "7.0–8.5",
            minVolume: "60 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 5,
            russianName: "Neon Tetra",
            latinName: "Paracheirodon innesi",
            size: "3–4 cm",
            temperament: "Schooling, peaceful",
            temperature: "20–26",
            ph: "6.0–7.0",
            minVolume: "50 L",
            food: "Omnivore",
            difficulty: .medium,
            category: .freshwater
        ),
        .init(
            id: 6,
            russianName: "White Cloud Mountain Minnow",
            latinName: "Tanichthys albonubes",
            size: "3–4 cm",
            temperament: "Schooling, peaceful",
            temperature: "18–22",
            ph: "6.0–7.5",
            minVolume: "40 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 7,
            russianName: "Zebrafish",
            latinName: "Danio rerio",
            size: "4–5 cm",
            temperament: "Schooling, active",
            temperature: "18–24",
            ph: "6.5–7.5",
            minVolume: "50 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 8,
            russianName: "Black Skirt Tetra",
            latinName: "Gymnocorymbus ternetzi",
            size: "5–6 cm",
            temperament: "Peaceful, may nip fins",
            temperature: "22–26",
            ph: "6.0–7.5",
            minVolume: "60 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 9,
            russianName: "Angelfish",
            latinName: "Pterophyllum scalare",
            size: "15 cm",
            temperament: "Semi-peaceful",
            temperature: "24–28",
            ph: "6.5–7.5",
            minVolume: "100 L",
            food: "Omnivore",
            difficulty: .medium,
            category: .freshwater
        ),
        .init(
            id: 10,
            russianName: "Discus",
            latinName: "Symphysodon spp.",
            size: "20 cm",
            temperament: "Peaceful, demanding",
            temperature: "28–32",
            ph: "6.0–7.0",
            minVolume: "200 L",
            food: "Omnivore",
            difficulty: .hard,
            category: .freshwater
        ),
        .init(
            id: 11,
            russianName: "Goldfish",
            latinName: "Carassius auratus",
            size: "15–30 cm",
            temperament: "Peaceful, messy",
            temperature: "18–24",
            ph: "6.5–7.5",
            minVolume: "100 L per fish",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 12,
            russianName: "Tiger Barb",
            latinName: "Puntigrus tetrazona",
            size: "6–7 cm",
            temperament: "Active, fin nipper",
            temperature: "23–26",
            ph: "6.0–7.5",
            minVolume: "80 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 13,
            russianName: "Cherry Barb",
            latinName: "Puntius titteya",
            size: "4–5 cm",
            temperament: "Peaceful, schooling",
            temperature: "22–26",
            ph: "6.0–7.0",
            minVolume: "60 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 14,
            russianName: "Peppered Corydoras",
            latinName: "Corydoras paleatus",
            size: "6–7 cm",
            temperament: "Peaceful, bottom-dwelling",
            temperature: "20–25",
            ph: "6.5–7.5",
            minVolume: "50 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 15,
            russianName: "Bristlenose Pleco",
            latinName: "Ancistrus spp.",
            size: "10–15 cm",
            temperament: "Peaceful, algae eater",
            temperature: "22–28",
            ph: "6.5–7.5",
            minVolume: "80 L",
            food: "Herbivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 16,
            russianName: "Pearl Gourami",
            latinName: "Trichopodus leerii",
            size: "10–12 cm",
            temperament: "Peaceful, labyrinth fish",
            temperature: "24–28",
            ph: "6.5–7.5",
            minVolume: "100 L",
            food: "Omnivore",
            difficulty: .medium,
            category: .freshwater
        ),
        .init(
            id: 17,
            russianName: "Blue Gourami",
            latinName: "Trichopodus trichopterus",
            size: "12–15 cm",
            temperament: "Peaceful, labyrinth fish",
            temperature: "22–28",
            ph: "6.5–7.5",
            minVolume: "100 L",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 18,
            russianName: "Betta",
            latinName: "Betta splendens",
            size: "6–8 cm",
            temperament: "Aggressive toward males",
            temperature: "24–28",
            ph: "6.5–7.5",
            minVolume: "20 L per male",
            food: "Omnivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 19,
            russianName: "Dwarf Neon Rainbowfish",
            latinName: "Melanotaenia praecox",
            size: "6–8 cm",
            temperament: "Peaceful, schooling",
            temperature: "22–26",
            ph: "7.0–8.0",
            minVolume: "80 L",
            food: "Omnivore",
            difficulty: .medium,
            category: .freshwater
        ),
        .init(
            id: 20,
            russianName: "Cockatoo Apistogramma",
            latinName: "Apistogramma cacatuoides",
            size: "7–9 cm",
            temperament: "Semi-peaceful, territorial",
            temperature: "24–28",
            ph: "6.0–7.0",
            minVolume: "60 L",
            food: "Omnivore",
            difficulty: .medium,
            category: .freshwater
        ),
        .init(
            id: 21,
            russianName: "Wendt's Cryptocoryne",
            latinName: "Cryptocoryne wendtii",
            size: "Plant",
            temperament: "—",
            temperature: "22–28",
            ph: "6.0–7.5",
            minVolume: "—",
            food: "—",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 22,
            russianName: "Red Tail Shark",
            latinName: "Epalzeorhynchos bicolor",
            size: "12–15 cm",
            temperament: "Territorial",
            temperature: "24–27",
            ph: "6.5–7.5",
            minVolume: "150 L",
            food: "Omnivore",
            difficulty: .medium,
            category: .freshwater
        ),
        .init(
            id: 23,
            russianName: "Clown Loach",
            latinName: "Chromobotia macracanthus",
            size: "20–30 cm",
            temperament: "Peaceful, schooling",
            temperature: "24–30",
            ph: "6.0–7.0",
            minVolume: "200 L",
            food: "Omnivore",
            difficulty: .hard,
            category: .freshwater
        ),
        .init(
            id: 24,
            russianName: "Sailfin Pleco",
            latinName: "Pterygoplichthys spp.",
            size: "30–50 cm",
            temperament: "Peaceful, algae eater",
            temperature: "24–30",
            ph: "6.5–7.5",
            minVolume: "200 L",
            food: "Herbivore",
            difficulty: .easy,
            category: .freshwater
        ),
        .init(
            id: 25,
            russianName: "Blood Parrot Cichlid",
            latinName: "Hybrid cichlid",
            size: "15–20 cm",
            temperament: "Aggressive, territorial",
            temperature: "24–28",
            ph: "6.5–7.5",
            minVolume: "150 L",
            food: "Omnivore",
            difficulty: .medium,
            category: .freshwater
        ),
        
        .init(
            id: 26,
            russianName: "Ocellaris Clownfish",
            latinName: "Amphiprion ocellaris",
            size: "8–10 cm",
            temperament: "Peaceful, anemone symbiosis",
            temperature: "24–27",
            ph: "8.1–8.4",
            minVolume: "100 L",
            food: "Omnivore",
            difficulty: .medium,
            category: .marine
        ),
        .init(
            id: 27,
            russianName: "Green Chromis",
            latinName: "Chromis viridis",
            size: "8–10 cm",
            temperament: "Schooling, peaceful",
            temperature: "24–27",
            ph: "8.1–8.4",
            minVolume: "150 L",
            food: "Plankton",
            difficulty: .medium,
            category: .marine
        ),
        .init(
            id: 28,
            russianName: "Golden Head Sleeper Goby",
            latinName: "Valenciennea strigata",
            size: "12–15 cm",
            temperament: "Peaceful, bottom-dwelling",
            temperature: "24–27",
            ph: "8.1–8.4",
            minVolume: "200 L",
            food: "Live food",
            difficulty: .hard,
            category: .marine
        ),
        .init(
            id: 29,
            russianName: "Yellow Tang",
            latinName: "Zebrasoma flavescens",
            size: "15–20 cm",
            temperament: "Semi-peaceful",
            temperature: "24–27",
            ph: "8.1–8.4",
            minVolume: "300 L",
            food: "Herbivore",
            difficulty: .hard,
            category: .marine
        ),
        .init(
            id: 30,
            russianName: "Red Lionfish",
            latinName: "Pterois volitans",
            size: "25–35 cm",
            temperament: "Predatory, venomous",
            temperature: "24–27",
            ph: "8.1–8.4",
            minVolume: "400 L",
            food: "Live food",
            difficulty: .hard,
            category: .marine
        )
    ]
}
