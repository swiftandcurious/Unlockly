//
//  UnlockedView.swift
//  Unlockly
//
//  Created by swiftandcurious on 5/31/25.
//

import SwiftUI

struct UnlockedView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome!")
                .font(.title.bold())
            
            Text("You successfully unlocked the app.")
                .padding()
            
            Image(systemName: "checkmark.seal")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .padding()
            
            Spacer()
            Spacer()
        }
        
    }
}

#Preview {
    UnlockedView()
}
