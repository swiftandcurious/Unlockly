//
//  AuthenticationManager.swift
//  Unlockly
//
//  Created by swiftandcurious on 5/31/25.
//

import SwiftUI
import LocalAuthentication


@MainActor
class AuthenticationManager: ObservableObject {
    @Published var authenticationState: AuthenticationState = .start
    @Published var remainingAttempts: Int = 3
    @Published var isAuthenticating = false
    @Published var remainingLockTime: Int? // In seconds, for countdown

    enum AuthenticationState {
        case start, success, failure, locked
    }

    private let lockoutDuration: TimeInterval = 5 * 60 // 5 minutes
    private let lockoutKey = "lockoutTimestamp"

    init() {
        checkLockoutStatus()
    }

    func authenticate() {
        Task {
            isAuthenticating = true
            let result = await performAuthentication()
            isAuthenticating = false

            switch result {
            case .success:
                authenticationState = .success
            case .failure:
                remainingAttempts -= 1
                if remainingAttempts <= 0 {
                    startLockout()
                } else {
                    authenticationState = .failure
                }
            }
        }
    }

    private func performAuthentication() async -> Result<Void, Error> {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return .failure(error ?? NSError(domain: "Auth", code: 0))
        }

        let reason = "Please authenticate to unlock the app"

        return await withCheckedContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
                if success {
                    continuation.resume(returning: .success(()))
                } else {
                    continuation.resume(returning: .failure(authError ?? NSError(domain: "Auth", code: 1)))
                }
            }
        }
    }

    private func startLockout() {
        let lockoutTimestamp = Date()
        UserDefaults.standard.set(lockoutTimestamp, forKey: lockoutKey)
        authenticationState = .locked
        updateCountdown()
    }

    func checkLockoutStatus() {
        guard let lockoutTimestamp = UserDefaults.standard.object(forKey: lockoutKey) as? Date else {
            return
        }

        let timePassed = Date().timeIntervalSince(lockoutTimestamp)
        if timePassed < lockoutDuration {
            authenticationState = .locked
            updateCountdown()
        } else {
            resetLockout()
        }
    }

    func updateCountdown() {
        Task {
            while let lockoutTimestamp = UserDefaults.standard.object(forKey: lockoutKey) as? Date {
                let timeRemaining = Int(lockoutDuration - Date().timeIntervalSince(lockoutTimestamp))
                if timeRemaining <= 0 {
                    resetLockout()
                    break
                } else {
                    remainingLockTime = timeRemaining
                }
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    private func resetLockout() {
        UserDefaults.standard.removeObject(forKey: lockoutKey)
        remainingAttempts = 3
        remainingLockTime = nil
        authenticationState = .start
    }
}
