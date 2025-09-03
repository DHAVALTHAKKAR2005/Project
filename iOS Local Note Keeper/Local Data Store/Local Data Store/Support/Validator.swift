//
//  Validator.swift
//  Local Data Store
//
//  Created by Dhaval Thakkar on 9/03/25.
//


import Foundation

struct Validator {
    static func isValidLoginInput(_ input: String) -> Bool {
           return isValidEmail(input) || isValidIndianMobile(input)
    }
    
    static func isValidIndianMobile(_ mobile: String) -> Bool {
        let pattern = "^[6-9]\\d{9}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: mobile)
    }

    static func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Za-z0-9._%+-]{4,25}@[A-Za-z0-9.-]{4,25}\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }

    static func isValidPassword(_ password: String, userName: String) -> Bool {
        guard password.count >= 8, password.count <= 15 else { return false }
        guard let first = password.first, first.isLowercase else { return false }
        if password.lowercased().contains(userName.lowercased()) { return false }

        let uppercaseRegex = ".*[A-Z].*[A-Z].*"
        let digitRegex = ".*[0-9].*[0-9].*"
        let specialCharRegex = ".*[!@#$%^&*(),.?\":{}|<>].*"

        return NSPredicate(format: "SELF MATCHES %@", uppercaseRegex).evaluate(with: password) &&
               NSPredicate(format: "SELF MATCHES %@", digitRegex).evaluate(with: password) &&
               NSPredicate(format: "SELF MATCHES %@", specialCharRegex).evaluate(with: password)
    }

    static func isValidName(_ value: String) -> Bool {
        return value.count >= 4 && value.count <= 25
    }
}


