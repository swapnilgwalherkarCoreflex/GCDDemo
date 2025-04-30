//
//  DeferAndGCDExampleView.swift
//  GCD ioS Swift
//
//  Created by abcd on 23/04/25.
//


import SwiftUI
//We’ll simulate downloading an image using URLSession inside a GCD block, and we'll:
//
//Show a placeholder image while downloading
//Use defer to always reset loading state
//Handle errors gracefully
//Update the UI with the image

//
//defer is built using:
//Stack unwinding concept: When a scope is exited, Swift ensures defer blocks are called in reverse order (LIFO – Last In, First Out).
//This is similar to finally in Java or try-with-resources, but more flexible.
struct DeferAndGCDExampleView: View {
    @State private var message: String = "Tap to start task"
    @State private var isWorking = false

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.headline)
                .padding()
//function used as Completion block
            Button(action: runBackgroundTask) {
                Text(isWorking ? "Working..." : "Start Background Task")
            }
            .disabled(isWorking)
        }
        .padding()
    }

    func runBackgroundTask() {
        isWorking = true
        message = "Task started..."

        DispatchQueue.global(qos: .userInitiated).async {
            print(" Background task started")

            defer {
                print("----->Defer cleanup: Task done.")
                DispatchQueue.main.async {
                    self.message = "Task completed"
                    self.isWorking = false
                }
            }

            // Simulate a task like downloading
            sleep(2)

            print("Work completed inside GCD block")
        }
    }
}

#Preview {
    DeferAndGCDExampleView()
}


//Use defer to clean up even during errors
//Separate background work from UI logic
//Handle async behavior with GCD while respecting the main thread
//Wrap URLSession into a sync-style helper when demoing
