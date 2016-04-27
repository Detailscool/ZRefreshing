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
    
    override public func setRefreshingState(state: ZRefreshState) {
        if self.checkState(state).0 { return }
        super.setRefreshingState(state)
        
        if self.state == .Refreshing {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { 
                self.executeRefreshCallback()
            })
        }
    }
    
    override public func setFooterHidden(hidden: Bool) {
        let isHidden = self.hidden
        
        print("is Hidden : \(isHidden)")
        print("hidden : \(hidden)")
        self.hidden = hidden

        if !isHidden && hidden {
            self.setRefreshingState(.Idle)
            self.scrollView?.contentInset.bottom -= self.frame.height
        } else if (isHidden && !hidden) {
            self.scrollView?.contentInset.bottom += self.frame.height
            self.frame.origin.y = self.scrollView!.contentSize.height
        }
    }
}
