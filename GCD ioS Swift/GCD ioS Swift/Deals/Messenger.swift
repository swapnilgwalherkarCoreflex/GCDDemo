//
//  Messenger.swift
//  GCD ioS Swift
//
//  Created by abcd on 22/04/25.
//
import Foundation

final class Messenger {

    private var messages: [String] = []

    private var queue = DispatchQueue(label: "messages.queue", attributes: .concurrent)

    var lastMessage: String? {
        return queue.sync {
            messages.last
        }
    }

    func postMessage(_ newMessage: String) {
        queue.sync(flags: .barrier) {
            messages.append(newMessage)
        }
    }
}


final class Messenger2 {

    private var messages: [String] = []
    private let lock = NSLock() // Create a lock

    var lastMessage: String? {
        lock.lock()
        defer { lock.unlock() }
        return messages.last
    }

    func postMessage(_ newMessage: String) {
        lock.lock()
        messages.append(newMessage)
        lock.unlock()
    }
}
class AsyncAwaitExample {
    var urls: [URL] = []

    func fetchAll() async throws -> [Data] {
        return try await withThrowingTaskGroup(of: Data.self) { group in
            for url in urls {
                group.addTask {
                    try await self.fetchData(from: url)
                }
            }

            return try await group.reduce(into: []) { $0.append($1) }
        }
    }

    private func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

