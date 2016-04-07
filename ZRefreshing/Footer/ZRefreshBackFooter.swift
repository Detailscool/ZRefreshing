//
//  ZRefreshBackFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshBackFooter: ZRefreshFooter {
    private var lastBottomDelta: CGFloat = 0.0
    private var lastRefreshCount: Int = 0
    
    // MARK: - Override
    override public func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        if self.state == .Refreshing { return }
        if self.scrollView == nil { return }
        
        self.scrollViewOriginalInset = self.scrollView!.contentInset
        let currentOffsetY = self.scrollView!.contentOffset.y
        let happenOffsetY = self.happenOffsetY()
        if currentOffsetY <= happenOffsetY { return }
     
        let pullingPercent = (currentOffsetY - happenOffsetY) / self.frame.height
        
        if (self.state == .NoMoreData) {
            self.pullingPercent = pullingPercent
            return
        }
        
        if self.scrollView!.dragging {
            self.pullingPercent = pullingPercent
            let normal2pullingOffsetY = happenOffsetY + self.frame.height
            if self.state == .Idle && currentOffsetY > normal2pullingOffsetY {
                self.setState(.Pulling)
            } else if self.state == .Pulling && currentOffsetY <= normal2pullingOffsetY {
                self.setState(.Idle)
            }
        } else if (self.state == .Pulling) {
            self.beginRefreshing()
        } else if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent
        }
        
    }

    override public func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentSizeDidChange(change)
        
        let contentHeight = self.scrollView!.contentSize.height + self.ignoredScrollViewContentInsetBottom
        let scrollHeight = self.scrollView!.frame.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom
        
        self.frame.origin.y = max(contentHeight, scrollHeight)
    }
    
    override public func setState(state: ZRefreshState) {
        if self.scrollView == nil { return }
        
        let result = self.checkState(state)
        if result.0 { return }
        
        super.setState(state)
        
        if state == .NoMoreData || state == .Idle {
            
            if .Refreshing == result.1 {
                UIView.animateWithDuration(ZRefreshing.slowAnimationDuration, animations: {
                    self.scrollView!.contentInset.bottom -= self.lastBottomDelta
                    if self.automaticallyChangeAlpha {self.alpha = 0.0}
                    }, completion: { (flag: Bool) in
                        self.pullingPercent = 0.0
                })
            }
            let deltaH: CGFloat = self.heightForContentBreakView()
            if .Refreshing == result.1 && deltaH > CGFloat(0.0) && self.scrollView!.totalDataCount != self.lastRefreshCount{
                self.scrollView!.contentOffset.y = self.scrollView!.contentOffset.y
            }
        } else if state == .Refreshing{
            
            self.lastRefreshCount = self.scrollView!.totalDataCount
            UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                var bottom = self.frame.height + self.scrollViewOriginalInset.bottom
                let deltaH = self.heightForContentBreakView()
                if deltaH < 0 {
                    bottom -= deltaH
                }
                self.lastBottomDelta = bottom - self.scrollView!.contentInset.bottom
                self.scrollView?.contentInset.bottom = bottom;
                self.scrollView?.contentOffset.y = self.happenOffsetY() + self.frame.height
                }, completion: { (flag) in
                    self.executeRefreshCallback()
            })
        }
    }
    
    override public func endRefreshing() {
        if let scrollView = self.scrollView {
            
            if scrollView.isKindOfClass(UICollectionView.classForCoder()) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1)), dispatch_get_main_queue(), {
                    super.endRefreshing()
                })
            } else {
                super.endRefreshing()
            }
        }
    }

    override public func endRefreshingWithNoMoreData() {
        if let scrollView = self.scrollView {
            
            if scrollView.isKindOfClass(UICollectionView.classForCoder()) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1)), dispatch_get_main_queue(), {
                    super.endRefreshingWithNoMoreData()
                })
            } else {
                super.endRefreshingWithNoMoreData()
            }
        }
    }
    
    // MARK: - Private
    private func heightForContentBreakView() -> CGFloat {
        let h = self.scrollView!.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top
        let height = self.scrollView!.contentSize.height - h
        return height
    }
    
    private func happenOffsetY() -> CGFloat {
        let deletaH = self.heightForContentBreakView()
        if deletaH > 0 {
            return deletaH - self.scrollViewOriginalInset.top
        } else {
            return -self.scrollViewOriginalInset.top
        }
    }
}
