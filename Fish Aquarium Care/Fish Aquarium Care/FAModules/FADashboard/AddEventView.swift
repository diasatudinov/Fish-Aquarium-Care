//
//  AddEventView.swift
//  Fish Aquarium Care
//
//

import SwiftUI
import PhotosUI
// MARK: - AddEventView

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedType: AquariumEventType = .waterChange
    @State var date: Date = Date()
    @State var description: String = ""
    @State var reminderDate: Date? = nil
    @State var isTypePickerOpen: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var onSave: ((AquariumEvent) -> Void)?

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        eventTypeSection
                        dateSection
                        descriptionSection
                        photoSection
                        saveButton
                    }
                    .padding(.horizontal, 26)
                    .padding(.top, 26)
                    .padding(.bottom, 40)
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    func selectType(_ type: AquariumEventType) {
        selectedType = type
        isTypePickerOpen = false
    }
    
    func loadImage() {
        if let selectedImage = selectedImage {
            print("Selected image size: \(selectedImage.size)")
        }
    }
}

// MARK: - Sections

private extension AddEventView {

    var header: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 74)

            HStack(spacing: 18) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 21, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.08))
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                                )
                        )
                }

                Text("Add Event")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 26)
        }
        .background(Color(red: 0.03, green: 0.16, blue: 0.27))
    }

    var eventTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            title("Event Type")

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isTypePickerOpen.toggle()
                }
            } label: {
                HStack {
                    Text(selectedType.rawValue)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white.opacity(0.55))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.75))
                        .rotationEffect(.degrees(isTypePickerOpen ? 180 : 0))
                }
                .padding(.horizontal, 22)
                .frame(height: 50)
                .background(fieldBackground)
            }

            if isTypePickerOpen {
                VStack(spacing: 0) {
                    ForEach(AquariumEventType.allCases) { type in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectType(type)
                            }
                        } label: {
                            HStack {
                                Text(type.rawValue)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.white)

                                Spacer()
                            }
                            .padding(.horizontal, 18)
                            .frame(height: 58)
                        }

                        if type != AquariumEventType.allCases.last {
                            Divider()
                                .background(Color.white.opacity(0.1))
                                .padding(.horizontal, 18)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 0.13, green: 0.29, blue: 0.43))
                )
            }
        }
    }

    var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            title("Date & Time")

            ZStack {
                HStack {
                    DatePicker(
                        "",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity, maxHeight: 56, alignment: .leading)

                    Spacer()

                    Image(systemName: "calendar")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 22)
                .frame(height: 56)
                .background(fieldBackground)
                

                
            }
        }
    }

    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            title("Description")

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.15, green: 0.36, blue: 0.55).opacity(0.75))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                    )

                TextEditor(text: $description)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)

                if description.isEmpty {
                    Text("Add details about this event...")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                }
            }
            .frame(height: 132)
        }
    }

    var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            title("Photo (Optional)")

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 142)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(alignment: .topTrailing, content: {
                        Button {
                            selectedImage = nil
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
                            showingImagePicker = true
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
                .frame(height: 142)
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
                        showingImagePicker = true
                    }
                }
            }
        }
    }

    var saveButton: some View {
        Button {
            let event = AquariumEvent(type: selectedType, date: date, description: description, photoData: selectedImage?.jpegData(compressionQuality: 0.8))
            onSave?(event)
            dismiss()
        } label: {
            Text("Save Event")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 62)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.yellow)
                        .shadow(color: .yellow.opacity(0.45), radius: 16, x: 0, y: 8)
                )
        }
        .padding(.top, 2)
    }
}

// MARK: - Helpers

private extension AddEventView {

    var background: some View {
        Image(.appBgFA)
            .resizable()
            .padding(-1)
            .ignoresSafeArea()
    }

    var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.tabBarAccent.opacity(0.3), lineWidth: 1)
            )
    }

    func title(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.white.opacity(0.82))
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    AddEventView()
}
