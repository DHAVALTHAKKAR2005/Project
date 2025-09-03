//
//  Local_Data_StoreApp.swift
//  Local Data Store
//
//  Created by Shailesh Thakkar on 8/27/25.
//

import SwiftUI
import SwiftData

@main
struct Local_Data_StoreApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Note.self])
    }
}


