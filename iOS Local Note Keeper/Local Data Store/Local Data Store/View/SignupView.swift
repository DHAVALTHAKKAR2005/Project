//
//  SignupView.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//


import SwiftUI
import SwiftData

struct SignupView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var mobile = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        Form {
            Section(header: Text("Register")) {
                TextField("Name", text: $name)
                TextField("Mobile", text: $mobile)
                    .keyboardType(.numberPad)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: handleSignup, label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .foregroundStyle(Color.white)
                    .background(.cyan)
                    .clipShape(.capsule)
                    .multilineTextAlignment(.center)
            })
            
            
        }
        .navigationTitle("Sign Up")
    }

    func handleSignup() {
        guard !name.isEmpty else {
            errorMessage = "Name is required"
            return
        }

        guard Validator.isValidEmail(email) else {
            errorMessage = "Invalid email"
            return
        }

        guard Validator.isValidIndianMobile(mobile) else {
            errorMessage = "Invalid mobile"
            return
        }

        guard !password.isEmpty else {
            errorMessage = "Password required"
            return
        }
        email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let user = User(name: name, email: email, mobile: mobile.trimmingCharacters(in: .whitespacesAndNewlines), passwordKey: email)
        context.insert(user)
        print("Signup button tapped")
        print("User created: \(user.name), \(user.email)")
        
        let key = email.lowercased()
        KeychainHelper.savePassword(password, forKey: key)
        
        print("Password saved to Keychain for key: \(user.email)")
        do {
            try context.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save user"
        }
    }
}

