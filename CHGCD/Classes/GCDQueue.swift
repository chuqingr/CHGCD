//
//  GCDQueue.swift
//  CHGCD
//
//  Created by 灰谷iMac on 2018/8/25.
//

import UIKit

open class GCDQueue {

    let queue : DispatchQueue

    public init(queue:DispatchQueue) {
        self.queue = queue
    }

    // MARK: globalQueue & mainQueue

    /// 获取主线程
    public class var main : GCDQueue {

        return GCDQueue.init(queue: DispatchQueue.main)
    }

    /// 获取子线程
    ///
    /// - Parameter priority: 优先级
    /// - Returns: 子线程
    public class func global(_ priority : GCDQueuePriority = .priorityLevel3) -> GCDQueue {

        return GCDQueue.init(queue: DispatchQueue.global(qos: priority.getDispatchQoSClass()))
    }

    // MARK: concurrentQueue & serialQueue

    /// 获取并发线程
    ///
    /// - Parameters:
    ///   - label: 线程标签
    ///   - priority: 优先级
    /// - Returns: 并发线程
    public class func concurrent(_ label : String = "", _ priority : GCDQueuePriority = .priorityLevel3) -> GCDQueue {

        return GCDQueue.init(queue : DispatchQueue(label: label, qos: priority.getDispatchQoS(), attributes: .concurrent))
    }

    /// 获取串行线程
    ///
    /// - Parameters:
    ///   - label: 线程标签
    ///   - priority: 优先级
    /// - Returns: 串行线程
    public class func serial(_ label : String = "", _ priority : GCDQueuePriority = .priorityLevel3) -> GCDQueue {

        return GCDQueue.init(queue : DispatchQueue(label: label, qos: priority.getDispatchQoS()))
    }

    // MARK: Excute

    /// 异步执行
    ///
    /// - Parameter excute: 执行的block
    public func excute(_ excute : @escaping ()-> Void) {

        queue.async(execute: excute)
    }

    /// 延时异步执行
    ///
    /// - Parameters:
    ///   - seconds: 延时秒数,最多精确到1ms
    ///   - excute: 执行的block
    public func excuteAfterDelay(_ seconds : Float, _ excute : @escaping ()-> Void) {

        queue.asyncAfter(deadline: .now() + .milliseconds(Int(seconds * 1000)), execute: excute)
    }

    /// 同步执行
    ///
    /// - Parameter excute: 执行的block
    public func excuteAndWaitsUntilTheBlockCompletes(_ excute : @escaping ()-> Void) {

        queue.sync(execute: excute)
    }

    /// 在group中执行
    ///
    /// - Parameters:
    ///   - group: GCDGroup对象
    ///   - excute: 执行的block
    public func excuteInGroup(_ group : GCDGroup, _ excute : @escaping ()-> Void) {

        queue.async(group: group.group, execute: excute)
    }

    // MARK: Class method for excute

    /// 在主线程执行
    ///
    /// - Parameter excute: 执行的block
    public class func excuteInMain(_ excute : @escaping ()-> Void) {

        GCDQueue.main.excute(excute)
    }

    /// 在主线程延时执行
    ///
    /// - Parameters:
    ///   - seconds: 延时秒数,最多精确到1ms
    ///   - excute: 执行的block
    public class func excuteInMainAfterDelay(_ seconds : Float, _ excute : @escaping ()-> Void) {

        GCDQueue.main.excuteAfterDelay(seconds, excute)
    }

    /// 在子线程执行
    ///
    /// - Parameters:
    ///   - priority: 优先级
    ///   - excute: 执行的block
    public class func excuteInGlobal(_ priority : GCDQueuePriority = .priorityLevel3, _ excute : @escaping ()-> Void) {

        GCDQueue.global(priority).excute(excute)
    }

    /// 在子线程延时执行
    ///
    /// - Parameters:
    ///   - seconds: 延时秒数,最多精确到1ms
    ///   - excute: 执行的block
    public class func excuteInGlobalAfterDelay(_ seconds : Float, _ excute : @escaping ()-> Void) {

        GCDQueue.global().excuteAfterDelay(seconds, excute)
    }
}
