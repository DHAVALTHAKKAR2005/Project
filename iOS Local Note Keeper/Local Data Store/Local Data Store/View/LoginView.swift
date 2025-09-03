//
//  LoginView.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//



import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) var context
    @Query var users: [User]
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    @State private var input = "" // email or mobile
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                TextField("Email or Mobile", text: $input)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
            }
            Button(action: handleLogin, label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .foregroundStyle(Color.white)
                    .background(.cyan)
                    .clipShape(.capsule)
                    .multilineTextAlignment(.center)
            })
            .padding()
            NavigationLink("Don't have an account? Sign up", destination: SignupView())
        }
       
        .padding()
        .navigationTitle("Login")
    
    }
       

    func handleLogin() {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let enteredPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)


        guard Validator.isValidLoginInput(trimmedInput) else {
            errorMessage = "Invalid email or mobile number"
            return
        }

        guard !password.isEmpty else {
            errorMessage = "Enter password"
            return
        }

        for user in users {
            print("DB User: \(user.email.lowercased()) / \(user.mobile), key: \(user.passwordKey)")
        }

        guard let user = users.first(where: { $0.email == trimmedInput || $0.mobile == trimmedInput }) else {
            errorMessage = "User not found"
            return
        }

        print("Login Input: \(trimmedInput)")
        print("Entered Password: \(enteredPassword)")

        
        guard let savedPassword = KeychainHelper.getPassword(forKey: user.passwordKey.lowercased()),
        savedPassword == enteredPassword else {
            print("No password found in Keychain for: \(user.passwordKey.lowercased())")
            errorMessage = "Username or password is wrong"
            return
        }
 
        print("Fetched Keychain Password: \(savedPassword)")
        errorMessage = ""
        isLoggedIn = true
    }
}

