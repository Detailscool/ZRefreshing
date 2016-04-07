//
//  ZRefreshAutoStateFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshAutoStateFooter: ZRefreshAutoFooter {
    
    public var refreshingTitleHidden: Bool = false
    private(set) lazy var stateLabel = ZRefreshingLabel()
    private var stateTitles:[ZRefreshState: String] = [:]

    public func setTitle(title: String?, forState state: ZRefreshState) {
        if title == nil {return}
        self.stateTitles.updateValue(title!, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
    internal func stateLabelClicked() {
        if self.state == .Idle {
            self.beginRefreshing()
        }
    }
    
    override public func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        self.setTitle(ZRefreshing.autoFooterIdleText , forState: .Idle)
        self.setTitle(ZRefreshing.autoFooterRefreshingText, forState: .Refreshing)
        self.setTitle(ZRefreshing.autoFooterNoMoreDataText, forState: .NoMoreData)

        self.stateLabel.userInteractionEnabled = true;
        self.stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ZRefreshAutoStateFooter.stateLabelClicked)))
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        if self.stateLabel.constraints.count > 0 { return }
        self.stateLabel.frame = self.bounds;
    }
    
    override public func setState(state: ZRefreshState) {
        if self.checkState(state).0 { return }
        super.setState(state)
        
        if self.refreshingTitleHidden && state == .Refreshing {
            self.stateLabel.text = nil
        } else {
            self.stateLabel.text = self.stateTitles[state]
        }
    }
}
