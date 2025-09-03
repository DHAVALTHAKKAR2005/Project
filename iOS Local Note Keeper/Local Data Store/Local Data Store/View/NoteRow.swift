//
//  NoteRow.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//


import SwiftUI

struct NoteRow: View {
    let note: Note

    var body: some View {
        HStack(spacing: 12) {
            if let firstImage = note.imageFileNames.first,
               let uiImage = loadImage(named: firstImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.headline)
                Text(note.caption.prefix(50) + "...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }

    func loadImage(named: String) -> UIImage? {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = dir.appendingPathComponent(named)
        return UIImage(contentsOfFile: url.path)
    }
}

