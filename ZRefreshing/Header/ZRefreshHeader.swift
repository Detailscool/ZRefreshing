//
//  ZRefreshHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshHeader: ZRefreshComponent {
    
    private var lastUpdatedTime: NSDate? {
        return NSUserDefaults.standardUserDefaults().objectForKey(self.lastUpdatedTimeKey) as? NSDate
    }
    
    public var lastUpdatedTimeKey: String = ZRefreshing.headerLastUpdatedTimeKey
    private var insetTDelta: CGFloat = 0.0
    private var ignoredScrollViewContentInsetTop: CGFloat = 0.0

    override public func prepare() {
        super.prepare()
        self.lastUpdatedTimeKey = ZRefreshing.headerLastUpdatedTimeKey
        self.frame.size.height = ZRefreshing.headerHeight
    }

    override public func placeSubViews() {
        super.placeSubViews()
        self.frame.origin.y = -self.frame.height - self.ignoredScrollViewContentInsetTop
    }

    override public func setState(state: ZRefreshState) {
        let result = self.checkState(state)
        if result.0 { return }
        
        super.setState(state)
        
        if (self.state == .Idle) {
            if result.1 != .Refreshing { return }
            
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: self.lastUpdatedTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            UIView.animateWithDuration(ZRefreshing.slowAnimationDuration, animations: {
                self.scrollView?.contentInset.top += self.insetTDelta
                if self.automaticallyChangeAlpha {
                    self.alpha = 0.0
                }
            }, completion: { (complection) in
                self.pullingPercent = 0.0
            })
        } else if (state == .Refreshing) {
            UIView.animateWithDuration(ZRefreshing.slowAnimationDuration, animations: {
                let top = self.scrollViewOriginalInset.top + self.frame.height
                self.scrollView?.contentInset.top = top
                self.scrollView?.contentOffset.y = -top
            }, completion: { (completion) in
                self.executeRefreshCallback()
            })
        }
    }

    override public func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)

        if self.scrollView == nil { return }
        
        if self.state == .Refreshing {
            if self.window == nil { return }
            
            var insetT =
                -self.scrollView!.contentOffset.y > self.scrollViewOriginalInset.top ?
                -self.scrollView!.contentOffset.y :
                self.scrollViewOriginalInset.top
            
            insetT = insetT >
                self.frame.height + self.scrollViewOriginalInset.top ?
                self.frame.height + self.scrollViewOriginalInset.top :
                insetT
            
            self.scrollView?.contentInset.top = insetT
            self.insetTDelta = self.scrollViewOriginalInset.top - insetT
            
            return
        }
        
        self.scrollViewOriginalInset = self.scrollView!.contentInset

        let offsetY = self.scrollView!.contentOffset.y
        let happenOffsetY = -self.scrollViewOriginalInset.top

        if offsetY > happenOffsetY { return }

        let normal2pullingOffsetY = happenOffsetY - self.frame.height
        let pullingPercent = (happenOffsetY - offsetY) / self.frame.height
        
        if self.scrollView!.dragging {
            self.pullingPercent = pullingPercent
            if self.state == .Idle && offsetY < normal2pullingOffsetY {
                self.setState(.Pulling)
            } else if self.state == .Pulling && offsetY >= normal2pullingOffsetY {
                self.setState(.Idle)
            }
        } else if self.state == .Pulling {
            self.beginRefreshing()
        }else if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent;
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
}
