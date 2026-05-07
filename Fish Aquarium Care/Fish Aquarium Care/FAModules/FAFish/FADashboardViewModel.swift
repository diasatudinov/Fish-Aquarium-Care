//
//  FADashboardViewModel.swift
//  Fish Aquarium Care
//
//

import Foundation

final class FADashboardViewModel: ObservableObject {
    @Published var dashboard: AquariumDashboardModel = AquariumDashboardModel(
        title: "My Aquarium",
        volume: "150 L",
        type: "Freshwater",
        fishCount: "12",
        lastCleaned: "5 days",
        temperature: "24°C",
        ph: "7.2",
        ammonia: "0.0 ppm",
        nitrates: "10 ppm",
        tasks: [
        ]
    ) {
        didSet {
            saveDashboard()
        }
    }
    
    private var dashboardFileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("dashboard.json")
    }
    
    init() {
        loadDashboard()
    }
    
    private func saveDashboard() {
        let url = dashboardFileURL
        do {
            let data = try JSONEncoder().encode(dashboard)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save teams:", error)
        }
    }
    
    private func loadDashboard() {
        let url = dashboardFileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let dashboardData = try JSONDecoder().decode(AquariumDashboardModel.self, from: data)
            dashboard = dashboardData
        } catch {
            print("Failed to load teams:", error)
        }
    }
    
    func editDashboardData(_ dashboard: AquariumDashboardModel) {
        self.dashboard = dashboard
    }
    
    func addTask(_ task: AquariumEvent) {
        dashboard.tasks.append(task)
    }
}
