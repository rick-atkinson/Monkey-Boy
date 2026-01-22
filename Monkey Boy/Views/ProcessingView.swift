//
//  ProcessingView.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI

struct ProcessingView: View {
    let monkeyType: MonkeyType

    var body: some View {
        ZStack {
            // Dark playful green background
            Color.jungleGreen
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                LoadingIndicator()

                Text("Transforming into a \(monkeyType.displayName)...")
                    .font(.monkeyBody())
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ProcessingView(monkeyType: .chimpanzee)
}
