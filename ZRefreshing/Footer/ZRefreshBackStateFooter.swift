//
//  ZRefreshBackStateFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshBackStateFooter: ZRefreshBackFooter {
    
    private(set) lazy var stateLabel = ZRefreshingLabel()
    private var stateTitles:[ZRefreshState: String] = [:]
    
    public override var stateLabelHidden: Bool {
        didSet {
            self.stateLabel.hidden = true
        }
    }
    
    override var state: ZRefreshState {
        get {
            return super.state
        }
        set (newState) {
            
            if self.isSameStateForNewValue(newState).result { return }
            super.state = newState
            self.stateLabel.text = self.stateTitles[newState]
        }
    }
    
    public func setTitle(title: String?, forState state: ZRefreshState) {
        if title == nil {return}
        self.stateTitles.updateValue(title!, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }

    private func titleForState(state: ZRefreshState) -> String? {
        return self.stateTitles[state]
    }
    
    override public func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        self.setTitle(ZRefreshing.backFooterIdleText, forState: .Idle)
        self.setTitle(ZRefreshing.backFooterPullingText, forState: .Pulling)
        self.setTitle(ZRefreshing.backFooterRefreshingText, forState: .Refreshing)
        self.setTitle(ZRefreshing.backFooterNoMoreDataText, forState: .NoMoreData)
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        if self.stateLabel.constraints.count > 0 { return }
        self.stateLabel.frame = self.bounds;
    }
}
