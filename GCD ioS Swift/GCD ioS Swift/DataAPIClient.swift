
import UIKit
import Foundation


enum dataApiUrl: String {
    case name = " https://jsonplaceholder.typicode.com/todos/1"
    case address = "https://jsonplaceholder.typicode.com/todos/2"
    case head = "https://jsonplaceholder.typicode.com/todos/3"
}

class DataAPIClient {
    
    let semaphore = DispatchSemaphore(value: 1)
    
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
    
    typealias DataCompetionHandler = (String?, Error?) -> Void
    
    func getData(apiUrl: dataApiUrl, completionHandler completion: @escaping DataCompetionHandler) {
        
        
        guard let url =  URL(string: "\(apiUrl.rawValue)") else {
            completion(nil, DataError.invaliedUrl)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                guard error == nil else {
                    completion(nil, DataError.requestFailed)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, DataError.requestFailed)
                    return
                }

            DispatchQueue.main.async {
                
                guard let data = String(data: data!, encoding: .utf8 ) else { return }
                print(data)
                completion(data, nil)

            }
        })
        dataTask.resume()
    }
    
    func getDataWithSemaphore(apiUrl: dataApiUrl) {
        semaphore.wait()  // Block until we get signal to proceed
        
        getData(apiUrl: apiUrl) { data, error in
            if let data = data {
                print(" Received data for \(apiUrl): \(data)")
            } else if let error = error {
                print(" Error for \(apiUrl): \(error)")
            }
            self.semaphore.signal() // Signal that the task is complete
        }
        
        
//        let apiClient = DataAPIClient()
//        let endpoints: [dataApiUrl] = [.name, .address, .head]
//
//        DispatchQueue.global().async {
//            for endpoint in endpoints {
//                apiClient.getDataWithSemaphore(apiUrl: endpoint)
//            }
//        }
    }
    
    
    func semaphoreExampleUSe() {
        let semaphore = DispatchSemaphore(value: 2) // max 2 tasks at once
        let concurrentQueue = DispatchQueue(label: "com.example.queue", attributes: .concurrent)

        for i in 1...10 {
            concurrentQueue.async {
                semaphore.wait() // blocks if 2 tasks are already running
                
                // we can get a warning like below
                //Thread running at User-initiated quality-of-service class waiting on a thread without a QoS class specified (base priority 0). Investigate ways to avoid priority inversions
                print("Start task \(i)")
                sleep(1) // simulate work
                print("End task \(i)")
                semaphore.signal()
            }
        }

    }
    //solution
    func semaphoreExampleUseFixed() {
        let semaphore = DispatchSemaphore(value: 2)
        let concurrentQueue = DispatchQueue(label: "com.example.queue", qos: .userInitiated, attributes: .concurrent)

        for i in 1...10 {
            concurrentQueue.async {
                semaphore.wait()
                print("Start task \(i) - \(Thread.current)")
                sleep(1)
                print("End task \(i)")
                semaphore.signal()
            }
        }
    }
    
    func semaphoreWithAsyncLetStyle() {
        Task(priority: .userInitiated) {
            await withTaskGroup(of: Void.self) { group in
                let semaphore = DispatchSemaphore(value: 2)

                for i in 1...10 {
                    group.addTask {
                        semaphore.wait()
                        print("Start task \(i) on \(Thread.current)")
                        sleep(1)
                        print("End task \(i)")
                        semaphore.signal()
                    }
                }
            }
        }
    }
    
    func usingOperationQueue() {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        queue.qualityOfService = .userInitiated

        for i in 1...10 {
            queue.addOperation {
                print(" Start task \(i) - \(Thread.current)")
                sleep(1)
                print(" End task \(i)")
            }
        }
    }
    
    func asyncConcurrencyLimitExample() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                let maxConcurrentTasks = 2
                var activeTasks = 0
                var i = 1

                let lock = NSLock()

                while i <= 10 {
                    lock.lock()
                    if activeTasks < maxConcurrentTasks {
                        let taskNumber = i
                        activeTasks += 1
                        i += 1
                        lock.unlock()

                        group.addTask {
                            print("Start task \(taskNumber) on \(Thread.current)")
                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                            print("End task \(taskNumber)")

                            lock.lock()
                            activeTasks -= 1
                            lock.unlock()
                        }
                    } else {
                        lock.unlock()
                        try? await Task.sleep(nanoseconds: 100_000_000) // wait 0.1 sec
                    }
                }
            }
        }
    }



    
    

    func simulateRateLimitedApiCalls() {
        let semaphore = DispatchSemaphore(value: 2) // Limit: 2 requests at a time
        let queue = DispatchQueue(label: "com.app.apiQueue", qos: .userInitiated, attributes: .concurrent)

        for i in 1...10 {
            queue.async {
                semaphore.wait() // Wait if 2 tasks are already running
                print("📤 Starting download \(i) on \(Thread.current)")

                self.simulateDownload(for: i) {
                    print("✅ Finished download \(i)")
                    semaphore.signal()
                }
            }
        }
    }

    func simulateDownload(for id: Int, completion: @escaping () -> Void) {
        // Simulate 1-3 sec delay for API call
        let delay = UInt32.random(in: 1...3)
        sleep(delay)
        completion()
    }



}

//Some Points for Sema phore
                    
//                    When you're in a background thread
//                    When you must wait for a result before moving forward
//                    When tasks depend on each other or must be rate-limited
//                     Be careful:
//
//                    Never use semaphore.wait() on the main thread — it will freeze your UI
//                    Prefer modern async/await or DispatchGroup for sequencing when possible
