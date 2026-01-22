//
//  MonkeyIconGenerator.swift
//  Monkey Boy
//
//  Temporary view to generate monkey icons using AI
//

import SwiftUI
import FirebaseAI

struct MonkeyIconGenerator: View {
    @State private var currentMonkey: MonkeyType?
    @State private var generatedImage: UIImage?
    @State private var isGenerating = false
    @State private var statusMessage = "Tap a monkey to generate its icon"
    @State private var generatedImages: [MonkeyType: UIImage] = [:]

    private let model: GenerativeModel

    init() {
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        self.model = ai.generativeModel(
            modelName: "gemini-2.0-flash-exp-image-generation",
            generationConfig: GenerationConfig(responseModalities: [.text, .image])
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text(statusMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding()

                    if let image = generatedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.jungleGreen, lineWidth: 3))
                            .shadow(radius: 5)

                        Button("Save to Photos") {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            statusMessage = "Saved \(currentMonkey?.displayName ?? "image") to Photos!"
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    if isGenerating {
                        ProgressView("Generating...")
                            .padding()
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(MonkeyType.allCases) { monkey in
                            VStack {
                                if let img = generatedImages[monkey] {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.green, lineWidth: 2))
                                } else {
                                    Text(monkey.emoji)
                                        .font(.system(size: 50))
                                }

                                Text(monkey.displayName)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                            .padding(8)
                            .background(currentMonkey == monkey ? Color.bananaYellow : Color.lightJungle)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onTapGesture {
                                generateIcon(for: monkey)
                            }
                        }
                    }
                    .padding()

                    Button("Generate All") {
                        generateAllIcons()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isGenerating)

                    Button("Save All to Photos") {
                        for (_, image) in generatedImages {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                        statusMessage = "Saved \(generatedImages.count) images to Photos!"
                    }
                    .buttonStyle(.bordered)
                    .disabled(generatedImages.isEmpty)

                    Text("After saving, export images from Photos to:\nAssets.xcassets/monkey_[name].imageset/")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Icon Generator")
        }
    }

    private func generateIcon(for monkey: MonkeyType) {
        guard !isGenerating else { return }

        currentMonkey = monkey
        isGenerating = true
        statusMessage = "Generating \(monkey.displayName)..."

        Task {
            do {
                let prompt = """
                Generate a cute friendly cartoon \(monkey.rawValue) face portrait.
                Style: Simple clean circular icon design, digital art illustration.
                Features: Expressive friendly eyes, gentle warm expression, soft lighting.
                Background: Pure white background.
                The image should be suitable as an app icon - clean, recognizable, and charming.
                Only show the face/head, no body. Make it look like a professional app icon.
                """

                let response = try await model.generateContent(prompt)

                if let inlineDataPart = response.inlineDataParts.first,
                   let image = UIImage(data: inlineDataPart.data) {
                    await MainActor.run {
                        generatedImage = image
                        generatedImages[monkey] = image
                        statusMessage = "Generated \(monkey.displayName)!"
                        isGenerating = false
                    }
                } else {
                    await MainActor.run {
                        statusMessage = "No image returned for \(monkey.displayName)"
                        isGenerating = false
                    }
                }
            } catch {
                await MainActor.run {
                    statusMessage = "Error: \(error.localizedDescription)"
                    isGenerating = false
                }
            }
        }
    }

    private func generateAllIcons() {
        Task {
            for monkey in MonkeyType.allCases {
                await MainActor.run {
                    currentMonkey = monkey
                    isGenerating = true
                    statusMessage = "Generating \(monkey.displayName)..."
                }

                do {
                    let prompt = """
                    Generate a cute friendly cartoon \(monkey.rawValue) face portrait.
                    Style: Simple clean circular icon design, digital art illustration.
                    Features: Expressive friendly eyes, gentle warm expression, soft lighting.
                    Background: Pure white background.
                    The image should be suitable as an app icon - clean, recognizable, and charming.
                    Only show the face/head, no body. Make it look like a professional app icon.
                    """

                    let response = try await model.generateContent(prompt)

                    if let inlineDataPart = response.inlineDataParts.first,
                       let image = UIImage(data: inlineDataPart.data) {
                        await MainActor.run {
                            generatedImage = image
                            generatedImages[monkey] = image
                        }
                    }
                } catch {
                    await MainActor.run {
                        statusMessage = "Error generating \(monkey.displayName): \(error.localizedDescription)"
                    }
                }

                // Delay between generations to avoid rate limiting
                try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
            }

            await MainActor.run {
                isGenerating = false
                statusMessage = "Done! Generated \(generatedImages.count) icons."
            }
        }
    }
}

#Preview {
    MonkeyIconGenerator()
}
