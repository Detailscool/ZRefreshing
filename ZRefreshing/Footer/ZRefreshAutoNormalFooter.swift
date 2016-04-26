//
//  ZRefreshAutoNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshAutoNormalFooter: ZRefreshAutoStateFooter {

    private(set) lazy var  activityIndicator : UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .Gray {
        didSet {
            self.activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    override public func prepare() {
        super.prepare()
        
        self.activityIndicatorViewStyle = .Gray
        
        self.activityIndicator.hidesWhenStopped = true
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        if self.activityIndicator.constraints.count > 0 { return }
        
        var loadingCenterX = self.frame.width * 0.5;
        if !self.refreshingTitleHidden {
            loadingCenterX -= 100
        }
        let loadingCenterY = self.frame.height * 0.5;
        self.activityIndicator.center = CGPointMake(loadingCenterX, loadingCenterY);
    }
    
    override public func setRefreshingState(state: ZRefreshState) {
        if self.checkState(state).0 { return }
        super.setRefreshingState(state)
        if state == .NoMoreData || state == .Idle {
            self.activityIndicator.stopAnimating()
        } else if state == .Refreshing {
            self.activityIndicator.startAnimating()
        }
    }
}
