//
//  AnalyticsView.swift
//  Fish Aquarium Care
//
//

import SwiftUI
import Charts

#Preview {
    AnalyticsView(dashboardViewModel: FADashboardViewModel(), fishViewModel: AddNewFishViewModel())
}
// MARK: - AnalyticsView

struct AnalyticsView: View {

    @ObservedObject var dashboardViewModel: FADashboardViewModel
    @ObservedObject var fishViewModel: AddNewFishViewModel

    var body: some View {
        ZStack {
            background

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 26) {
                    header
                    monthlyLabel
                    statsGrid
                    waterParametersCard
                    fishHealthCard
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 150)
            }
        }
        .ignoresSafeArea()
    }
}
// MARK: - Sections

private extension AnalyticsView {

    var dashboard: AquariumDashboardModel {
        dashboardViewModel.dashboard
    }

    var fishes: [AquariumFish] {
        fishViewModel.fishes
    }

    var currentMonthEvents: [AquariumEvent] {
        dashboard.tasks.filter { event in
            isInLast30Days(event.date)
        }
    }

    var totalEvents: Int {
        currentMonthEvents.count
    }

    var fishAddedThisMonth: Int {
        fishes.filter { fish in
            guard let purchaseDate = fish.purchaseDate else {
                return true
            }

            return isInLast30Days(purchaseDate)
        }.count
    }

    var avgWaterChangeDays: Int {
        let waterChanges = currentMonthEvents
            .filter { $0.type == .waterChange }
            .sorted { $0.date < $1.date }

        guard waterChanges.count >= 2 else {
            return extractFirstNumber(from: dashboard.lastCleaned) ?? 0
        }

        let intervals = zip(waterChanges, waterChanges.dropFirst()).compactMap { first, second in
            Calendar.current.dateComponents([.day], from: first.date, to: second.date).day
        }

        guard !intervals.isEmpty else {
            return 0
        }

        return intervals.reduce(0, +) / intervals.count
    }

    var waterQualityPercent: Int {
        let temperature = extractDouble(from: dashboard.temperature)
        let ph = extractDouble(from: dashboard.ph)
        let ammonia = extractDouble(from: dashboard.ammonia)
        let nitrates = extractDouble(from: dashboard.nitrates)

        var score = 0

        if let temperature, (22...28).contains(temperature) {
            score += 25
        }

        if let ph, (6.5...7.5).contains(ph) {
            score += 25
        }

        if let ammonia, ammonia <= 0.25 {
            score += 25
        }

        if let nitrates, nitrates <= 20 {
            score += 25
        }

        return score
    }

    var healthyFishCount: Int {
        max(fishes.count - monitorFishCount - treatmentFishCount, 0)
    }

    var monitorFishCount: Int {
        fishes.filter { fish in
            let tempMin = extractDouble(from: fish.tempMin)
            let tempMax = extractDouble(from: fish.tempMax)
            let phMin = extractDouble(from: fish.phMin)
            let phMax = extractDouble(from: fish.phMax)

            let currentTemp = extractDouble(from: dashboard.temperature)
            let currentPh = extractDouble(from: dashboard.ph)

            let tempIsBad: Bool
            if let currentTemp, let tempMin, let tempMax {
                tempIsBad = !(tempMin...tempMax).contains(currentTemp)
            } else {
                tempIsBad = false
            }

            let phIsBad: Bool
            if let currentPh, let phMin, let phMax {
                phIsBad = !(phMin...phMax).contains(currentPh)
            } else {
                phIsBad = false
            }

            return tempIsBad || phIsBad
        }.count
    }

    var treatmentFishCount: Int {
        currentMonthEvents.filter { $0.type == .treatment }.count
    }

    var healthItems: [FishHealthItem] {
        [
            FishHealthItem(status: .healthy, count: healthyFishCount),
            FishHealthItem(status: .monitor, count: monitorFishCount),
            FishHealthItem(status: .treatment, count: treatmentFishCount)
        ]
    }

    var waterPoints: [WaterParameterPoint] {
        let currentTemp = extractDouble(from: dashboard.temperature) ?? 0
        let currentPh = extractDouble(from: dashboard.ph) ?? 0
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let days = [0, 5, 10, 15, 20, 25, 30]
        
        return days.compactMap { dayOffset in
            guard let date = calendar.date(
                byAdding: .day,
                value: dayOffset,
                to: today
            ) else {
                return nil
            }
            
            return WaterParameterPoint(
                date: date,
                temperature: currentTemp,
                ph: currentPh
            )
        }
    }
}

