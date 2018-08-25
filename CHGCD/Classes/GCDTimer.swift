//
//  GCDTimer.swift
//  CHGCD
//
//  Created by 灰谷iMac on 2018/8/25.
//

import UIKit

public protocol GCDTimer {
    func resume()
    func suspend()
    func cancel()
    func setDestroyEventHandler(eventHandler: @escaping ()-> Void)
}

open class GCDTimerMaker {
    public static func makeTimer(in queue:GCDQueue = GCDQueue(queue: DispatchQueue.main), adding: TimeInterval, task: (()->())?) -> GCDTimer {
        return GCDTimerImp(in: queue, deadline: .now() + adding, repeating: .never, task: task)
    }

    public static func makeTimer(in queue:GCDQueue = GCDQueue(queue: DispatchQueue.main), adding: TimeInterval, repeatInterval: Int, task: (()->())?) -> GCDTimer {
        return GCDTimerImp(in: queue, deadline: .now() + adding, repeating: .seconds(repeatInterval), task: task)
    }

    public static func makeTimer(in queue:GCDQueue = GCDQueue(queue: DispatchQueue.main), repeatInterval: Int, task: (()->())?) -> GCDTimer {
        return GCDTimerImp(in: queue, deadline: .now(), repeating: .seconds(repeatInterval), task: task)
    }
}

class GCDTimerImp:GCDTimer {

    private let timer : DispatchSourceTimer

    private var lock = NSLock()

    private enum State {
        case suspended
        case resumed
        case cancel
    }

    private var state: State = .suspended

    init(in : GCDQueue, deadline : DispatchTime , repeating: DispatchTimeInterval = .never , leeway : DispatchTimeInterval = .milliseconds(100),task: (()->())?) {
        timer = DispatchSource.makeTimerSource(flags: [], queue: `in`.queue)
        timer.schedule(deadline: deadline,
                       repeating: repeating,
                       leeway: leeway)
        timer.setEventHandler {
            task?()
        }
    }

    /// 开始定时
    func resume() {
        guard state != .resumed else { return }
        lock.lock()
        defer {
            lock.unlock()
        }
        guard state != .resumed else { return }
        state = .resumed
        timer.resume()
    }

    func cancel() {
        guard state != .cancel else { return }
        lock.lock()
        defer {
            lock.unlock()
        }
        guard state != .cancel else { return }
        state = .cancel
        timer.cancel()
    }

    func suspend() {
        guard state != .suspended else { return }
        lock.lock()
        defer {
            lock.unlock()
        }
        guard state != .suspended else { return }
        state = .suspended
        timer.suspend()
    }

    deinit {
        timer.setEventHandler {}
//        task = nil
        debugPrint("deinit timer source")
    }

    /// 设定定时器任务的回调函数
    ///
    /// - Parameter eventHandler: 回调函数
//    func setTimerEventHandler(eventHandler: @escaping (GCDTimer)-> Void) {
//        timer.setEventHandler {
//            eventHandler(self)
//        }
//    }

    /// 设定定时器销毁时候的回调函数
    ///
    /// - Parameter eventHandler: 回调函数
    func setDestroyEventHandler(eventHandler: @escaping ()-> Void) {
        timer.setCancelHandler {
            eventHandler()
        }
    }

}
