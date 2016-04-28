//
//  ZRefreshAutoStateFooter.swift
//
//  Created by ZhangZZZZ on 16/3/31.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshAutoStateFooter: ZRefreshAutoFooter {
    
    public private(set) lazy var stateLabel = ZRefreshingLabel()
    private var stateTitles:[ZRefreshState: String] = [:]
    
    override var state: ZRefreshState {
        get {
            return super.state
        }
        set (newState) {
            if self.isSameStateForNewValue(newState).0 { return }
            super.state = newState
            
            if self.stateLabel.hidden && newState == .Refreshing {
                self.stateLabel.text = nil
            } else {
                self.stateLabel.text = self.stateTitles[newState]
            }
        }
    }
    
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
}
