//
//  StartView.swift
//  Unlockly
//
//  Created by swiftandcurious on 5/31/25.
//

import SwiftUI

struct AuthenticationView: View {
    
    @ObservedObject var authManager: AuthenticationManager

    var body: some View {
        VStack {
            Button {
                authManager.authenticate()
            } label: {
                VStack {
                    Image(systemName: "faceid")
                        .resizable()
                        .frame(width: 80, height: 80)
                    Text("Tap")
                }
            }
        }
        .padding()
    }
}

#Preview {
    let mockManager = AuthenticationManager()
    mockManager.authenticationState = .locked

    return AuthenticationView(authManager: mockManager)
}
