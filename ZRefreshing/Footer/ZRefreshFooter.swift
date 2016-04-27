//
//  ZRefreshFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshFooter: ZRefreshComponent {

    internal var ignoredScrollViewContentInsetBottom: CGFloat = 0.0
    public var automaticallyHidden: Bool = false
    
    // MARK: - Override
    override public func prepare() {
        self.frame.size.height = ZRefreshing.footerHeight
    }

    override public func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview == nil { return }
        super.willMoveToSuperview(newSuperview)
        if self.scrollView == nil { return }
        
        if (self.scrollView!.isKindOfClass(UITableView.classForCoder()) || self.scrollView!.isKindOfClass(UICollectionView.classForCoder())) {
            self.scrollView?.reloadDataClosure = { (value) in
                self.setFooterHidden(value == 0)
            }
        }
    }
    
    // MARK: - Component Control
    public func endRefreshingWithNoMoreData() {
        self.setRefreshingState(.NoMoreData)
    }
    
    public func resetNoMoreData() {
        self.setRefreshingState(.Idle)
    }
    
    // MARK: - SubClass Implemention
    public func setFooterHidden(hidden: Bool) {}
}
