//
//  SessionManger.swift
//  Islamia College Portfoio
//
//  Created by Development on 18/06/2025.
//

import Foundation
import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func listen() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
        }
    }
}
