// MARK: - AddEventView

struct AddEventView: View {

    @StateObject private var viewModel = AddEventViewModel()

    var onBack: (() -> Void)?
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
                        reminderSection
                        saveButton
                    }
                    .padding(.horizontal, 26)
                    .padding(.top, 26)
                    .padding(.bottom, 40)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
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
                    onBack?()
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
                    viewModel.isTypePickerOpen.toggle()
                }
            } label: {
                HStack {
                    Text(viewModel.selectedType.rawValue)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white.opacity(0.55))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.75))
                        .rotationEffect(.degrees(viewModel.isTypePickerOpen ? 180 : 0))
                }
                .padding(.horizontal, 22)
                .frame(height: 50)
                .background(fieldBackground)
            }

            if viewModel.isTypePickerOpen {
                VStack(spacing: 0) {
                    ForEach(AquariumEventType.allCases) { type in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.selectType(type)
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
                    Text(formattedDate(viewModel.date))
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.55))

                    Spacer()

                    Image(systemName: "calendar")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 22)
                .frame(height: 56)
                .background(fieldBackground)

                DatePicker(
                    "",
                    selection: $viewModel.date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .opacity(0.02)
                .frame(maxWidth: .infinity, maxHeight: 56)
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

                TextEditor(text: $viewModel.description)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)

                if viewModel.description.isEmpty {
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

            PhotosPicker(
                selection: $viewModel.selectedPhotoItem,
                matching: .images
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 0.15, green: 0.36, blue: 0.55).opacity(0.65))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
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
                            .frame(height: 142)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.cyan)

                            Text("Tap to upload photo")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.55))
                        }
                    }
                }
                .frame(height: 142)
            }
            .onChange(of: viewModel.selectedPhotoItem) { _ in
                viewModel.loadPhoto()
            }
        }
    }

    var reminderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            title("Set Reminder")

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.isReminderEnabled.toggle()

                    if viewModel.isReminderEnabled && viewModel.reminderDate == nil {
                        viewModel.reminderDate = Date()
                    }
                }
            } label: {
                HStack {
                    Text(reminderText)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(viewModel.isReminderEnabled ? 0.8 : 0.45))

                    Spacer()

                    Image(systemName: viewModel.isReminderEnabled ? "bell.fill" : "bell")
                        .foregroundColor(.white.opacity(0.65))
                }
                .padding(.horizontal, 22)
                .frame(height: 50)
                .background(fieldBackground)
            }

            if viewModel.isReminderEnabled {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { viewModel.reminderDate ?? Date() },
                        set: { viewModel.reminderDate = $0 }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(.cyan)
            }
        }
    }

    var saveButton: some View {
        Button {
            let event = viewModel.makeEvent()
            onSave?(event)
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