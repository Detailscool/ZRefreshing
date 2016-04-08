//
//  ZRefreshBackStateNormalFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshBackNormalFooter: ZRefreshBackStateFooter {
    
    private(set) lazy var arrowView = UIImageView()
    private lazy var loadingView = UIActivityIndicatorView()
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .Gray {
        didSet {
            self.loadingView.activityIndicatorViewStyle = self.activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    // MARK: - Override
    override public func prepare() {
        super.prepare()
        
        self.arrowView.image = UIImage(named: "ZRefresh.bundle/arrow.png")
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
            self.loadingView.center = arrowCenter;
        }
    }
    
    override public func setRefreshingState(state: ZRefreshState) {
        let result = self.checkState(state)
        if result.0 { return }
        super.setRefreshingState(state)
        
        if state == .Idle {
            if result.1 == .Refreshing {
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
                UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                    self.loadingView.alpha = 0.0
                    }, completion: { (flag) in
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.hidden = false
                })
            } else {
                self.arrowView.hidden = false
                self.loadingView.stopAnimating()
                UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
                    }, completion: { (flag) in
                })
            }
        } else if state == .Pulling {
            self.arrowView.hidden = false
            self.loadingView.stopAnimating()
            UIView.animateWithDuration(ZRefreshing.fastAnimationDuration, animations: {
                self.arrowView.transform = CGAffineTransformIdentity
            })
        } else if state == .Refreshing {
            self.arrowView.hidden = true
            self.loadingView.startAnimating()
        } else if state == .NoMoreData {
            self.arrowView.hidden = true
            self.loadingView.stopAnimating()
        }
    }
}
