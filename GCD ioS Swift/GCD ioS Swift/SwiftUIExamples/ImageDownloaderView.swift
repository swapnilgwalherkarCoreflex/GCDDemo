//
//  ImageDownloaderView.swift
//  GCD ioS Swift
//
//  Created by abcd on 23/04/25.
//


import SwiftUI

struct ImageDownloaderView: View {
    @State private var image: Image? = nil
    @State private var isLoading = false
    @State private var errorMessage: String?

    let imageURL = URL(string: "https://picsum.photos/300")! // Random image URL

    var body: some View {
        VStack(spacing: 20) {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(12)
            } else if isLoading {
                ProgressView("Downloading...")
            } else if let errorMessage = errorMessage {
                Text(" \(errorMessage)").foregroundColor(.red)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }

            Button(action: downloadImage) {
                Text("Download Image")
            }
            .disabled(isLoading)
        }
        .padding()
    }

    func downloadImage() {
        isLoading = true
        image = nil
        errorMessage = nil

        DispatchQueue.global(qos: .userInitiated).async {
            print("🌐 Starting download...")

            defer {
                DispatchQueue.main.async {
                    isLoading = false
                }
                print("🧹 Deferred: Resetting loading state")
            }

            do {
                let (data, response) = try URLSession.shared.syncData(from: imageURL)

                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }

                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = Image(uiImage: uiImage)
                    }
                } else {
                    throw URLError(.cannotDecodeContentData)
                }

                print("--->> Downloaded and decoded image")

            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                print(" Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ImageDownloaderView()
}

extension URLSession {
    func syncData(from url: URL) throws -> (Data, URLResponse) {
        var result: Result<(Data, URLResponse), Error>!
        let semaphore = DispatchSemaphore(value: 0)

        dataTask(with: url) { data, response, error in
            if let data = data, let response = response {
                result = .success((data, response))
            } else {
                result = .failure(error ?? URLError(.badURL))
            }
            semaphore.signal()
        }.resume()

        semaphore.wait()
        return try result.get()
    }
}
//Blocking the Main Thread: DispatchSemaphore with semaphore.wait() can cause blocking of the current thread, including the main thread, if used improperly. Since the main thread is responsible for updating the UI, blocking it can cause the app to become unresponsive (the UI will freeze until the semaphore is signaled). This would lead to a poor user experience where the app becomes unresponsive.
//Deadlock Risk: If you call semaphore.wait() on the main thread (or a thread that is waiting for the semaphore to be signaled), you could create a deadlock situation where the program waits indefinitely, causing the app to freeze.
