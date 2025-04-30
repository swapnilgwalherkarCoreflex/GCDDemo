//
//  AsyncOperation.swift
//  GCD ioS Swift
//
//  Created by abcd on 23/04/25.
//

import Foundation
class AsyncOperation: Operation {
    private var _executing = false
    private var _finished = false

    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { _executing }
    override var isFinished: Bool { _finished }

    override func start() {
        if isCancelled {
            finish()
            return
        }

        _executing = true
        // Start your async work
        DispatchQueue.global().async {
            // Work...
            self.finish()
        }
        self.cancel()
    }

    func finish() {
        _executing = false
        _finished = true
    }
}

//
//Use This    When
//Task {}    UI-triggered async tasks
//Task.detached    Background non-UI work
//Task(priority:)    Set priority for responsiveness
//task.cancel()    Stop unneeded work
//Task.isCancelled    Check status inside loop
