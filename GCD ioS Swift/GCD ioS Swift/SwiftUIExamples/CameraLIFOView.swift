import SwiftUI

struct CameraLIFOViewWithNumbers: View {
    @State private var photoStack: [UIImage] = []
    @State private var currentImage: UIImage?
    @State private var photoCounter: Int = 0

    // Create a serial queue for managing the photo stack
    private let cameraQueue = DispatchQueue(label: "com.cameraApp.photoQueue")

    var body: some View {
        VStack(spacing: 20) {
            if let currentImage = currentImage {
                Image(uiImage: currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
            } else {
                Text("No photos yet!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }

            Button("Take Photo") {
                // Simulate taking a new numbered photo
                takePhoto()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("Show Last Photo") {
                // Show the last photo (LIFO) asynchronously
                showLastPhoto()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    // Function to simulate taking a new photo and adding it to the stack (LIFO)
    func takePhoto() {
        cameraQueue.async {
            // Increment the photo counter for unique photo names
            let photoName = "Photo \(photoCounter + 1)"
            self.photoCounter += 1

            // Create a simulated photo using the photo name (replace with real camera logic)
            let newPhoto = generatePhoto(named: photoName)
            
            // Add new photo to the stack (LIFO order)
            self.photoStack.append(newPhoto)
            
            // Update the current photo on the main thread
            DispatchQueue.main.async {
                self.currentImage = newPhoto
            }
        }
    }

    // Function to generate a dummy photo image with a label (simulating photo content)
    func generatePhoto(named name: String) -> UIImage {
        let size = CGSize(width: 250, height: 250)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.lightGray.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
        let textSize = name.size(withAttributes: attributes)
        let rect = CGRect(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2, width: textSize.width, height: textSize.height)
        name.draw(in: rect, withAttributes: attributes)
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return generatedImage
    }

    // Function to show the last photo (pop the most recent one, LIFO)
    func showLastPhoto() {
        cameraQueue.async {
            if !self.photoStack.isEmpty {
                // Pop the last photo from the stack (LIFO)
                let lastPhoto = self.photoStack.removeLast()
                
                // Update the current photo on the main thread
                DispatchQueue.main.async {
                    self.currentImage = lastPhoto
                }
            } else {
                // If no photos are available, clear the display
                DispatchQueue.main.async {
                    self.currentImage = nil
                }
            }
        }
    }
}

#Preview {
    CameraLIFOViewWithNumbers()
}
