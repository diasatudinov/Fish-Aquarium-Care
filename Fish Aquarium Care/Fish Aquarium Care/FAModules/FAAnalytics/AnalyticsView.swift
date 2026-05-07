// MARK: - AnalyticsView

struct AnalyticsView: View {

    @StateObject private var viewModel = AnalyticsViewModel()

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
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Sections

private extension AnalyticsView {

    var header: some View {
        Text("Analytics")
            .font(.system(size: 40, weight: .bold))
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
        VStack(spacing: 18) {
            HStack(spacing: 18) {
                statCard(
                    title: "Total Events",
                    value: "\(viewModel.summary.totalEvents)"
                )

                statCard(
                    title: "Avg Water Change",
                    value: "\(viewModel.summary.avgWaterChangeDays) days"
                )
            }

            HStack(spacing: 18) {
                statCard(
                    title: "Fish Added",
                    value: "\(viewModel.summary.fishAddedThisMonth) this\nmonth"
                )

                statCard(
                    title: "Water Quality",
                    value: "\(viewModel.summary.waterQualityPercent)%"
                )
            }
        }
    }

    var waterParametersCard: some View {
        VStack(alignment: .leading, spacing: 26) {
            Text("Water Parameters")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)

            WaterParametersLineChart(points: viewModel.waterPoints)
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
                DonutChart(items: viewModel.healthItems)
                    .frame(width: 170, height: 170)

                VStack(alignment: .leading, spacing: 22) {
                    ForEach(viewModel.healthItems) { item in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(item.status.color)
                                .frame(width: 16, height: 16)

                            Text(item.status.rawValue)
                                .font(.system(size: 19))
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
}