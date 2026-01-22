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
            VStack(spacing: 6) {
                // Try to load custom image, fall back to styled emoji icon
                Group {
                    if let _ = UIImage(named: monkeyType.imageName) {
                        Image(monkeyType.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                    } else {
                        // Styled emoji icon with gradient background
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            monkeyType.iconBackgroundColor,
                                            monkeyType.iconAccentColor.opacity(0.8)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 56, height: 56)

                            Circle()
                                .strokeBorder(
                                    monkeyType.iconAccentColor.opacity(0.5),
                                    lineWidth: 2
                                )
                                .frame(width: 56, height: 56)

                            Text(monkeyType.emoji)
                                .font(.system(size: 32))
                                .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
                        }
                    }
                }
                .frame(height: 56)

                VStack(spacing: 3) {
                    Text(monkeyType.displayName)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(isSelected ? Color.jungleGreen : Color.coconutBrown)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text(monkeyType.shortDescription)
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.coconutBrown.opacity(0.8))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.bananaYellow : Color.lightJungle)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.jungleGreen : Color.jungleGreen.opacity(0.3), lineWidth: isSelected ? 3 : 1)
            )
            .shadow(color: .black.opacity(isSelected ? 0.2 : 0.05), radius: isSelected ? 8 : 2, y: isSelected ? 4 : 1)
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.08 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        MonkeyCard(monkeyType: .chimpanzee, isSelected: false) {}
        MonkeyCard(monkeyType: .gorilla, isSelected: true) {}
        MonkeyCard(monkeyType: .orangutan, isSelected: false) {}
    }
    .padding()
}
