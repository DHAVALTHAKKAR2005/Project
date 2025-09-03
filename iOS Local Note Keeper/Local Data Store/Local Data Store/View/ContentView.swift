//
//  ContentView.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                HomeView()
            } else {
                LoginView(isLoggedIn: isLoggedIn)
            }
        }
    }
}
#Preview {
    ContentView()
}

