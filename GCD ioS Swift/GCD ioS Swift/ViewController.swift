
import UIKit

//What is GCD?
//
//GCD stands for Grand Central Dispatch.
//It is a low-level API provided by Apple to perform concurrent tasks.
//Helps improve app performance by offloading heavy tasks to background threads.
//
//An object that manages the execution of tasks serially or concurrently on your app’s main thread or on a background thread.
//Dispatch queues are FIFO queues to which your application can submit tasks in the form of block objects. Dispatch queues execute tasks either serially or concurrently. Work submitted to dispatch queues executes on a pool of threads managed by the system. Except for the dispatch queue representing your app’s main thread, the system makes no guarantees about which thread it uses to execute a task.
//enum QoSClass

// last LIFO


class ViewController: UIViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var headLabel: UILabel!
    
    var dataAPIClient = DataAPIClient()
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
#warning("below code will crash if not used inside DispatchQueue.global().async")
//        DispatchQueue.main.sync {
//            self.nameLabel.text = "khjsd"
//            
//        }
        
//        DispatchWorkItemMethods().syncOnSameQueue()
   
        OperationQueuesExamples().method()

        
        //methodforQOS()
        
        dataAPIClient.usingOperationQueue()
        let backgroundQueue = DispatchQueue(label: "com.arvind.bgqueue", qos: .userInteractive)

        backgroundQueue.async {
            // Fast operation: e.g., filter items based on user typing
          //  let result = expensiveSearchFilter()

            DispatchQueue.main.async {
                // UI update
                self.headLabel.text = " found"
            }
        }
//        let myConcurrentQueue = DispatchQueue(label: "com.example.myQueue", attributes: .initiallyInactive)
//        myConcurrentQueue.activate()
        
        //concurrentASync()
        //Use .initiallyInactive if you're building up tasks conditionally and want full control over when they start. Combine it with .concurrent if those tasks can run in parallel after activation.
        

//        Case    Description
//        .inherit    Inherits frequency from the target queue (default behavior).
//        .workItem    Creates a new autorelease pool for each block (work item).
//        .never    Disables autorelease pool entirely (you must manage memory manually).
        let queue = DispatchQueue(
            label: "com.myapp.optimize",
            qos: .utility,
            attributes: [],
            autoreleaseFrequency: .workItem
        )
        
//        Frequency    When to Use    Memory Handling
//        .inherit    Let it behave same as parent queue (usually enough)    Default behavior
//        .workItem    You want a new autorelease pool for every block you dispatch. Useful if your block creates lots of temporary objects (e.g., images, strings, etc.).    Automatic clean-up
//        .never    You want full control. You must create autorelease pools manually. Used in advanced or performance-critical situations.    Manual clean-up
        
        

        

