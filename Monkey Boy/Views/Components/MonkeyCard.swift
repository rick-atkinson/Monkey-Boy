//
//  MonkeyCard.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI
import UIKit

struct MonkeyCard: View {
    let monkeyType: MonkeyType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        } label: {
            VStack(spacing: 4) {
                Text(monkeyType.emoji)
                    .font(.system(size: 52))
                Text(monkeyType.displayName)
                    .font(.monkeyCaption())
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.bananaYellow : Color.lightJungle)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.jungleGreen : Color.jungleGreen.opacity(0.3), lineWidth: isSelected ? 3 : 1)
            )
            .shadow(color: .black.opacity(isSelected ? 0.15 : 0.05), radius: isSelected ? 6 : 2, y: isSelected ? 3 : 1)
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview {
    HStack {
        MonkeyCard(monkeyType: .chimpanzee, isSelected: false) {}
        MonkeyCard(monkeyType: .gorilla, isSelected: true) {}
    }
    .padding()
}
