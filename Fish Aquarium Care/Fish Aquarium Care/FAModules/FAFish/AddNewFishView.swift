// MARK: - AddNewFishView

struct AddNewFishView: View {

    @StateObject private var viewModel = AddNewFishViewModel()

    var onBack: (() -> Void)?
    var onSave: ((AquariumFish) -> Void)?

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        photoSection
                        basicInfoSection
                        waterConditionsSection
                        feedingSection
                        notesSection
                        saveButton
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 24)
                    .padding(.bottom, 44)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Sections

private extension AddNewFishView {

    var header: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 68)

            HStack(spacing: 16) {
                Button {
                    onBack?()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.08))
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                                )
                        )
                }

                Text("Add New Fish")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 22)
        }
        .background(Color(red: 0.03, green: 0.16, blue: 0.27))
    }

    var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            fieldTitle("Photo")

            PhotosPicker(
                selection: $viewModel.selectedPhotoItem,
                matching: .images
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(cardColor.opacity(0.65))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    Color.cyan.opacity(0.45),
                                    style: StrokeStyle(lineWidth: 1, dash: [3, 3])
                                )
                        )

                    if let data = viewModel.photoData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 25, weight: .medium))
                                .foregroundColor(.cyan)

                            Text("Tap to upload photo")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.55))
                        }
                    }
                }
                .frame(height: 150)
            }
            .onChange(of: viewModel.selectedPhotoItem) { _ in
                viewModel.loadPhoto()
            }
        }
    }

    var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Basic Info")

            inputBlock(
                title: "Name",
                placeholder: "Enter fish name",
                text: $viewModel.name
            )

            inputBlock(
                title: "Species",
                placeholder: "e.g., Betta, Goldfish",
                text: $viewModel.species
            )

            HStack(spacing: 16) {
                dateInputBlock

                inputBlock(
                    title: "Size (cm)",
                    placeholder: "5",
                    text: $viewModel.size,
                    keyboardType: .decimalPad
                )
            }

            HStack(spacing: 16) {
                genderInputBlock

                inputBlock(
                    title: "Price ($)",
                    placeholder: "0",
                    text: $viewModel.price,
                    keyboardType: .decimalPad
                )
            }
        }
    }

    var waterConditionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Water Conditions")

            HStack(spacing: 16) {
                inputBlock(
                    title: "Temp Min (°C)",
                    placeholder: "22",
                    text: $viewModel.tempMin,
                    keyboardType: .decimalPad
                )

                inputBlock(
                    title: "Temp Max (°C)",
                    placeholder: "26",
                    text: $viewModel.tempMax,
                    keyboardType: .decimalPad
                )
            }

            HStack(spacing: 16) {
                inputBlock(
                    title: "pH Min",
                    placeholder: "6.5",
                    text: $viewModel.phMin,
                    keyboardType: .decimalPad
                )

                inputBlock(
                    title: "pH Max",
                    placeholder: "7.5",
                    text: $viewModel.phMax,
                    keyboardType: .decimalPad
                )
            }
        }
    }

    var feedingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Feeding")

            VStack(alignment: .leading, spacing: 12) {
                fieldTitle("Food Type")

                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        foodChip(.flakes)
                        foodChip(.pellets)
                        foodChip(.liveFood)
                    }

                    HStack(spacing: 10) {
                        foodChip(.frozen)
                        foodChip(.vegetables)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                fieldTitle("Frequency")

                HStack(spacing: 0) {
                    ForEach(FeedingFrequency.allCases) { frequency in
                        Button {
                            viewModel.feedingFrequency = frequency
                        } label: {
                            Text(frequency.rawValue)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(
                                    viewModel.feedingFrequency == frequency
                                    ? .black
                                    : .white.opacity(0.48)
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(
                                            viewModel.feedingFrequency == frequency
                                            ? Color.yellow
                                            : Color.clear
                                        )
                                )
                        }
                    }
                }
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(cardColor.opacity(0.75))
                )
            }
        }
    }

    var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            fieldTitle("Notes")

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardColor.opacity(0.75))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.cyan.opacity(0.18), lineWidth: 1)
                    )

                TextEditor(text: $viewModel.notes)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)

                if viewModel.notes.isEmpty {
                    Text("Any additional notes...")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.38))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 19)
                }
            }
            .frame(height: 118)
        }
    }

    var saveButton: some View {
        Button {
            let fish = viewModel.makeFish()
            onSave?(fish)
        } label: {
            Text("Save Fish")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.yellow)
                        .shadow(color: .yellow.opacity(0.45), radius: 16, x: 0, y: 8)
                )
        }
        .padding(.top, 6)
    }
}