//
//  CHGCDQueuePriority.swift
//  CHGCD
//
//  Created by 灰谷iMac on 2018/8/25.
//

import UIKit

/// 优先级
public enum GCDQueuePriority {
    case priorityLevel1  /// 优先级最高.userInteractive
    case priorityLevel2  /// .unspecified
    case priorityLevel3  /// .default
    case priorityLevel4  /// .utility
    case priorityLevel5  /// .background
    case priorityLevel6  /// .unspecified

    func getDispatchQoSClass() -> DispatchQoS.QoSClass {
        var qos: DispatchQoS.QoSClass

        switch self {
        case .priorityLevel1:
            qos = .userInteractive

        case .priorityLevel2:
            qos = .unspecified

        case .priorityLevel3:
            qos = .default

        case .priorityLevel4:
            qos = .utility

        case .priorityLevel5:
            qos = .background

        case .priorityLevel6:
            qos = .unspecified
        }

        return qos
    }

    func getDispatchQoS() -> DispatchQoS {

        var qos: DispatchQoS

        switch self {
        case .priorityLevel1:
            qos = .userInteractive

        case .priorityLevel2:
            qos = .unspecified

        case .priorityLevel3:
            qos = .default

        case .priorityLevel4:
            qos = .utility

        case .priorityLevel5:
            qos = .background

        case .priorityLevel6:
            qos = .unspecified
        }

        return qos
    }
}


