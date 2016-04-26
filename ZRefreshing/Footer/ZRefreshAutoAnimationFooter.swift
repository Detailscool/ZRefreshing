//
//  ZRefreshAutoAnimationFooter.swift
//
//  Created by ZhangZZZZ on 16/4/1.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshAutoAnimationFooter: ZRefreshAutoStateFooter {
    
    private(set) lazy var  animationView: UIImageView = {
        let animationView = UIImageView()
        animationView.backgroundColor = UIColor.clearColor()
        return animationView
    }()
    
    private var stateImages: [ZRefreshState: [UIImage]] = [:]
    private var stateDurations: [ZRefreshState: NSTimeInterval] = [:]
    
    public func setImages(images: [UIImage], state: ZRefreshState){
        self.setImages(images, duration: Double(images.count) * 0.1, state: state)
    }
    
    public func setImages(images: [UIImage], duration: NSTimeInterval, state: ZRefreshState){
        if images.count == 0 { return }
        
        self.stateImages.updateValue(images, forKey: state)
        self.stateDurations.updateValue(duration, forKey: state)
        if let image = images.first {
            if image.size.height > self.frame.height {
                self.frame.size.height = image.size.height
            }
        }
    }
    
    override public func prepare() {
        super.prepare()
        if self.animationView.superview == nil {
            self.addSubview(self.animationView)
        }
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        if self.animationView.constraints.count > 0 { return }
        self.animationView.frame = self.bounds
        if self.refreshingTitleHidden {
            self.animationView.contentMode = .Center
        } else {
            self.animationView.contentMode = .Right
            self.animationView.frame.size.width = self.frame.width * 0.5 - 90
        }
    }
    
    override public func setRefreshingState(state: ZRefreshState) {
        if self.checkState(state).0 { return }
        super.setRefreshingState(state)
        
        if state == .Refreshing {    
            let images = self.stateImages[state]
            if images?.count == 0 { return }
            self.animationView.stopAnimating()
            self.animationView.hidden = false
            
            if images?.count == 1 {
                self.animationView.image = images?.last
            } else {
                self.animationView.animationImages = images
                self.animationView.animationDuration = self.stateDurations[state] ?? 0.0
                self.animationView.startAnimating()
            }
        } else if state == .NoMoreData || state == .Idle {
            self.animationView.stopAnimating()
            self.animationView.hidden = false
        }
    }
}
