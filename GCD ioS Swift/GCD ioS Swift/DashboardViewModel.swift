//
//  DashboardViewModel.swift
//  GDC-Demo
//
//  Created by abcd on 18/04/25.
//  Copyright © 2025 TaiHsinLee. All rights reserved.
//

import Foundation
class DashboardViewModel {
    
    func fetchUserData() {
        // Step 1: Background task (e.g., network call simulation)
        DispatchQueue.global(qos: .background).async {
            print("🌐 Fetching user data...")

            // Simulate delay
            sleep(2)
            let fakeJSON = ["name": "Swapnil", "points": 100]

            // Step 2: UI update on main thread
            DispatchQueue.main.async {
                print("🎉 Got data: \(fakeJSON)")
                print("🔧 Update UI here")
            }
        }
    }
}
