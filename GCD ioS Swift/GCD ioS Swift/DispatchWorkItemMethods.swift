//
//  DispatchWorkItemMethods.swift
//  GCD ioS Swift
//
//  Created by abcd on 22/04/25.
//
import Foundation
//A DispatchWorkItem is a block of code that can be dispatched on any queue and therefore the contained code to be executed on a background, or the main thread.
class DispatchWorkItemMethods {
    /**
     It wraps a block of code that you can:

     Schedule on a queue
     Cancel
     Wait for completion
     Reuse
     Add completion handlers
     */
    func cancleExample() {
        
        let workItem = DispatchWorkItem {
            print("Task running")
        }

        workItem.cancel() // Won't execute if cancelled before being scheduled

        DispatchQueue.global(priority: .default).async(execute: workItem)
        
        
        //MAnuallaay Run
        
        let workItem2 = DispatchWorkItem {
            print("Running directly")
        }

        workItem2.perform()
        
        let workItemQ = DispatchWorkItem {
            if workItem2.isCancelled {
                print("Cancelled before execution.")
                return
            }
            print("Executing non-cancelled task.")
        }

        workItem.cancel()

        DispatchQueue.global().async(execute: workItem)

    }
    
    func attachCompletion() {
        let workItem = DispatchWorkItem {
            print("Doing work")
        }

        workItem.notify(queue: DispatchQueue.main) {
            print("Work completed on main thread")
        }

        DispatchQueue.global().async(execute: workItem)

    }
    
    func workItemExample(){
        var value = 10
        
        let workItem = DispatchWorkItem {
            value += 5
        }
        
        workItem.perform()
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) {
            print("value = \(value)")
        }
    }
    
    
    //Never call sync on same queue, It will create deadlock.
    //Deadlock Example :
    func syncOnSameQueue() {
        let queueAsync = DispatchQueue(label: "com.multithreading.queueAsync")
        let queuesync = DispatchQueue(label: "com.multithreading.queuesync")
        
        queueAsync.sync {
            for i in 1...30 {
                print("->>>> \(i)")
            }
            queueAsync.sync {
                for i in 1...30 {
                    print("-<<<< \(i)")
                }
            }
        }
        
    }
    // more Exaamples on DeadLoack
    func deadlockExample() {
       // dont call in main thread
        DispatchQueue.main.sync {
            
        }
    }
    
    
}
