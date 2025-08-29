//
//  RefreshComponent.swift
//  HBRefresh
//
//  Created by Bang on 2025/8/27.
//

import UIKit

protocol ScrollContentOffsetChangePtotocol : AnyObject {
    func scrollViewContentOffsetChanged(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>)
    func scrollViewContentSizeChanged(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGSize>)
}

extension ScrollContentOffsetChangePtotocol {
    func scrollViewContentOffsetChanged(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {}
    func scrollViewContentSizeChanged(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGSize>) {}
}

@MainActor class RefreshComponent: UIView, ScrollContentOffsetChangePtotocol {
    
    public enum ViewType {
        case Header
        case Footer
    }
    
    private var animator: RefreshAnimator
    private var scrollView: UIScrollView
    private(set) public var type: ViewType
    public var handler: RefreshHandler?
    
    private var leftConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    init(animator: RefreshAnimator, addTo scrollView: UIScrollView, type: ViewType) {
        self.animator = animator
        self.scrollView = scrollView
        self.type = type
        super.init(frame: .zero)
        
        addSubview(animator.view)
        animator.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.insertSubview(self, at: 0)
        translatesAutoresizingMaskIntoConstraints = false
        
        var ar = [
            animator.view.leftAnchor.constraint(equalTo: leftAnchor),
            animator.view.topAnchor.constraint(equalTo: topAnchor),
            animator.view.rightAnchor.constraint(equalTo: rightAnchor),
            animator.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        leftConstraint = leftAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leftAnchor)
        rightConstraint = rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor)
        heightConstraint = heightAnchor.constraint(equalToConstant: animator.hb_height)
        
        ar.append(leftConstraint!)
        ar.append(rightConstraint!)
        ar.append(heightConstraint!)
        
        if type == .Header {
            bottomConstraint = bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -scrollView.contentInset.top)
            ar.append(bottomConstraint!)
        } else {
            topConstraint = topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor)
            ar.append(topConstraint!)
        }
        
        
        NSLayoutConstraint.activate(ar)
        
        state = .Idle
        animator.refreshIdle(scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var lastIsDragging = false
    private var state: RefreshState = .Idle
    private var storeageInset: UIEdgeInsets = .zero
    
    func start() {
        if state == .Refreshing {
            return
        }
        scrollView.observer.stopMonitor()
        storeageInset = scrollView.contentInset
        state = .Refreshing
        animator.refreshRefreshing(scrollView)
        
        handler?()
        
        UIView.animate(withDuration: 0.3) {[self] in
            if type == .Header {
                scrollView.contentInset.top = storeageInset.top + animator.trigger
                
                let tt = scrollView.adjustedContentInset.top + animator.trigger
                scrollView.setContentOffset(.init(x: 0, y: -tt), animated: true)
            } else {
                
                let top = scrollView.contentInset.top
                let topSafe = scrollView.safeAreaInsets.top
                let contentH = scrollView.contentSize.height;
                let bottom = scrollView.contentInset.bottom
                let bottomSafe = scrollView.safeAreaInsets.bottom
                
                if topSafe + top + contentH + bottom + bottomSafe < scrollView.bounds.height {
                    //不够一屏
                    let top = scrollView.bounds.height - scrollView.safeAreaInsets.top - scrollView.contentInset.top - contentH
                    scrollView.contentInset.bottom = top + animator.trigger
                } else {
                    scrollView.contentInset.bottom = storeageInset.bottom + animator.trigger + bottomSafe
                }
            }
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.3) { [self] in
            scrollView.contentInset = storeageInset
        } completion: { [self] _ in
            state = .Idle
            animator.refreshIdle(scrollView)
            scrollView.observer.monitorScrollView(scrollView)
        }
    }
    
    //MARK: - noti
    func scrollViewContentOffsetChanged(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
        guard let oldValue = change.oldValue,
              let newValue = change.newValue else { return }
        
        let delate = newValue.y - oldValue.y
        let isDragging = scrollView.isDragging
        
        let scrollDown = delate < 0
        
        switch type {
        case .Header:
            let safeH = scrollView.adjustedContentInset.top
            if isDragging {
                if newValue.y + safeH < 0 {
                    //手指滑动，且拖动到显示区域
                    let kOffset = abs(newValue.y + safeH)
                    if kOffset > animator.trigger {
                        state = .WillRefresh
                        animator.refreshWillRefresh(scrollView)
                    } else {
                        state = .Pulling
                        animator.refreshPulling(scrollView)
                    }
                } else {
                    state = .Idle
                    animator.refreshIdle(scrollView)
                }
            }
            
            if !isDragging, lastIsDragging, state == .WillRefresh {
                //                state = .Refreshing
                start()
            }
            
            if !scrollDown, newValue.y + safeH >= 0, state != .Idle {
                state = .Idle
                animator.refreshIdle(scrollView)
            }
            
            break
        case .Footer:
            let bottomSafe = scrollView.safeAreaInsets.bottom
            
            let offsetY1 = frame.origin.y + bottomSafe - scrollView.bounds.height
            if isDragging {
                if newValue.y > offsetY1 {
                    if newValue.y - offsetY1 > animator.trigger {
                        state = .WillRefresh
                        animator.refreshWillRefresh(scrollView)
                    } else {
                        state = .Pulling
                        animator.refreshPulling(scrollView)
                    }
                } else {
                    state = .Idle
                    animator.refreshIdle(scrollView)
                }
            }
            
            if !isDragging, lastIsDragging, state == .WillRefresh {
                //                state = .Refreshing
                start()
            }
            
            if scrollDown, newValue.y <= offsetY1, state != .Idle {
                state = .Idle
                animator.refreshIdle(scrollView)
            }
            break
        }
        
        lastIsDragging = isDragging
    }
    
    func scrollViewContentSizeChanged(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGSize>) {
        guard let size = change.newValue,
              type == .Footer, state == .Idle else {
            return
        }
        let topSafe = scrollView.safeAreaInsets.top
        let bottomSafe = scrollView.safeAreaInsets.bottom
        let top = scrollView.contentInset.top
        let bottom = scrollView.contentInset.bottom
        
        if topSafe + top + size.height + bottom + bottomSafe < scrollView.bounds.height {
            //不够一屏
            topConstraint?.constant = scrollView.bounds.height - topSafe - top
        } else {
            topConstraint?.constant = size.height + bottom + bottomSafe
        }
    }
}


