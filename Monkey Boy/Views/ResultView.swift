//
//  ResultView.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI

struct ResultView: View {
    let transformedImage: UIImage
    let monkeyType: MonkeyType
    let onSave: () async -> Void
    let onStartOver: () -> Void

    @State private var showShareSheet = false
    @State private var isSaving = false
    @State private var showSaveSuccess = false

    var body: some View {
        ZStack {
            Color.jungleGradient
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Monkey Magic Complete!")
                        .font(.monkeyHeadline())
                        .foregroundStyle(Color.jungleGreen)
                    Spacer()
                }
                .padding(.horizontal)

                // Transformed Image
                Image(uiImage: transformedImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                    .padding(.horizontal)

                // Monkey type badge
                HStack {
                    Text(monkeyType.emoji)
                    Text(monkeyType.displayName)
                        .font(.monkeyCaption())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.bananaYellow)
                .clipShape(Capsule())

                Spacer()

                // Action Buttons
                VStack(spacing: 12) {
                    // Save Button
                    Button {
                        Task {
                            isSaving = true
                            await onSave()
                            isSaving = false
                            showSaveSuccess = true

                            // Hide success message after delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSaveSuccess = false
                            }
                        }
                    } label: {
                        HStack(spacing: 12) {
                            if isSaving {
                                ProgressView()
                                    .tint(.black)
                            } else if showSaveSuccess {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                Text("Saved!")
                            } else {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.title2)
                                Text("Save to Photos")
                            }
                        }
                        .font(.monkeyHeadline())
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(showSaveSuccess ? Color.green.opacity(0.3) : Color.bananaYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                    }
                    .buttonStyle(.plain)
                    .disabled(isSaving)

                    // Share Button
                    ShareLink(
                        item: Image(uiImage: transformedImage),
                        preview: SharePreview("My Monkey Transformation", image: Image(uiImage: transformedImage))
                    ) {
                        HStack(spacing: 12) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                            Text("Share")
                                .font(.monkeyHeadline())
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.jungleGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                    }
                    .buttonStyle(.plain)

                    // Start Over Button
                    Button(action: onStartOver) {
                        Text("Transform Another Photo")
                            .font(.monkeyBody())
                            .foregroundStyle(Color.coconutBrown)
                            .underline()
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 32)

                Spacer()
                    .frame(height: 20)
            }
        }
        .animation(.easeInOut, value: showSaveSuccess)
    }
}

#Preview {
    ResultView(
        transformedImage: UIImage(systemName: "person.fill")!,
        monkeyType: .chimpanzee,
        onSave: {},
        onStartOver: {}
    )
}
