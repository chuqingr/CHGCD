//
//  GCDGroup.swift
//  CHGCD
//
//  Created by 灰谷iMac on 2018/8/25.
//

import UIKit

open class GCDGroup {
    let group : DispatchGroup

    public init() {
        self.group = DispatchGroup()
    }

    /// 在指定的queue里面获取消息
    ///
    /// - Parameters:
    ///   - queue: 指定的queue
    ///   - execute: 执行的block
    public func notifyIn(_ queue : GCDQueue, execute: @escaping () -> Void) {
        self.group.notify(queue: queue.queue, execute: execute)
    }

    /// 进入group
    public func enter() {
        self.group.enter()
    }

    /// 从group出来
    public func leave() {
        self.group.leave()
    }

    /// [阻塞操作] 无限等待
    public func wait() {
        self.group.wait()
    }

    /// [阻塞操作] 等待指定的时间
    ///
    /// - Parameter seconds: 等待的时间,最多精确到1ms
    /// - Returns: DispatchTimeoutResult对象
    public func waitForSeconds(seconds : Float) -> DispatchTimeoutResult {

        return self.group.wait(timeout: .now() + .milliseconds(Int(seconds * 1000)))
    }
}
