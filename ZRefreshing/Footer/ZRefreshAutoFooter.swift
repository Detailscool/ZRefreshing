//
//  ZRefreshAutoFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshAutoFooter: ZRefreshFooter {

    public var automaticallyRefresh: Bool = true
    private var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    override var state: ZRefreshState {
        get {
            return super.state
        }
        set (newState) {
            if self.isSameStateForNewValue(newState).result { return }
            super.state = newState
            
            if newState == .Refreshing {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self.executeRefreshCallback()
                })
            }
        }/* else if self.state == .NoMoreData && self.automaticallyHidden {
         self.setFooterHidden(true)
         }*/
    }
    
    public override var hidden: Bool {
        get {
            return super.hidden
        }
        set {
            let isHidden = self.hidden;
            super.hidden = newValue
            if !isHidden && hidden {
                self.state = .Idle
                self.scrollView?.contentInset.bottom -= self.frame.height
            } else {
                self.scrollView?.contentInset.bottom += self.frame.height
                self.frame.origin.y = self.scrollView!.contentSize.height
            }
        }
    }
    
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if self.scrollView == nil { return }
        if newSuperview == nil {
            if self.hidden == false {
                self.scrollView?.contentInset.bottom -= self.frame.height
            }
        } else {
            if self.hidden == false {
                self.scrollView?.contentInset.bottom += self.frame.height
            }
            self.frame.origin.y = self.scrollView!.contentSize.height
        }
    }
    
    override public func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentSizeDidChange(change)
        self.frame.origin.y = self.scrollView!.contentSize.height
    }
    
    override public func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        if self.state != .Idle || !self.automaticallyRefresh || self.frame.origin.y == 0 {
            return
        }
        
        if let scrollView = self.scrollView {
            if scrollView.contentInset.top + scrollView.contentSize.height > scrollView.frame.height {
                if scrollView.contentOffset.y >=
                    (scrollView.contentSize.height - scrollView.frame.height +
                        self.frame.height * self.triggerAutomaticallyRefreshPercent +
                        scrollView.contentInset.bottom - self.frame.height) {

                    let old = (change?["old"] as? NSValue)?.CGPointValue()
                    let new = (change?["new"] as? NSValue)?.CGPointValue()
                    if old != nil && new != nil && new!.y > old!.y {
                        self.beginRefreshing()
                    }
                }
            }
        }
    }
    
    override public func scrollViewPanStateDidChange(change: [String : AnyObject]?) {
        super.scrollViewPanStateDidChange(change)
        if self.state != .Idle { return }

        if let scrollView = self.scrollView {
            if scrollView.panGestureRecognizer.state == .Ended {
                if (scrollView.contentInset.top + scrollView.contentSize.height) <= scrollView.frame.height {
                    if scrollView.contentOffset.y >= -scrollView.contentInset.top {
                        self.beginRefreshing()
                    }
                } else {
                    if scrollView.contentOffset.y >= (scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.frame.height) {
                        self.beginRefreshing()
                    }
                }
            }
        }
    }
}
