//
//  PasswordView.swift
//  Unlockly
//
//  Created by swiftandcurious on 5/31/25.
//

import SwiftUI

struct PasswordView: View {
    let remainingAttempts: Int
    let retryAction: () -> Void
    @ObservedObject var authManager: AuthenticationManager

    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Text("Authentication Failed")
                .font(.title.bold())
                .foregroundColor(.red)
            
            Image(systemName: "xmark.seal")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.red)
                .padding()

            Text("Attempts remaining: \(remainingAttempts)")
                .foregroundColor(.secondary)

            if authManager.isAuthenticating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Button(action: retryAction) {
                    Text("Try Again")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let mockManager = AuthenticationManager()
    mockManager.authenticationState = .failure
    mockManager.remainingAttempts = 2 

    return PasswordView(
        remainingAttempts: mockManager.remainingAttempts,
        retryAction: { print("Retry tapped") },
        authManager: mockManager
    )
}
