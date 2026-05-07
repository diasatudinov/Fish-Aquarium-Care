//
//  AquariumDashboardModel.swift
//  Fish Aquarium Care
//
//

import SwiftUI

struct AquariumDashboardModel: Codable {
    var title: String
    var volume: String
    var type: String
    var fishCount: String
    var lastCleaned: String
    var temperature: String
    var ph: String
    var ammonia: String
    var nitrates: String
    var tasks: [AquariumEvent]
}
