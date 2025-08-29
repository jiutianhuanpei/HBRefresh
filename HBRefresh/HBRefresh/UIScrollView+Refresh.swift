//
//  UIScrollView+Refresh.swift
//  HBRefresh
//
//  Created by Bang on 2025/8/27.
//

import UIKit

extension UIScrollView : HBRefreshExtend {
    private struct RuntimeKeys {
        static let HBObserve = "HBObserve"
    }
    
    
    @MainActor var observer: RefreshObserve {
        set {}
        get {
            if let obj = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: RuntimeKeys.HBObserve.hashValue)!) as? RefreshObserve {
                return obj
            }
            let obj = RefreshObserve()
            objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: RuntimeKeys.HBObserve.hashValue)!, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return obj
        }
    }
    
}


@MainActor extension HBRefreshExtension where ExtendType : UIScrollView {
    
    private var header: RefreshComponent? {
        let theader = type.subviews.filter {
            if let v = $0 as? RefreshComponent {
                return v.type == .Header
            }
            return false
        }.first
        if let h = theader as? RefreshComponent {
            return h
        }
        return nil
    }
    
    private var footer: RefreshComponent? {
        let theader = type.subviews.filter {
            if let v = $0 as? RefreshComponent {
                return v.type == .Footer
            }
            return false
        }.first
        if let h = theader as? RefreshComponent {
            return h
        }
        return nil
    }
    
    public func addHeader(_ animator: RefreshAnimator, handler: @escaping RefreshHandler) {
        header?.removeFromSuperview()
        
        let view = RefreshComponent(animator: animator, addTo: type, type: .Header)
        view.handler = handler
        
        type.observer.addDelegate(view)
        type.observer.monitorScrollView(type)
    }
    
    public func addFooter(_ animator: RefreshAnimator, handler: @escaping RefreshHandler) {
        footer?.removeFromSuperview()
        
        let view = RefreshComponent(animator: animator, addTo: type, type: .Footer)
        view.handler = handler
        
        type.observer.addDelegate(view)
        type.observer.monitorScrollView(type)
    }
    
    public func beginRefresh() {
        header?.start()
    }
    
    public func endRefresh() {
        header?.stop()
    }
    
    public func beginLoadMoreData() {
        footer?.start()
    }
    
    public func endLoadMoreData() {
        footer?.stop()
    }
}
