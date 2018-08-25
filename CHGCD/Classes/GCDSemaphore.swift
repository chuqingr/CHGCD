//
//  GCDSemaphore.swift
//  CHGCD
//
//  Created by 灰谷iMac on 2018/8/25.
//

import UIKit

open class GCDSemaphore {

    let semaphore : DispatchSemaphore

    public init(signal:Int = 0) {
        self.semaphore = DispatchSemaphore(value: signal)
    }

    /// MARK: Singal

    /// 发信号
    public func signal() {
        self.semaphore.signal()
    }

    /// MARK: Wait

    /// [阻塞操作] 无限等待
    public func wait() {
        self.semaphore.wait()
    }

    /// [阻塞操作] 等待指定的时间
    ///
    /// - Parameter seconds: 等待的时间,最多精确到1ms
    /// - Returns: DispatchTimeoutResult对象
    public func waitForSeconds(_ seconds : Float) -> DispatchTimeoutResult {

        return self.semaphore.wait(timeout: DispatchTime.now() + .milliseconds(Int(seconds * 1000)))
    }
}
