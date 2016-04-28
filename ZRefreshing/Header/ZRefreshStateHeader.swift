
//
//  ZRefreshStateHeader.swift
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshStateHeader: ZRefreshHeader {

    private(set) lazy var lastUpdatedTimeLabel = ZRefreshingLabel()
    private(set) lazy var stateLabel = ZRefreshingLabel()
    
    private var stateTitles: [ZRefreshState : String] = [:]
    private var currentCalendar: NSCalendar? = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    private var lastUpdatedTimeText:((date: NSDate?)->(String))?
    
    public var lastUpdatedTimeLabelHidden: Bool = false {
        didSet {
            self.lastUpdatedTimeLabel.hidden = self.lastUpdatedTimeLabelHidden
        }
    }
    public var stateLabelHidden: Bool = false {
        didSet {
            self.stateLabel.hidden = self.stateLabelHidden
        }
    }
    
    override var state: ZRefreshState {
        get {
            return super.state
        }
        
        set (newState) {
            if self.isSameStateForNewValue(newState).result { return }
            super.state = newState
            self.stateLabel.text = self.stateTitles[self.state];
            
            // call lastUpdatedTimeKey set function
            let key = self.lastUpdatedTimeKey
            self.lastUpdatedTimeKey = key
        }
    }
    
    public override var lastUpdatedTimeKey: String {
        didSet {
            let lastUpdatedTime = NSUserDefaults.standardUserDefaults().objectForKey(self.lastUpdatedTimeKey) as? NSDate
            if self.lastUpdatedTimeText != nil {
                self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText?(date: lastUpdatedTime)
                return
            }
            if lastUpdatedTime != nil {
                let unitFlags : NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second]
                let cmp1 = self.currentCalendar?.components(unitFlags, fromDate: lastUpdatedTime!)
                let cmp2 = self.currentCalendar?.components(unitFlags, fromDate: NSDate())
                let formatter = NSDateFormatter()
                if cmp1!.day == cmp2!.day {
                    formatter.dateFormat = "今天 HH:mm"
                } else if cmp1!.year == cmp2!.year {
                    formatter.dateFormat = "MM-dd HH:mm"
                } else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                let timeString = formatter.stringFromDate(lastUpdatedTime!)
                self.lastUpdatedTimeLabel.text = String(format: "最后更新：%@", timeString)
            } else {
                self.lastUpdatedTimeLabel.text = "最后更新：无记录"
            }
        }
    }
    
    public func setTitle(title: String?, forState state: ZRefreshState) {
        if title == nil {return}
        self.stateTitles.updateValue(title!, forKey: state)
        self.stateLabel.text = self.stateTitles[self.state]
    }
    
    override public func prepare() {
        super.prepare()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }
        
        self.setTitle(ZRefreshing.headerIdleText, forState: .Idle)
        self.setTitle(ZRefreshing.headerPullingText, forState: .Pulling)
        self.setTitle(ZRefreshing.headerRefreshingText, forState: .Refreshing)
    }
    
    override public func placeSubViews() {
        super.placeSubViews()
        
        if self.stateLabel.superview == nil {
            self.addSubview(self.stateLabel)
        }

        if self.lastUpdatedTimeLabel.superview == nil {
            self.addSubview(lastUpdatedTimeLabel)
        }

        if self.stateLabel.hidden { return }
        
        let noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0

        if self.lastUpdatedTimeLabel.hidden {
            if noConstrainsOnStatusLabel { self.stateLabel.frame = self.bounds }
        } else {
            let statusLabelH = self.frame.height * 0.5
            self.stateLabel.frame.origin.x = 0
            self.stateLabel.frame.origin.y = 0
            self.stateLabel.frame.size.width = self.frame.width
            self.stateLabel.frame.size.height = statusLabelH
            if self.lastUpdatedTimeLabel.constraints.count == 0 {
                
                self.lastUpdatedTimeLabel.frame.origin.x = 0
                self.lastUpdatedTimeLabel.frame.origin.y = statusLabelH
                self.lastUpdatedTimeLabel.frame.size.width = self.frame.width
                self.lastUpdatedTimeLabel.frame.size.height = self.frame.height - self.lastUpdatedTimeLabel.frame.origin.y;
            }
        }
    }
}
