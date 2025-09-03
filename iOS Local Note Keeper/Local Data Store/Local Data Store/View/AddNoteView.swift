//
//  AddNoteView.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//
import SwiftUI
import SwiftData
import PhotosUI

struct AddNoteView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var description = ""

    @State private var selectedImages: [UIImage] = []
    @State private var selectedPhotoItems: [PhotosPickerItem] = []

    @State private var showCameraPicker = false
    @State private var showGalleryPicker = false
    @State private var showSourceSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TextField("Title", text: $title)
                    .textFieldStyle(.roundedBorder)

                TextEditor(text: $description)
                    .frame(height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))

                // Add Images Button
                Button {
                    showSourceSheet = true
                } label: {
                    Label("Add Images", systemImage: "photo.on.rectangle.angled")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }

                // Image Thumbnails
                if !selectedImages.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                }

                // Save Button
                Button("Save Note") {
                    saveNote()
                }
                .padding()
                .disabled(!formIsValid())
            }
            .padding()
        }
        .navigationTitle("Add Note")

        // Camera Sheet
        .sheet(isPresented: $showCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                if selectedImages.count < 10 {
                    selectedImages.append(image)
                }
            }
        }

        // PhotosPicker (multi-image gallery)
        .photosPicker(
            isPresented: $showGalleryPicker,
            selection: $selectedPhotoItems,
            maxSelectionCount: 10 - selectedImages.count,
            matching: .images
        )
        .onChange(of: selectedPhotoItems) { _ in
            loadPhotosFromPicker()
        }

        // Source Selection
        .confirmationDialog("Choose Image Source", isPresented: $showSourceSheet, titleVisibility: .visible) {
            Button("Camera", systemImage: "camera") {
                showCameraPicker = true
            }
            Button("Photo Library", systemImage: "photo.on.rectangle") {
                showGalleryPicker = true
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    // MARK: - Load Photos
    func loadPhotosFromPicker() {
        Task {
            for item in selectedPhotoItems {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data),
                   selectedImages.count < 10 {
                    selectedImages.append(image)
                }
            }
            selectedPhotoItems = []
        }
    }

    // MARK: - Validation
    func formIsValid() -> Bool {
        title.count >= 5 && title.count <= 100 &&
        description.count >= 100 && description.count <= 1000
    }

    // MARK: - Save Images to Disk
    func saveImages() -> [String] {
        var names: [String] = []
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        for img in selectedImages {
            let name = UUID().uuidString + ".jpg"
            let url = dir.appendingPathComponent(name)
            if let data = img.jpegData(compressionQuality: 0.8) {
                try? data.write(to: url)
                names.append(name)
            }
        }

        return names
    }

    // MARK: - Save Note
    func saveNote() {
        let fileNames = saveImages()
        let note = Note(title: title, description: description, imageFileNames: fileNames)
        context.insert(note)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        dismiss()
    }
}

