//
//  AddNewFishView.swift
//  Fish Aquarium Care
//
//

import SwiftUI
import PhotosUI

// MARK: - AddNewFishView

struct AddNewFishView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AddNewFishViewModel

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
            .sheet(isPresented: $viewModel.showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $viewModel.selectedImage, isPresented: $viewModel.showingImagePicker)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    func loadImage() {
        if let selectedImage = viewModel.selectedImage {
            print("Selected image size: \(selectedImage.size)")
        }
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
                    dismiss()
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

            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(alignment: .topTrailing, content: {
                        Button {
                            viewModel.selectedImage = nil
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .black))
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.red)
                                .clipShape(Circle())
                        }
                    })
                    .onTapGesture {
                        withAnimation {
                            viewModel.showingImagePicker = true
                        }
                    }
            } else {
                VStack(spacing: 12) {
                    Image(.uploadIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)

                    Text("Tap to upload photo")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.55))
                }
                .frame(height: 150)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.15, green: 0.36, blue: 0.55).opacity(0.75))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .onTapGesture {
                    withAnimation {
                        viewModel.showingImagePicker = true
                    }
                }
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
            viewModel.add(fish)
            dismiss()
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

private extension AddNewFishView {

    func inputBlock(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            fieldTitle(title)

            TextField("", text: text)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.35))
                }
                .font(.system(size: 16))
                .foregroundColor(.white)
                .keyboardType(keyboardType)
                .padding(.horizontal, 16)
                .frame(height: 48)
                .background(inputBackground)
        }
        .frame(maxWidth: .infinity)
    }

    var dateInputBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            fieldTitle("Purchase Date")

            ZStack {
                HStack {
                    DatePicker(
                        "",
                        selection: $viewModel.purchaseDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .onChange(of: viewModel.purchaseDate) { _ in
                        viewModel.hasPurchaseDate = true
                    }

                    Spacer()

                    Image(systemName: "calendar")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.72))
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .background(inputBackground)

            }
        }
        .frame(maxWidth: .infinity)
    }

    var genderInputBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            fieldTitle("Gender")

            Menu {
                ForEach(FishGender.allCases) { gender in
                    Button(gender.rawValue) {
                        viewModel.gender = gender
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.gender.rawValue)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.55))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white.opacity(0.55))
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .background(inputBackground)
            }
        }
        .frame(maxWidth: .infinity)
    }

    func foodChip(_ type: FoodType) -> some View {
        let isSelected = viewModel.selectedFoodTypes.contains(type)

        return Button {
            viewModel.toggleFoodType(type)
        } label: {
            HStack(spacing: 5) {
                Text(type.rawValue)

                if isSelected {
                    Text("×")
                }
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(isSelected ? .black : .white)
            .padding(.horizontal, 16)
            .frame(height: 36)
            .background(
                Capsule()
                    .fill(isSelected ? Color.yellow : cardColor.opacity(0.8))
                    .overlay(
                        Capsule()
                            .stroke(Color.cyan.opacity(isSelected ? 0 : 0.2), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Style Helpers

private extension AddNewFishView {

    var background: some View {
        Image(.appBgFA)
            .resizable()
            .padding(-2)
            .ignoresSafeArea()
    }

    var cardColor: Color {
        Color(red: 0.15, green: 0.36, blue: 0.55)
    }

    var inputBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(cardColor.opacity(0.78))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cyan.opacity(0.18), lineWidth: 1)
            )
    }

    func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
    }

    func fieldTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white.opacity(0.82))
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    AddNewFishView(viewModel: AddNewFishViewModel())
}
