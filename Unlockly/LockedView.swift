//
//  LockedView.swift
//  Unlockly
//
//  Created by swiftandcurious on 5/31/25.
//

import SwiftUI

struct LockedView: View {
    @ObservedObject var authManager: AuthenticationManager

    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            Image(systemName: "lock.shield")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.red)

            Text("Too Many Attempts")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            if let remaining = authManager.remainingLockTime {
                Text("Try again in \(formatTime(seconds: remaining))")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

            Text("Access is temporarily locked for security reasons.")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(.gray)

            Spacer()
            
            Spacer()
        }
        .padding()
    }

    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

#Preview {
    let mockManager = AuthenticationManager()
    mockManager.authenticationState = .locked
    mockManager.remainingLockTime = 90

    return LockedView(authManager: mockManager)
}
