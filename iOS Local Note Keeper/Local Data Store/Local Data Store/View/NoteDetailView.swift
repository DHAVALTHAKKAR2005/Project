//
//  NoteDetailView.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//


import SwiftUI

struct NoteDetailView: View {
    let note: Note

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(note.title).font(.title).bold()
                Text(note.caption)

                ForEach(note.imageFileNames, id: \.self) { fileName in
                    if let uiImage = loadImage(named: fileName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Note Details")
    }

    func loadImage(named: String) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(named)
        return UIImage(contentsOfFile: url.path)
    }
}