//        
//        let currentLabel = String(cString: __dispatch_queue_get_label(nil), encoding: .utf8)
//        print("Currently on queue: \(currentLabel ?? "unknown")")

    }
    
    func methodforQOS() {
        
//        userInitiated – User started the task, expect results soon
//        
//            .userInteractive = You’re standing at the counter placing an order. Immediate attention.
//            .background = Someone’s working in the back, preparing future supplies. Important, but not urgent.
//        
//        unspecified
//        
//        Type Method
//        global(qos:)
//        Returns the global system queue with the specified quality-of-service class.
        DispatchQueue.global(qos: .userInteractive).async {
            // Quick UI-related task
            print("UserInteractive task running")

            DispatchQueue.main.async {
                print("UI updated immediately")
            }
        }


        func simulateTask(with qos: DispatchQoS.QoSClass, name: String) {
            DispatchQueue.global(qos: qos).async {
                for i in 1...5 {
                    print("\(name): \(i)")
                }
            }
        }

        simulateTask(with: .userInitiated, name: "UserInitiated")
        simulateTask(with: .background, name: "Background")
        simulateTask(with: .userInteractive, name: "UserInteractive")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func serialSync() {
        
        let serialQueue = DispatchQueue(label: "com.example.serial")

        print("--->>> Start")

        serialQueue.sync {
            print("Task 1")
            sleep(1)
        }

        serialQueue.sync {
            print(" Task 2")
            sleep(1)
        }

        print("🏁 End")
        
        
    }
    
    
    func serialASync() {
        
        let serialQueue = DispatchQueue(label: "com.example.serial")

        print("--->>> Start")

        serialQueue.async {
            print("🔹 Task 1")
            sleep(1)
        }

        serialQueue.async {
            print("🔹 Task 2")
            sleep(1)
        }

        print("🏁 End")

        
    }
    
    func concurrentSync() {
        //sync still blocks the calling thread until the task completes.

        let concurrentQueue = DispatchQueue(label: "com.example.concurrent", attributes: [.concurrent, .initiallyInactive])

        print("--->>> Start")

        concurrentQueue.sync {
            print("🟢 Task 1 - \(Thread.current)")
            sleep(1)
        }

        concurrentQueue.sync {
            print("🟢 Task 2 - \(Thread.current)")
            sleep(1)
        }
        concurrentQueue.activate()

        print("End")

    }
    func concurrentASync() {
        //sync still blocks the calling thread until the task completes.

        let concurrentQueue = DispatchQueue(label: "com.example.concurrent", attributes: [.concurrent, .initiallyInactive])

        print("--->>> Start")

        concurrentQueue.async {
            print("🟢 Task 1 - \(Thread.current)")
            sleep(1)
        }

        concurrentQueue.async {
            print("🟢 Task 2 - \(Thread.current)")
            sleep(1)
        }
//        concurrentQueue.activate()

        print("End")

    }
    
    func queueWithDelay(){
           let delayQueue = DispatchQueue(label: "delayQueueExmp",qos: .userInitiated)
           print(Date())
           let additionalTime:DispatchTimeInterval = .seconds(2)
           
           delayQueue.asyncAfter(deadline: .now()+additionalTime) {
               print(Date())
           }
       }
    
    func dispatchGroupMethod() {
        
        // Run
        Task {
            let manager = RedRouteManagerAsyncAwait()
            let total = await manager.getTotalRedRouteOpportunity()
            print("🌟 Final Total: \(total)")
        }
        //RedRouteManagerAsyncAwait
        let manager = RedRouteManager()
        manager.getTotalRedRouteOpportunity { total in
            print("....Done! Final Opportunity = \(total)")
        }
        let group = DispatchGroup()

        let queue = DispatchQueue.global(qos: .userInitiated)

        for i in 1...3 {
            group.enter()
            queue.async {
                print("🔸 Task \(i) started")
                sleep(1)
                print("✅ Task \(i) finished")
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            print("🎉 All tasks in Group 1 finished. Now start next batch!")
        }
    }
    
    
    
    func addAsyncTaskInDispatchGroup() {
        let group = DispatchGroup()

        group.enter()
        dataAPIClient.getData(apiUrl: .name) { (data, error) in
            defer { group.leave() }

            if let error = error {
                print("Error fetching name: \(error.localizedDescription)")
                return
            }

            if let data = data {
                DispatchQueue.main.async {
                    self.nameLabel.text = data
                }
            }
        }

        group.enter()
        dataAPIClient.getData(apiUrl: .address) { (data, error) in
            defer { group.leave() }

            if let error = error {
                print("Error fetching address: \(error.localizedDescription)")
                return
            }

            if let data = data {
                DispatchQueue.main.async {
                    self.addressLabel.text = data
                }
            }
        }
        

        group.enter()
        dataAPIClient.getData(apiUrl: .head) { (data, error) in
            defer { group.leave() }

            if let error = error {
                print("Error fetching head: \(error.localizedDescription)")
                return
            }

            if let data = data {
                DispatchQueue.main.async {
                    self.headLabel.text = data
                }
            }
        }

        // Notify when all have finished
        group.notify(queue: .main) {
            print("All data fetched and UI updated")
            
            // You can hide a loading indicator here, or enable a button
        }
    }
    
    
    

}

