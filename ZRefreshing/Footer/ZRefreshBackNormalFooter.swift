//
//  ZRefreshBackStateNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshBackNormalFooter: ZRefreshBackStateFooter {
    
    private(set) lazy var arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = ZRefreshing.imageOf("arrow.png")
        return arrowView
    }()
    
    private lazy var activityIndicator : UIActivityIndicatorView = {
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
    
    override var state: ZRefreshState {
        get {
            return super.state
        }
        set {
            let result = self.isSameStateForNewValue(newValue)
            if result.0 { return }
            super.state = newValue
            
            if newValue == .Idle {
                if result.1 == .Refreshing {
                    self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
                    UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                        self.activityIndicator.alpha = 0.0
                        }, completion: { (flag) in
                            self.activityIndicator.alpha = 1.0
                            self.activityIndicator.stopAnimating()
                            self.arrowView.hidden = false
                    })
                } else {
                    self.arrowView.hidden = false
                    self.activityIndicator.stopAnimating()
                    UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                        self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
                        }, completion: { (flag) in
                    })
                }
            } else if newValue == .Pulling {
                self.arrowView.hidden = false
                self.activityIndicator.stopAnimating()
                UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransformIdentity
                })
            } else if newValue == .Refreshing {
                self.arrowView.hidden = true
                self.activityIndicator.startAnimating()
            } else if newValue == .NoMoreData {
                self.arrowView.hidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Override
    override public func prepare() {
        super.prepare()
        
        if self.arrowView.superview == nil {
            self.addSubview(self.arrowView)
        }
        
        self.activityIndicator.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        self.activityIndicator.hidesWhenStopped = true
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()

        var arrowCenterX = self.frame.width * 0.5
        if (!self.stateLabel.hidden) {
            arrowCenterX -= 100
        }
        let arrowCenterY = self.frame.height * 0.5
        let arrowCenter = CGPointMake(arrowCenterX, arrowCenterY)
        
        if (self.arrowView.constraints.count == 0 && self.arrowView.image != nil) {
            self.arrowView.hidden = false
            var rect = self.arrowView.frame
            rect.size = self.arrowView.image!.size
            self.arrowView.frame = rect
            self.arrowView.center = arrowCenter
        } else {
            self.arrowView.hidden = true
        }
        
        if (self.activityIndicator.constraints.count == 0) {
            self.activityIndicator.center = arrowCenter;
        }
    }
}
