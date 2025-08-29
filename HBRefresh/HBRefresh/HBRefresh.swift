//
//  HBRefresh.swift
//  HBRefresh
//
//  Created by Bang on 2025/8/27.
//

import UIKit

public struct HBRefreshExtension<ExtendType> {
    
    public var type: ExtendType
    public init(type: ExtendType) {
        self.type = type
    }
}

public protocol HBRefreshExtend {
    associatedtype type
    var hb: HBRefreshExtension<type> { get set }
}

extension HBRefreshExtend {
    public var hb: HBRefreshExtension<Self> {
        get { HBRefreshExtension(type: self) }
        set {}
    }
}

public typealias RefreshHandler = ()->Void

public enum RefreshState {
    case Idle
    case Pulling
    case WillRefresh
    case Refreshing
}

@MainActor
public protocol RefreshAnimator {
    var view: UIView { get }
    var hb_height: CGFloat { get }
    var trigger: CGFloat { get }
    
    func refreshPulling(_ scrollView: UIScrollView)
    func refreshWillRefresh(_ scrollView: UIScrollView)
    func refreshRefreshing(_ scrollView: UIScrollView)
    func refreshIdle(_ scrollView: UIScrollView)
}

