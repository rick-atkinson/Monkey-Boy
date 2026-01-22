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
    let detectedFaces: [DetectedFace]
    let isDetectingFaces: Bool
    let onToggleFace: (UUID) -> Void
    let onTransform: () -> Void
    let onBack: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    private var selectedFaceCount: Int {
        detectedFaces.filter { $0.isSelected }.count
    }

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

                // Original Image Preview with Face Overlay
                ZStack {
                    Image(uiImage: originalImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.clear)
                        )

                    if !detectedFaces.isEmpty {
                        FaceOverlayView(
                            faces: detectedFaces,
                            imageSize: CGSize(width: originalImage.size.width, height: originalImage.size.height),
                            onToggle: onToggleFace
                        )
                        .frame(maxHeight: 180)
                        .aspectRatio(originalImage.size.width / originalImage.size.height, contentMode: .fit)
                    }

                    if isDetectingFaces {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.3))
                        VStack(spacing: 8) {
                            ProgressView()
                                .tint(.white)
                            Text("Detecting faces...")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .frame(maxHeight: 180)
                .shadow(color: .black.opacity(0.2), radius: 6, y: 3)
                .padding(.horizontal, 40)

                // Face detection status
                if !isDetectingFaces {
                    if detectedFaces.isEmpty {
                        Text("No faces detected - the whole image will be transformed")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.coconutBrown.opacity(0.8))
                    } else {
                        Text("Tap faces to include/exclude from transformation (\(selectedFaceCount)/\(detectedFaces.count) selected)")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.coconutBrown.opacity(0.8))
                    }
                }

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
        detectedFaces: [
            DetectedFace(boundingBox: CGRect(x: 0.3, y: 0.3, width: 0.4, height: 0.4), isSelected: true)
        ],
        isDetectingFaces: false,
        onToggleFace: { _ in },
        onTransform: {},
        onBack: {}
    )
}