private extension AnalyticsView {

    var header: some View {
        Text("Analytics")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(.white)
    }

    var monthlyLabel: some View {
        Text("Last 30 Days")
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.black)
            .padding(.horizontal, 24)
            .frame(height: 52)
            .background(
                Capsule()
                    .fill(Color.yellow)
                    .shadow(color: .yellow.opacity(0.28), radius: 12, x: 0, y: 6)
            )
    }

    var statsGrid: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 18) {
                statCard(
                    title: "Total Events",
                    value: "\(totalEvents)"
                )

                statCard(
                    title: "Avg Water Change",
                    value: avgWaterChangeDays == 0 ? "No data" : "\(avgWaterChangeDays) days"
                )
            }

            HStack(spacing: 18) {
                statCard(
                    title: "Fish Added",
                    value: "\(fishAddedThisMonth) this month"
                )

                statCard(
                    title: "Water Quality",
                    value: "\(waterQualityPercent)%"
                )
            }
        }
    }

    var waterParametersCard: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text("Water Parameters")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)

            WaterParametersLineChart(points: waterPoints)
                .frame(height: 230)
        }
        .padding(24)
        .background(cardBackground)
    }

    var fishHealthCard: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text("Fish Health Status")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 26) {
                DonutChart(items: healthItems)
                    .frame(width: 120, height: 120)

                VStack(alignment: .leading, spacing: 22) {
                    ForEach(healthItems) { item in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(item.status.color)
                                .frame(width: 12, height: 12)

                            Text(item.status.rawValue)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.75))

                            Spacer()

                            Text("\(item.count)")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(cardBackground)
    }

    func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.55))

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
    }
}

// MARK: - Components

private extension AnalyticsView {

    var background: some View {
        Image(.appBgFA)
            .resizable()
            .padding(-1)
            .ignoresSafeArea()
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(Color(red: 0.15, green: 0.36, blue: 0.55).opacity(0.78))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
            )
    }

    func isInLast30Days(_ date: Date) -> Bool {
        let calendar = Calendar.current

        guard let startDate = calendar.date(
            byAdding: .day,
            value: -30,
            to: Date()
        ) else {
            return false
        }

        return date >= startDate && date <= Date()
    }

    func extractFirstNumber(from text: String) -> Int? {
        let numbers = text.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .compactMap { Int($0) }

        return numbers.first
    }

    func extractDouble(from text: String) -> Double? {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        let filtered = text.unicodeScalars
            .filter { allowedCharacters.contains($0) }
            .map(String.init)
            .joined()
            .replacingOccurrences(of: ",", with: ".")

        return Double(filtered)
    }
}
// MARK: - Water Line Chart

struct WaterParametersLineChart: View {

    let points: [WaterParameterPoint]

    private let yLabels: [Double] = [28, 21, 14, 7, 0]

    var body: some View {
        VStack(spacing: 18) {
            chart

            legend
        }
    }

    private var chart: some View {
        GeometryReader { geo in
            let leftPadding: CGFloat = 42
            let bottomPadding: CGFloat = 30
            let topPadding: CGFloat = 10
            let rightPadding: CGFloat = 10

            let width = geo.size.width - leftPadding - rightPadding
            let height = geo.size.height - bottomPadding - topPadding

            ZStack {
                gridLines(
                    size: geo.size,
                    leftPadding: leftPadding,
                    topPadding: topPadding,
                    bottomPadding: bottomPadding
                )

                yAxisLabels(
                    size: geo.size,
                    topPadding: topPadding,
                    height: height
                )

                xAxisLabels(
                    size: geo.size,
                    leftPadding: leftPadding,
                    topPadding: topPadding,
                    width: width,
                    height: height
                )

                linePath(
                    values: points.map { $0.temperature },
                    minValue: 0,
                    maxValue: 28,
                    leftPadding: leftPadding,
                    topPadding: topPadding,
                    width: width,
                    height: height
                )
                .stroke(Color.yellow, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))

                dots(
                    values: points.map { $0.temperature },
                    minValue: 0,
                    maxValue: 28,
                    color: .yellow,
                    leftPadding: leftPadding,
                    topPadding: topPadding,
                    width: width,
                    height: height
                )
            }
        }
    }

    private var legend: some View {
        HStack(spacing: 22) {
            legendItem(color: .yellow, title: "Temp (°C)")
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func legendItem(color: Color, title: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .stroke(color, lineWidth: 2)
                .frame(width: 8, height: 8)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
        }
    }
}

