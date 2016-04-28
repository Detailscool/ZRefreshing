//
//  Constrants.swift

//
//  Created by ZhangZZZZ on 16/3/28.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

struct ZRefreshing {
    
    static let headerHeight: CGFloat = 54.0
    static let footerHeight: CGFloat = 44.0
    static let fastAnimationDuration: NSTimeInterval = 0.25
    static let slowAnimationDuration: NSTimeInterval = 0.4
    static let labelFont: UIFont = UIFont.systemFontOfSize(14.0)
    static let labelTextColor: UIColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
    
    static var keyPathContentOffset = "contentOffset"
    static var keyPathContentInset = "contentInset"
    static var keyPathContentSize = "contentSize"
    static var keyPathPanState = "state"
    
    static let headerLastUpdatedTimeKey = "com.zevwings.lastupdatedtime"
    
    static let headerIdleText = "下拉可以刷新"
    static let headerPullingText = "松开立即刷新"
    static let headerRefreshingText = "正在刷新数据中..."
    
    static let autoFooterIdleText = "点击或上拉加载更多"
    static let autoFooterRefreshingText = "正在加载更多的数据..."
    static let autoFooterNoMoreDataText = "已经全部加载完毕"
    
    static let backFooterIdleText = "上拉可以加载更多"
    static let backFooterPullingText = "松开立即加载更多"
    static let backFooterRefreshingText = "正在加载更多的数据..."
    static let backFooterNoMoreDataText = "已经全部加载完毕"
    static func imageOf(name: String) -> UIImage? {

        let manualSoure = "ZRefreshing.bundle".stringByAppendingFormat("%@", name)
        let frameworkSoure = NSBundle(forClass: ZRefreshComponent.self).bundlePath.stringByAppendingFormat("/ZRefreshing.bundle/%@", name)
        
        let image = UIImage(named: manualSoure) == nil ? UIImage(named: frameworkSoure) : UIImage(named: manualSoure)
        return image
    }
}

public enum ZRefreshState {
    case Idle
    case Pulling
    case Refreshing
    case WillRefresh
    case NoMoreData
    
    internal func toString() -> String {
        switch self {
        case .Idle:
            return ".Idle"
        case .Pulling:
            return ".Pulling"
        case .Refreshing:
            return ".Refreshing"
        case .WillRefresh:
            return ".WillRefresh"
        case .NoMoreData:
            return ".NoMoreData"
        }
    }
    
    internal static func fromString(state: String) -> ZRefreshState {
        switch state {
        case ".Idle":
            return .Idle
        case ".Pulling":
            return .Pulling
        case ".Refreshing":
            return .Refreshing
        case ".WillRefresh":
            return .WillRefresh
        case ".NoMoreData":
            return .NoMoreData
        default:
            return .Idle
        }
    }
}

public typealias ZRefreshClosure = () -> ()
internal typealias ZReloadDataClosure = @convention(block) (value: Int) -> ()
internal typealias ZRefreshCheckStateResutlt = (result: Bool, state: ZRefreshState)