//
//  ImageProcessing.swift
//  GCD ioS Swift
//
//  Created by abcd on 23/04/25.
//

import Foundation

class ImageProcessing {
    func imageProcesss() {
        
        // Step 1: Create a concurrent queue that is initially inactive
        let imageProcessingQueue = DispatchQueue(
            label: "com.example.imageProcessing",
            attributes: [.concurrent, .initiallyInactive]
        )

        // Step 2: Add multiple tasks to simulate downloading or processing images
        for i in 1...3 {
            imageProcessingQueue.async {
                print("🔄 Processing Image \(i) - Start")
                Thread.sleep(forTimeInterval: Double(i)) // simulate time
                print("✅ Image \(i) processed")
            }
        }

        // Step 3: Delay activation to simulate a user-triggered start (e.g., button tap)
        print("⏸ All image tasks are queued but not started.")
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            print("▶️ Activating queue...")
            imageProcessingQueue.activate()
        }

        // Keep the playground running
        dispatchMain()

    }
    
}
