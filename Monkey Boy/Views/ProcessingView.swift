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
            Color.jungleGradient
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                LoadingIndicator()

                Text("Transforming into a \(monkeyType.displayName)...")
                    .font(.monkeyBody())
                    .foregroundStyle(Color.coconutBrown)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ProcessingView(monkeyType: .chimpanzee)
}
