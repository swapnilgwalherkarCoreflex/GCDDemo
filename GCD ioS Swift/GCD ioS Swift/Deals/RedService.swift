//
//  RedService.swift
//  GCD ioS Swift
//
//  Created by abcd on 22/04/25.
//

import Foundation
import Foundation

// Simulated service
class RedService {
    func loadRouteSummary(completion: @escaping () -> Void) {
        print("Loading red route summary...")
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            print(" Finished loading red route summary.")
            completion()
        }
    }
}

// Class using DispatchGroup
class RedRouteManager {
    
    private let redService = RedService()
    
    func getTotalRedRouteOpportunity(completion: @escaping (Int) -> Void) {
        let dispatchGroup = DispatchGroup()
        var totalOpportunity = 0
        
        dispatchGroup.enter()
        redService.loadRouteSummary {
            // Simulate processing
            totalOpportunity = Int.random(in: 5...15)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("🎯 Total red route opportunity is \(totalOpportunity)")
            completion(totalOpportunity)
        }
    }
}

class RedRouteManagerAsyncAwait {
    
    private let redService = RedServiceAsyncAwait()

    func getTotalRedRouteOpportunity() async -> Int {
        await redService.loadRouteSummary()
        let totalOpportunity = Int.random(in: 5...15)
        print("Total red route opportunity is \(totalOpportunity)")
        return totalOpportunity
    }
}

class RedServiceAsyncAwait {
    func loadRouteSummary() async {
        // Simulate async delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        print("📦 Route summary loaded")
    }
}





class RedServicegroup {
    
    // Simulate an async task
    func loadRouteSummary() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        print("📦 Route summary loaded")
    }

    // Another async task
    func loadAdditionalData() async {
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        print("📦 Additional data loaded")
    }
}
class RedRouteManagerGroup {
    
    private let redService = RedServicegroup()
    
    // Using TaskGroup to manage multiple async tasks concurrently
    func getTotalRedRouteOpportunity() async -> Int {
        var totalOpportunity = 0
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.redService.loadRouteSummary()
            }
            group.addTask {
                await self.redService.loadAdditionalData()
            }
            
            // Wait for all tasks to complete
            await group.waitForAll()
        }
        
        totalOpportunity = Int.random(in: 5...15)
        print("🎯 Total red route opportunity is \(totalOpportunity)")
        
        return totalOpportunity
    }
}
