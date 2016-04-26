//
//  ZRefreshNormalHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshNormalHeader: ZRefreshStateHeader {
    
    public private(set) lazy var arrowView: UIImageView = {
        let arrowView = UIImageView()
        arrowView.image = ZRefreshing.imageOf("arrow.png")
        return arrowView
    }()
    
    private(set) lazy var activityIndicator : UIActivityIndicatorView = {
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
    
        if self.arrowView.superview == nil {
            self.addSubview(self.arrowView)
        }
        
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
            self.activityIndicator.center = arrowCenter
        }
    }
    
    override public func setRefreshingState(state: ZRefreshState) {
        if self.checkState(state).0 { return }
        super.setRefreshingState(state)
        
        if self.state == .Idle {
            if self.state == .Refreshing {
                self.arrowView.transform = CGAffineTransformIdentity
                UIView.animateWithDuration(ZRefreshing.slowAnimationDuration, animations: {
                    self.activityIndicator.alpha = 0.0
                    }, completion: {(flag) in
                        if self.state != .Idle { return }
                        self.activityIndicator.alpha = 1.0
                        self.activityIndicator.stopAnimating()
                        self.arrowView.hidden = false
                })
            } else {
                self.activityIndicator.stopAnimating()
                self.arrowView.hidden = false
                UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransformIdentity
                })
            }
        } else if self.state == .Pulling {
            self.activityIndicator.stopAnimating()
            self.arrowView.hidden = false
            UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI));
            })
        } else if self.state == .Refreshing {
            self.activityIndicator.alpha = 1.0
            self.activityIndicator.startAnimating()
            self.arrowView.hidden = true
        }
    }
}
