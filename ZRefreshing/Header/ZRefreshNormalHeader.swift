//
//  ZRefreshNormalHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshNormalHeader: ZRefreshStateHeader {
    
    private(set) lazy var arrowView = UIImageView()
    private(set) lazy var loadingView = UIActivityIndicatorView()
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .Gray {
        didSet {
            self.loadingView.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    override public func prepare() {
        super.prepare()
    
        self.arrowView.image = ZRefreshing.imageOf("arrow.png")
        if self.arrowView.superview == nil {
            self.addSubview(self.arrowView)
        }
        
        self.loadingView.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        self.loadingView.hidesWhenStopped = true
        if self.loadingView.superview == nil {
            self.addSubview(self.loadingView)
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
        
        if (self.loadingView.constraints.count == 0) {
            self.loadingView.center = arrowCenter
        }
    }
    
    override public func setRefreshingState(state: ZRefreshState) {
        if self.checkState(state).0 { return }
        super.setRefreshingState(state)
        
        if self.state == .Idle {
            if self.state == .Refreshing {
                self.arrowView.transform = CGAffineTransformIdentity
                UIView.animateWithDuration(ZRefreshing.slowAnimationDuration, animations: {
                    self.loadingView.alpha = 0.0
                    }, completion: {(flag) in
                        if self.state != .Idle { return }
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.hidden = false
                })
            } else {
                self.loadingView.stopAnimating()
                self.arrowView.hidden = false
                UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransformIdentity
                })
            }
        } else if self.state == .Pulling {
            self.loadingView.stopAnimating()
            self.arrowView.hidden = false
            UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI));
            })
        } else if self.state == .Refreshing {
            self.loadingView.alpha = 1.0
            self.loadingView.startAnimating()
            self.arrowView.hidden = true
        }
    }
}
