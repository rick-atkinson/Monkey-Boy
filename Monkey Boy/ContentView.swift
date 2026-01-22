//
//  ContentView.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = TransformationViewModel()
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var showIconGenerator = false

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                HomeView(selectedImage: $selectedImage, showCamera: $showCamera)

            case .selectingMonkey:
                if let image = viewModel.originalImage {
                    MonkeySelectionView(
                        originalImage: image,
                        selectedMonkey: $viewModel.selectedMonkey,
                        detectedFaces: viewModel.detectedFaces,
                        isDetectingFaces: viewModel.isDetectingFaces,
                        onToggleFace: { id in
                            viewModel.toggleFaceSelection(id: id)
                        },
                        onTransform: {
                            Task {
                                await viewModel.transform()
                            }
                        },
                        onBack: {
                            viewModel.reset()
                        }
                    )
                }

            case .transforming:
                if let monkey = viewModel.selectedMonkey {
                    ProcessingView(monkeyType: monkey)
                }

            case .completed:
                if let transformed = viewModel.transformedImage,
                   let monkey = viewModel.selectedMonkey {
                    ResultView(
                        transformedImage: transformed,
                        monkeyType: monkey,
                        onSave: {
                            await viewModel.saveToPhotos()
                        },
                        onStartOver: {
                            viewModel.reset()
                        }
                    )
                }

            case .error:
                ErrorView(
                    message: viewModel.errorMessage ?? "Something went wrong",
                    onRetry: {
                        viewModel.goBackToSelection()
                    },
                    onStartOver: {
                        viewModel.reset()
                    }
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.state)
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker(selectedImage: $selectedImage)
                .ignoresSafeArea()
        }
        .onChange(of: selectedImage) { _, newImage in
            if let image = newImage {
                viewModel.selectImage(image)
                selectedImage = nil
            }
        }
        .sheet(isPresented: $showIconGenerator) {
            MonkeyIconGenerator()
        }
        // Hidden developer gesture: shake device to open icon generator
        .onShake {
            showIconGenerator = true
        }
    }
}

// Shake gesture detection
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(ShakeDetector(onShake: action))
    }
}

struct ShakeDetector: ViewModifier {
    let onShake: () -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                onShake()
            }
    }
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// Simple error view
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    let onStartOver: () -> Void

    var body: some View {
        ZStack {
            Color.jungleGradient
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("🙈")
                    .font(.system(size: 80))

                Text("Oops!")
                    .font(.monkeyTitle())
                    .foregroundStyle(Color.jungleGreen)

                Text(message)
                    .font(.monkeyBody())
                    .foregroundStyle(Color.coconutBrown)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                VStack(spacing: 12) {
                    PrimaryButton("Try Again", icon: "arrow.clockwise") {
                        onRetry()
                    }

                    Button(action: onStartOver) {
                        Text("Start Over")
                            .font(.monkeyBody())
                            .foregroundStyle(Color.coconutBrown)
                            .underline()
                    }
                }
                .padding(.horizontal, 32)

                Spacer()
                    .frame(height: 60)
            }
        }
    }
}

#Preview {
    ContentView()
}
