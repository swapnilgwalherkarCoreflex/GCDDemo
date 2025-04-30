
import Foundation

enum DataError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invaliedUrl
}

class DefeBlock {
    
    func doSomething() {
        print("Start")

        defer {
            print("Cleanup code runs last")
        }

        print("Doing work")
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("Started task")

            defer {
                print(" Cleaned up after task")
            }

            // simulate work
            sleep(1)
            print(" Task finished")
        }

    }

}
