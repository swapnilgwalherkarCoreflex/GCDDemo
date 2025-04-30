//
//  DispatchGlobalQueues.swift
//  GCD ioS Swift
//
//  Created by abcd on 22/04/25.
//

import Foundation
import UIKit
//there are several global concurrent queues available in the system, and this is a fundamental concept in Grand Central Dispatch (GCD) in iOS/macOS development.
//
class DispatchGlobalQueues {
    ///Only these 5-6 global concurrent queues are officially exposed by Apple via DispatchQueue.global(qos:).

    func allqueuesPrinted() {
        let backgroundQueue = DispatchQueue.global(qos: .background)
        let utilityQueue = DispatchQueue.global(qos: .utility)
        let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
        let userInteractive = DispatchQueue.global(qos: .userInteractive)
        let defaultQueue = DispatchQueue.global(qos: .default)


        //Use Custom Named Queues If You Need to Track
        let myQueue = DispatchQueue(label: "com.myapp.myqueue", qos: .utility, attributes: .concurrent)

    }
    
    
    
    
}

//
//Examples of internal queues (not exposed as public global queues):
//
//com.apple.root.default-qos
//com.apple.NSURLSession-work
//com.apple.main-thread (serial, not concurrent)
//com.apple.audio (CoreAudio framework)
//com.apple.UIKit.BackgroundTask (used by UIKit for background tasks)
//These show up in Instruments, Xcode debug navigator, or crash logs, but you can’t dispatch tasks directly to them.
//This is one of the root global concurrent queues under the hood of DispatchQueue.global(qos: .default).
//You don’t use it directly, but when you do this:

//
//com.apple.NSURLSession-work
//Used internally by URLSession to handle background network tasks, downloads/uploads, response parsing.
//You don’t dispatch to it directly, but you trigger it by using:


func allqueuesPrinted() {
    
    //com.apple.root.default-qos
    DispatchQueue.global(qos: .userInitiated).async {
        // work
        
    }
    
    //com.apple.NSURLSession-work
    let task = URLSession.shared.dataTask(with: URL(string:"")!) { data, response, error in
        // This closure may run on this internal queue.
    }
    task.resume()
    
    
//    com.apple.UIKit.BackgroundTask
//    UIKit uses this internally when you call:
    let taskID = UIApplication.shared.beginBackgroundTask {
        // Cleanup if task time expires
    }
    
    
    
    
    
}

// Under the hood, you're using this root queue.
//
// Useful for: Background work that doesn’t require user interaction, but is still reasonably important.


