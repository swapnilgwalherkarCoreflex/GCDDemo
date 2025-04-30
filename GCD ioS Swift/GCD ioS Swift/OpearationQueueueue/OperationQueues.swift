//
//  OperationQueues.swift
//  GCD ioS Swift
//
//  Created by abcd on 23/04/25.
//
import Foundation
///BlockOperation
//A class you use as-is to execute one or more block objects concurrently. Because it can execute more than one block, a block operation object operates using a group semantic; only when all of the associated blocks have finished executing is the operation itself considered finished.. In block operation you can take advantage of operation dependencies, KVO, notifications and cancelling .
//As shown in Figure 1 we executed this code async which means it will return immediately but the bad news is it will block the main thread since operation.start() was called on main thread




class OperationQueuesExamples{
    func method() {
        let queue = OperationQueue()
        let operation1 = BlockOperation {
            
            autoreleasepool {
                // Perform operations inside the autorelease pool
                //let image = loadImage() // Example task
            }
            print("Load data")
        }
        let operation2 = BlockOperation {
            print("Parse data")
        }
        operation2.addDependency(operation1)
        
        operation2.addExecutionBlock {
            
      
            
        }
//        operation2.waitUntilFinished()

        queue.addOperations([operation1, operation2], waitUntilFinished: false)
//        operation.cancel()
        
        operation2.queuePriority = .veryHigh
        operation2.qualityOfService = .userInitiated
        
        queue.maxConcurrentOperationCount = 2  // Set how many can run at the same time
        operation2.completionBlock = {
            print("Done")
            
        }



        operation2.start()

    }
    
    
    func methodBlockOperation() {
        let queue = OperationQueue()
        
        let operation1 = BlockOperation {
            print("Load data")
        }

        let operation2 = BlockOperation {
            print(" Parse data")
        }
        
        operation2.addDependency(operation1) // ⛓️ Wait for op1
        operation2.queuePriority = .veryHigh
        operation2.qualityOfService = .userInitiated

        operation2.completionBlock = {
            print(" Done parsing")
        }

        queue.maxConcurrentOperationCount = 2
        queue.addOperations([operation1, operation2], waitUntilFinished: false)
    }
    
    func operationWithExecutionBlocks() {
        let queue = OperationQueue()
        
        let operation = BlockOperation {
            print(" Main Task - \(Thread.current)")
            Thread.sleep(forTimeInterval: 2)
            print(" Main Task Done")
        }

        operation.addExecutionBlock {
            print("Extra Task 1 - \(Thread.current)")
            Thread.sleep(forTimeInterval: 1)
            print("Extra Task 1 Done")
        }

        operation.addExecutionBlock {
            print("Extra Task 2 - \(Thread.current)")
            Thread.sleep(forTimeInterval: 1.5)
            print(" Extra Task 2 Done")
        }

        operation.completionBlock = {
            print(" Operation Finished (All blocks done)")
        }

        queue.addOperation(operation)
    }
    

    func simulateParallelApiCallsInSingleOperation() {
        let queue = OperationQueue()

        let apiCallOperation = BlockOperation {
            print("Main API Call 1 started - \(Thread.current)")
            Thread.sleep(forTimeInterval: 2)
            print(" Main API Call 1 completed")
        }

        // Simulate API Call 2
        apiCallOperation.addExecutionBlock {
            print("API Call 2 started - \(Thread.current)")
            Thread.sleep(forTimeInterval: 1.5)
            print(" API Call 2 completed")
        }

        // Simulate API Call 3
        apiCallOperation.addExecutionBlock {
            print(" API Call 3 started - \(Thread.current)")
            Thread.sleep(forTimeInterval: 1)
            print(" API Call 3 completed")
        }

        // Completion block
        apiCallOperation.completionBlock = {
            print(" All API calls completed. Proceed to next step.")
        }

        queue.addOperation(apiCallOperation)
    }



}

class DownloadOperation: Operation{
    
}
