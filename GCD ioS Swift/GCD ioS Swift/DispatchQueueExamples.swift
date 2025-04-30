//
//  DispatchQueueExamples.swift
//  GDC-Demo
//
//  Created by abcd on 18/04/25.
//  Copyright © 2025 TaiHsinLee. All rights reserved.
//

import Foundation
//
// Use GCD for quick background tasks.
//Use OperationQueue for complex task management.
class DispatchQueueExamples {
    
    func basicExample() {
        print(" Start")
        
        DispatchQueue.global().async {
            print(" Task running in background thread")
        }
        
        print("End")
    }
    
    func updateUIFromBackground() {
        DispatchQueue.global().async {
            print("Doing background work...")
            
            DispatchQueue.main.async {
                print("Updating UI on main thread")
            }
        }
    }
    
    
    func namedQueues() {
        let customQueue = DispatchQueue(label: "com.swapnil.customQueue")
        
        customQueue.async {
            print(" Custom serial queue task")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            print(" High priority task")
        }
        
        DispatchQueue.global(qos: .background).async {
            print("🛌 Low priority background task")
        }
    }
    
    func syncVsAsync() {
        let queue = DispatchQueue(label: "syncExample")
        
        queue.async {
            print("🔸 async 1")
        }

        queue.sync {
            print("🔹 sync 1")
        }

        print(" Done")
    }
    
    
    func delayedExecution() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print(" Delayed by 3 seconds")
        }
    }

    
    func dispatchGroupExample() {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            print("Task 1")
            sleep(1)
            group.leave()
        }
        
        group.enter()
        DispatchQueue.global().async {
            print("🔄 Task 2")
            sleep(2)
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("✅ All tasks completed!")
        }
    }



}
