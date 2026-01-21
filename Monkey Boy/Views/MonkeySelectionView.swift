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
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color.jungleGradient
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header with back button
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(Color.jungleGreen)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                // Original Image Preview
                Image(uiImage: originalImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 4)
                    .padding(.horizontal)

                // Title
                Text("Choose your monkey!")
                    .font(.monkeyHeadline())
                    .foregroundStyle(Color.jungleGreen)

                // Monkey Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(MonkeyType.allCases) { monkey in
                            MonkeyCard(
                                monkeyType: monkey,
                                isSelected: selectedMonkey == monkey
                            ) {
                                selectedMonkey = monkey
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Transform Button
                if selectedMonkey != nil {
                    PrimaryButton("Transform!", icon: "wand.and.stars") {
                        onTransform()
                    }
                    .padding(.horizontal, 32)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()
                    .frame(height: 20)
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
