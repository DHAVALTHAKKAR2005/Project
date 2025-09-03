//
//  User.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//


import Foundation
import SwiftData

@Model
class User {
    var name: String
    var email: String
    var mobile: String
    var passwordKey: String  // Used as Keychain key

    init(name: String, email: String, mobile: String, passwordKey: String) {
        self.name = name
        self.email = email
        self.mobile = mobile
        self.passwordKey = passwordKey
    }
}

