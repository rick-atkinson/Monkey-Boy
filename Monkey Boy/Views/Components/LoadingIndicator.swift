//
//  LoadingIndicator.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI
import Combine

struct LoadingIndicator: View {
    @State private var rotation: Double = 0
    @State private var messageIndex = 0

    private let messages = [
        "Finding the perfect banana...",
        "Growing some fur...",
        "Teaching monkey manners...",
        "Swinging through the code...",
        "Adding monkey business...",
        "Channeling primate energy...",
        "Consulting with the jungle...",
        "Monkeying around..."
    ]

    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(Color.jungleGreen.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)

                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(Color.bananaYellow, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotation))

                Text("🐵")
                    .font(.system(size: 36))
            }

            Text(messages[messageIndex])
                .font(.monkeyHeadline())
                .foregroundStyle(Color.jungleGreen)
                .multilineTextAlignment(.center)
                .animation(.easeInOut, value: messageIndex)
        }
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                messageIndex = (messageIndex + 1) % messages.count
            }
        }
    }
}

#Preview {
    LoadingIndicator()
        .padding()
}
