//
//  RefreshObserve.swift
//  HBRefresh
//
//  Created by Bang on 2025/8/28.
//

import UIKit

class RefreshObserve {
    
    private var offsetObserve: NSKeyValueObservation?
    private var contentSizeObserve: NSKeyValueObservation?
    private var deleagtes: NSHashTable<AnyObject> = .weakObjects()
    
    typealias Delegate = ScrollContentOffsetChangePtotocol
    
    func addDelegate(_ dlt: Delegate) {
        deleagtes.add(dlt)
    }
    
    func monitorScrollView(_ scrol: UIScrollView) {
        offsetObserve?.invalidate()
        offsetObserve = scrol.observe(\.contentOffset, options: [.old, .new], changeHandler: { [weak self] scrol, change in
            self?.deleagtes.allObjects.forEach {
                if let dlt = $0 as? Delegate {
                    Task { @MainActor in
                        dlt.scrollViewContentOffsetChanged(scrol, change: change)
                    }
                    
                }
            }
        })
        
        contentSizeObserve?.invalidate()
        contentSizeObserve = scrol.observe(\.contentSize, options: [.old, .new], changeHandler: { [weak self] scrol, change in
            self?.deleagtes.allObjects.forEach {
                if let dlt = $0 as? Delegate {
                    Task { @MainActor in
                        dlt.scrollViewContentSizeChanged(scrol, change: change)
                    }
                }
            }
        })
    }
    
    func stopMonitor() {
        offsetObserve?.invalidate()
        contentSizeObserve?.invalidate()
    }
    
}
