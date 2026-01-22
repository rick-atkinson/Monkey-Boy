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
            // Artistic monkey background
            GeometryReader { geometry in
                Image("mb")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(1.8)
                    .offset(y: geometry.size.height * 0.15)
                    .blur(radius: 2)
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.jungleGreen.opacity(0.7),
                                Color.jungleGreen.opacity(0.4),
                                Color.black.opacity(0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
            }

            VStack(spacing: 32) {
                Spacer()

                // Title Section
                VStack(spacing: 12) {
                    // Fun artistic title with banana
                    HStack(spacing: 0) {
                        Text("M")
                            .foregroundStyle(Color.bananaYellow)
                        Text("onkey")
                            .foregroundStyle(.white)
                    }
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .shadow(color: .black.opacity(0.4), radius: 6, y: 3)

                    HStack(spacing: 8) {
                        Text("🍌")
                            .font(.system(size: 32))
                            .rotationEffect(.degrees(-15))
                        Text("Boy")
                            .font(.system(size: 52, weight: .black, design: .rounded))
                            .foregroundStyle(Color.bananaYellow)
                            .shadow(color: .black.opacity(0.4), radius: 6, y: 3)
                        Text("🍌")
                            .font(.system(size: 32))
                            .rotationEffect(.degrees(15))
                    }
                    .offset(y: -8)

                    Text("Transform anyone into a monkey!")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.95))
                        .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                        .padding(.top, 4)
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
                        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
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