// MARK: - Chart Helpers

private extension WaterParametersLineChart {

    func linePath(
        values: [Double],
        minValue: Double,
        maxValue: Double,
        leftPadding: CGFloat,
        topPadding: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> Path {
        Path { path in
            guard values.count > 1 else { return }

            for index in values.indices {
                let x = leftPadding + CGFloat(index) / CGFloat(values.count - 1) * width
                let normalized = (values[index] - minValue) / (maxValue - minValue)
                let y = topPadding + height - CGFloat(normalized) * height

                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
    }

    func dots(
        values: [Double],
        minValue: Double,
        maxValue: Double,
        color: Color,
        leftPadding: CGFloat,
        topPadding: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        ZStack {
            ForEach(values.indices, id: \.self) { index in
                let x = leftPadding + CGFloat(index) / CGFloat(values.count - 1) * width
                let normalized = (values[index] - minValue) / (maxValue - minValue)
                let y = topPadding + height - CGFloat(normalized) * height

                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                    .position(x: x, y: y)
            }
        }
    }

    func gridLines(
        size: CGSize,
        leftPadding: CGFloat,
        topPadding: CGFloat,
        bottomPadding: CGFloat
    ) -> some View {
        let height = size.height - bottomPadding - topPadding
        let width = size.width - leftPadding - 10

        return ZStack {
            ForEach(yLabels.indices, id: \.self) { index in
                let y = topPadding + CGFloat(index) / CGFloat(yLabels.count - 1) * height

                Path { path in
                    path.move(to: CGPoint(x: leftPadding, y: y))
                    path.addLine(to: CGPoint(x: leftPadding + width, y: y))
                }
                .stroke(Color.white.opacity(0.12), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            }

            ForEach(points.indices, id: \.self) { index in
                let x = leftPadding + CGFloat(index) / CGFloat(points.count - 1) * width

                Path { path in
                    path.move(to: CGPoint(x: x, y: topPadding))
                    path.addLine(to: CGPoint(x: x, y: topPadding + height))
                }
                .stroke(Color.white.opacity(0.08), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            }

            Path { path in
                path.move(to: CGPoint(x: leftPadding, y: topPadding))
                path.addLine(to: CGPoint(x: leftPadding, y: topPadding + height))
                path.addLine(to: CGPoint(x: leftPadding + width, y: topPadding + height))
            }
            .stroke(Color.white.opacity(0.7), lineWidth: 1.5)
        }
    }

    func yAxisLabels(
        size: CGSize,
        topPadding: CGFloat,
        height: CGFloat
    ) -> some View {
        ZStack {
            ForEach(yLabels.indices, id: \.self) { index in
                let y = topPadding + CGFloat(index) / CGFloat(yLabels.count - 1) * height

                Text("\(Int(yLabels[index]))")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.85))
                    .position(x: 22, y: y)
            }
        }
    }

    func xAxisLabels(
        size: CGSize,
        leftPadding: CGFloat,
        topPadding: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        ZStack {
            ForEach(points.indices, id: \.self) { index in
                if index % 2 == 0 || index == points.count - 1 {
                    let x = leftPadding + CGFloat(index) / CGFloat(points.count - 1) * width

                    Text(shortDate(points[index].date))
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.85))
                        .position(x: x, y: topPadding + height + 18)
                }
            }
        }
    }

    func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Donut Chart

struct DonutChart: View {

    let items: [FishHealthItem]

    private var total: Int {
        items.map(\.count).reduce(0, +)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.12), lineWidth: 28)

            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Circle()
                    .trim(
                        from: startTrim(for: index),
                        to: endTrim(for: index)
                    )
                    .stroke(
                        item.status.color,
                        style: StrokeStyle(lineWidth: 28, lineCap: .butt)
                    )
                    .rotationEffect(.degrees(-90))
            }

            Circle()
                .fill(Color(red: 0.15, green: 0.36, blue: 0.55))
                .frame(width: 82, height: 82)
        }
    }

    private func startTrim(for index: Int) -> CGFloat {
        guard total > 0 else { return 0 }

        let previous = items.prefix(index).map(\.count).reduce(0, +)
        return CGFloat(previous) / CGFloat(total)
    }

    private func endTrim(for index: Int) -> CGFloat {
        guard total > 0 else { return 0 }

        let current = items.prefix(index + 1).map(\.count).reduce(0, +)
        return CGFloat(current) / CGFloat(total)
    }
}
