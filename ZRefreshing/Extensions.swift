//
//  Extensions.swift
//  Refresh
//
//  Created by ZhangZZZZ on 16/3/30.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

public class ZRefreshingLabel: UILabel {
    internal init() {
        super.init(frame: CGRectZero);
        self.font = ZRefreshing.labelFont
        self.textColor = ZRefreshing.labelTextColor
        self.autoresizingMask = .FlexibleWidth
        self.textAlignment = .Center
        self.backgroundColor = UIColor.clearColor()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private var headerAssociationKey: UInt8 = 0
private var footerAssociationKey: UInt8 = 0
private var reloadDataClosureKey: UInt8 = 0

public extension UIScrollView {
    
    public var header: ZRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &headerAssociationKey) as? ZRefreshHeader
        }
        set {
            if (self.header != newValue) {
                self.header?.removeFromSuperview()
                if newValue != nil { self.insertSubview(newValue!, atIndex: 0) }
                self.willChangeValueForKey("com.zevwings.value.header")
                objc_setAssociatedObject(self, &headerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValueForKey("com.zevwings.value.header")
            }
        }
    }
    
    public var footer: ZRefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &footerAssociationKey) as? ZRefreshFooter
        }
        set {
            if (self.footer != newValue) {
                self.footer?.removeFromSuperview()
                if newValue != nil { self.insertSubview(newValue!, atIndex: 0) }
                self.willChangeValueForKey("com.zevwings.value.footer")
                objc_setAssociatedObject(self, &footerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValueForKey("com.zevwings.value.footer")
            }
        }
    }
    
    var totalDataCount: Int {
        get {
            var totalCount: Int = 0
            if self.isKindOfClass(UITableView.classForCoder()) {
                let tableView = self as? UITableView
                for section in 0 ..< tableView!.numberOfSections {
                    totalCount += tableView!.numberOfRowsInSection(section)
                }
            } else if self.isKindOfClass(UICollectionView.classForCoder()) {
                let collectionView = self as? UICollectionView
                
                for section in 0 ..< collectionView!.numberOfSections()  {
                    totalCount += collectionView!.numberOfItemsInSection(section)
                }
            }
            return totalCount
        }
    }
    
    internal var reloadDataClosure: ZReloadDataClosure? {
        get {
            let value = objc_getAssociatedObject(self, &reloadDataClosureKey)
            let closure = unsafeBitCast(value, ZReloadDataClosure.self)
            return closure
        }
        set {
            var value: AnyObject? = nil
            if newValue != nil {
                value = unsafeBitCast(
                    newValue,
                    AnyObject.self
                )
            }
            objc_setAssociatedObject(self, &reloadDataClosureKey, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    func executeReloadDataBlock() {
        self.reloadDataClosure?(value: self.totalDataCount)
    }
}

extension UITableView {
    
    override public class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UITableView.self {
            return
        }
        
        dispatch_once(&Static.token) {
            self.exchangeInstanceMethod(m1: #selector(UITableView.reloadData),
                                        m2: #selector(UITableView.refreshReloadData))
        }
    }

    func refreshReloadData() {
        self.refreshReloadData()
        self.executeReloadDataBlock()
    }
}

extension UICollectionView {
    
    override public class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UICollectionView.self {
            return
        }
        
        dispatch_once(&Static.token) {
            self.exchangeClassMethod(m1: #selector(UICollectionView.reloadData),
                                     m2: #selector(UICollectionView.refreshReloadData))
        }
    }
    
    func refreshReloadData() {
        self.refreshReloadData()
        self.executeReloadDataBlock()
    }
}

extension NSObject {
    
    class func exchangeInstanceMethod(m1 m1: Selector, m2: Selector) {
        
        let method1 = class_getInstanceMethod(self, m1)
        let method2 = class_getInstanceMethod(self, m2)
        
        let didAddMethod = class_addMethod(self, m1, method_getImplementation(method2), method_getTypeEncoding(method2))
        
        if didAddMethod {
            class_replaceMethod(self, m2, method_getImplementation(method1), method_getTypeEncoding(method1))
        } else {
            method_exchangeImplementations(method1, method2);
        }
    }
    
    class func exchangeClassMethod(m1 m1: Selector, m2: Selector) {
        
        let method1 = class_getClassMethod(self, m1)
        let method2 = class_getClassMethod(self, m2)
        let didAddMethod = class_addMethod(self, m1, method_getImplementation(method2), method_getTypeEncoding(method2))
        
        if didAddMethod {
            class_replaceMethod(self, m2, method_getImplementation(method1), method_getTypeEncoding(method1))
        } else {
            method_exchangeImplementations(method1, method2);
        }
    }
}
