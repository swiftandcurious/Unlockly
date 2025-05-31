//
//  ContentView.swift
//  Unlockly
//
//  Created by swiftandcurious on 5/31/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()

    var body: some View {
        VStack {
            
            Spacer()
            
            switch authManager.authenticationState {
            case .start:
                AuthenticationView(authManager: authManager)
            case .success:
                UnlockedView()
            case .failure:
                PasswordView(
                    remainingAttempts: authManager.remainingAttempts,
                    retryAction: authManager.authenticate,
                    authManager: authManager
                )
            case .locked:
                LockedView(authManager: authManager)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
