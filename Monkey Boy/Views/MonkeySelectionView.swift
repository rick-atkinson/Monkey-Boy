//
//  MonkeySelectionView.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI

struct MonkeySelectionView: View {
    let originalImage: UIImage
    @Binding var selectedMonkey: MonkeyType?
    let onTransform: () -> Void
    let onBack: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            // Simple playful green background
            Color.lightJungle
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Header with back button and title
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.title3.weight(.semibold))
                            Text("Back")
                                .font(.monkeyBody())
                        }
                        .foregroundStyle(Color.jungleGreen)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                // Original Image Preview (smaller)
                Image(uiImage: originalImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
                    .padding(.horizontal, 40)

                // Title
                VStack(spacing: 6) {
                    Text("Choose your Monkey")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.jungleGreen)
                    Text("Tap to select, then transform")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.coconutBrown)
                }

                // Monkey Grid
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(MonkeyType.allCases) { monkey in
                            MonkeyCard(
                                monkeyType: monkey,
                                isSelected: selectedMonkey == monkey
                            ) {
                                selectedMonkey = monkey
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                }

                // Transform Button
                if selectedMonkey != nil {
                    PrimaryButton("Transform into \(selectedMonkey!.displayName)!", icon: "wand.and.stars") {
                        onTransform()
                    }
                    .padding(.horizontal, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()
                    .frame(height: 16)
            }
        }
        .animation(.spring(response: 0.3), value: selectedMonkey)
    }
}

#Preview {
    MonkeySelectionView(
        originalImage: UIImage(systemName: "person.fill")!,
        selectedMonkey: .constant(.chimpanzee),
        onTransform: {},
        onBack: {}
    )
}
