//
//  ZRefreshFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshFooter: ZRefreshComponent {

    public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0
    public var automaticallyHidden: Bool = false
    public var pageSize: Int = 0
    public var stateLabelHidden: Bool = false
    override public func prepare() {
        self.frame.size.height = ZRefreshing.footerHeight
    }

    override public func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview == nil { return }
        super.willMoveToSuperview(newSuperview)
        if self.scrollView == nil { return }
        
        if  self.scrollView!.isKindOfClass(UITableView.classForCoder()) ||
            self.scrollView!.isKindOfClass(UICollectionView.classForCoder()) {
            self.scrollView?.reloadDataClosure = { (value) in
                if self.automaticallyHidden {
                    if self.state == .NoMoreData {
                        self.hidden = true
                    } else {
                        // if you number of rows less than page size hidden this footer
                        self.hidden = (self.pageSize > 0 ? value < self.pageSize : value == 0)
                    }
                }
            }
        }
    }
    
    // MARK: - Component Control
    public func endRefreshingWithNoMoreData() {
        self.state = .NoMoreData
    }
    
    public func resetNoMoreData() {
        self.state = .Idle
    }
}
