//
//  Note.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//


import Foundation
import SwiftData

@Model
class Note {
    var id: UUID
    var title: String
    var caption: String
    var imageFileNames: [String]
    var createdAt: Date

    init(title: String, description: String, imageFileNames: [String]) {
        self.id = UUID()
        self.title = title
        self.caption = description
        self.imageFileNames = imageFileNames
        self.createdAt = Date()
    }
}

