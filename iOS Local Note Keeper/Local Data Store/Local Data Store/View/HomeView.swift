//
//  HomeView.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//


import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query private var notes: [Note]
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    } label: {
                        NoteRow(note: note)
                    }
                }
            }
            Button("Logout") {
                isLoggedIn = false
            }
            .navigationTitle("Your Notes")
            .toolbar {
                NavigationLink(destination: AddNoteView()) {
                    Label("Add Note", systemImage: "plus")
                }
            }
        }
    }
}

