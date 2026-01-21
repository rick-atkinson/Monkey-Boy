//
//  HomeView.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @Binding var selectedImage: UIImage?
    @Binding var showCamera: Bool
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            Color.jungleGradient
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Title Section
                VStack(spacing: 12) {
                    Text("🐵")
                        .font(.system(size: 80))

                    Text("Monkey Boy")
                        .font(.monkeyTitle())
                        .foregroundStyle(Color.jungleGreen)

                    Text("Transform anyone into a monkey!")
                        .font(.monkeyBody())
                        .foregroundStyle(Color.coconutBrown)
                }

                Spacer()

                // Buttons
                VStack(spacing: 16) {
                    PrimaryButton("Take Photo", icon: "camera.fill") {
                        showCamera = true
                    }

                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        HStack(spacing: 12) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.title2)
                            Text("Choose Photo")
                                .font(.monkeyHeadline())
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.jungleGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                    }
                }
                .padding(.horizontal, 32)

                Spacer()
                    .frame(height: 60)
            }
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
}

#Preview {
    HomeView(selectedImage: .constant(nil), showCamera: .constant(false))
}
