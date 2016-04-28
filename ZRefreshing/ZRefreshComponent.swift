//
//  ZRefreshComponent.swift
//
//  Created by ZhangZZZZ on 16/3/29.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

private var stateAssocaiationkey = "com.zero.refreshing.storage.state"
public class ZRefreshComponent: UIView {
    
    private var pan: UIPanGestureRecognizer?
    private var target: AnyObject?
    private var action: Selector?
    private var refreshClosure: ZRefreshClosure?
    
    internal var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsetsZero
    internal var scrollView: UIScrollView?
    
    internal var state: ZRefreshState {
        get {
            let stateString = objc_getAssociatedObject(self, &stateAssocaiationkey) as? String
            let state = ZRefreshState.fromString(stateString ?? "")
            return state
        }
        set {
            if self.isSameStateForNewValue(newValue).result { return }
            objc_setAssociatedObject(self,
                                     &stateAssocaiationkey,
                                     newValue.toString(),
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var automaticallyChangeAlpha: Bool = false {
        didSet {
            if self.isRefreshing { return }
            
            if self.automaticallyChangeAlpha {
                self.alpha = self.pullingPercent;
            } else {
                self.alpha = 1.0;
            }
        }
    }
    
    internal var pullingPercent: CGFloat = 0.0 {
        didSet {
            if self.isRefreshing { return }
            if self.automaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }

    public var isRefreshing: Bool {
        return (self.state == .Refreshing || self.state == .WillRefresh)
    }
    
    //MARK: - public initialized
    public required init(_ refreshClosure: ZRefreshClosure) {
        super.init(frame: CGRectZero)
        self.refreshClosure = refreshClosure
        self.prepare()
    }
    
    public required init(target: AnyObject?, action: Selector?) {
        super.init(frame: CGRectZero)
        self.target = target
        self.action = action
        
        self.prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Component Control
    public func beginRefreshing() {
        
        UIView.animateWithDuration(ZRefreshing.fastAnimationDuration) {
            self.alpha = 1.0
        }
        
        self.pullingPercent = 1.0
        
        if self.window != nil {
            self.state = .Refreshing
        } else {
            if self.state != .Refreshing {
                self.state = .WillRefresh
                self.setNeedsDisplay()
            }
        }
    }
    
    public func endRefreshing() {
        self.state = .Idle
    }
    
    // check the new state is the same to old value or not
    internal func isSameStateForNewValue(state: ZRefreshState) -> ZRefreshCheckStateResutlt {
        if self.state == state {
            return (result: true, state: self.state)
        }
        return (result: false, state: self.state)
    }
    
    //MARK: - Override Super Class Methods
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if newSuperview == nil || !newSuperview!.isKindOfClass(UIScrollView.classForCoder()) {
            return
        }
        
        self.removeObservers()
        
        if let scrollView = newSuperview as? UIScrollView {
            
            self.frame.size.width = scrollView.frame.width
            self.frame.origin.x = 0
            
            self.scrollView = scrollView
            self.scrollView?.alwaysBounceVertical = true
            self.scrollViewOriginalInset = scrollView.contentInset
            self.addObservers()
            
            self.backgroundColor = scrollView.backgroundColor
        }
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !self.userInteractionEnabled {
            return
        }
        
        if keyPath == ZRefreshing.keyPathContentSize {
            self.scrollViewContentSizeDidChange(change)
        }
        
        if self.hidden { return }
        
        if keyPath == ZRefreshing.keyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change)
        } else if keyPath == ZRefreshing.keyPathPanState {
            self.scrollViewPanStateDidChange(change)
        }
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.state == .WillRefresh {
            self.state = .Refreshing
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubViews()
    }
    
    // MARK: - Internal and Private Classes
    internal func executeRefreshCallback() {
        dispatch_async(dispatch_get_main_queue()) {
            self.refreshClosure?()
            if self.target != nil && self.action != nil {
                if !self.target!.respondsToSelector(self.action!) { return }
                self.target!.performSelector(self.action!, withObject: self)
            }
        }
    }

    private func addObservers() {
        let options: NSKeyValueObservingOptions = [.New, .Old]
        self.scrollView?.addObserver(self,
                                     forKeyPath: ZRefreshing.keyPathContentOffset,
                                     options: options, context: nil)
        
        self.scrollView?.addObserver(self,
                                     forKeyPath: ZRefreshing.keyPathContentSize,
                                     options: options, context: nil)
        
        self.pan = self.scrollView!.panGestureRecognizer
        self.pan?.addObserver(self,
                              forKeyPath: ZRefreshing.keyPathPanState,
                              options: options, context: nil)
    }
    
    private func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: ZRefreshing.keyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: ZRefreshing.keyPathContentSize)
        self.superview?.removeObserver(self, forKeyPath: ZRefreshing.keyPathPanState)
        self.pan = nil
    }
    
    // MARK: - SubClass Implementation
    public func prepare() {
        self.autoresizingMask = .FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
    }
    
    public func placeSubViews() {}
    public func scrollViewContentOffsetDidChange(change: [String: AnyObject]?) {}
    public func scrollViewContentSizeDidChange(change: [String: AnyObject]?) {}
    public func scrollViewPanStateDidChange(change: [String: AnyObject]?) {}
    
    
}
