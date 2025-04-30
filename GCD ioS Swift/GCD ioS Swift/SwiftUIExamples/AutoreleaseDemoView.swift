    //
    //  AutoreleaseDemoView.swift
    //  GCD ioS Swift
    //
    //  Created by abcd on 23/04/25.
    //

//The autorelease pool makes sure that any autoreleased objects created during the startup process are disposed of correctly. Without this pool, those objects would not be released until much later (or not at all), which could lead to increased memory usage or leaks.

//The @autoreleasepool ensures that temporary objects are cleaned up efficiently when the main function exits.
//Swift automatically generates the equivalent of a main.swift file for you, and that includes something like this under the hood:

//autoreleasepool {
//    UIApplicationMain(
//        CommandLine.argc,
//        CommandLine.unsafeArgv,
//        nil,
//        NSStringFromClass(AppDelegate.self)
//    )
//}
//
//Why Autorelease Pool Is Needed in @main
//Even though Swift uses ARC and doesn’t depend on autoreleasing as much, many underlying Apple frameworks still do — especially UIKit, AppKit, Foundation, etc.
//For instance, when you create objects from Foundation (like NSDate, NSURL, etc.), they can be autoreleased when bridging from Objective-C.
//The RunLoop for apps typically creates and drains an autorelease pool for each iteration — this prevents memory buildup during long-running operations like event handling or UI updates.

    import SwiftUI

    struct AutoreleaseDemoView: View {
        @State private var loadWithPool = false
        @State private var logMessage = "Tap a button to begin..."

        var body: some View {
            VStack(spacing: 20) {
                Text("Autorelease Pool Demo")
                    .font(.title)
                    .bold()

                Button("Load Images WITHOUT Autorelease Pool") {
                    logMessage = "Loading images without pool..."
                    DispatchQueue.global(qos: .userInitiated).async {
                        loadImages(usePool: false)
                    }
                }

                Button("Load Images WITH Autorelease Pool") {
                    logMessage = "Loading images with pool..."
                    DispatchQueue.global(qos: .userInitiated).async {
                        loadImages(usePool: true)
                    }
                }

                Text(logMessage)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
        }

        func loadImages(usePool: Bool) {
            let start = Date()
            for i in 1...1000 {
                if usePool {
                    autoreleasepool {
                        _ = loadDummyImage(index: i)
                    }
                } else {
                    _ = loadDummyImage(index: i)
                }
            }

            let end = Date()
            let duration = end.timeIntervalSince(start)
            DispatchQueue.main.async {
                logMessage = "Loaded 1000 images \(usePool ? "WITH" : "WITHOUT") autorelease pool in \(String(format: "%.2f", duration))s"
            }
        }

        func loadDummyImage(index: Int) -> UIImage {
            // Simulates loading an image; for real test, replace with actual image
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 500, height: 500))
            return renderer.image { ctx in
                UIColor(hue: CGFloat(index % 360) / 360.0, saturation: 1, brightness: 1, alpha: 1).setFill()
                ctx.fill(CGRect(x: 0, y: 0, width: 500, height: 500))
            }
        }
    }

    #Preview {
        AutoreleaseDemoView()
    }
