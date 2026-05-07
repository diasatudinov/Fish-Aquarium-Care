import SwiftUI

// MARK: - Models

struct AnalyticsSummary {
    let totalEvents: Int
    let avgWaterChangeDays: Int
    let fishAddedThisMonth: Int
    let waterQualityPercent: Int
}

struct WaterParameterPoint: Identifiable {
    let id = UUID()
    let date: Date
    let temperature: Double
    let ph: Double
}

enum FishHealthStatus: String, CaseIterable, Identifiable {
    case healthy = "Healthy"
    case monitor = "Monitor"
    case treatment = "Treatment"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .healthy:
            return Color(red: 0.05, green: 0.78, blue: 0.45)
        case .monitor:
            return Color.orange
        case .treatment:
            return Color.red
        }
    }
}

struct FishHealthItem: Identifiable {
    let id = UUID()
    let status: FishHealthStatus
    let count: Int
}

// MARK: - ViewModel

final class AnalyticsViewModel: ObservableObject {

    @Published var summary = AnalyticsSummary(
        totalEvents: 24,
        avgWaterChangeDays: 7,
        fishAddedThisMonth: 3,
        waterQualityPercent: 92
    )

    @Published var waterPoints: [WaterParameterPoint] = [
        .init(date: Date().addingTimeInterval(-29 * 24 * 60 * 60), temperature: 24.0, ph: 7.1),
        .init(date: Date().addingTimeInterval(-24 * 24 * 60 * 60), temperature: 24.5, ph: 7.2),
        .init(date: Date().addingTimeInterval(-19 * 24 * 60 * 60), temperature: 24.2, ph: 7.0),
        .init(date: Date().addingTimeInterval(-14 * 24 * 60 * 60), temperature: 24.4, ph: 7.1),
        .init(date: Date().addingTimeInterval(-9 * 24 * 60 * 60), temperature: 24.6, ph: 7.2),
        .init(date: Date().addingTimeInterval(-4 * 24 * 60 * 60), temperature: 24.3, ph: 7.1),
        .init(date: Date(), temperature: 24.4, ph: 7.2)
    ]

    @Published var healthItems: [FishHealthItem] = [
        .init(status: .healthy, count: 10),
        .init(status: .monitor, count: 1),
        .init(status: .treatment, count: 1)
    ]
}