//
//  ViewController.swift
//  ZRefreshingExample
//
//  Created by ZhangZZZZ on 16/4/7.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit
import ZRefreshing

class ViewController: UITableViewController {

    private var numberOfCell: Int = 0
    private var header: ZRefreshNormalHeader!
//    private var footer: ZRefreshBackNormalFooter!
    private var footer: ZRefreshAutoNormalFooter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")

//        self.tableView.header = ZRefreshNormalHeader(target: self,
//                                                     action: #selector(self.loadData(_:)));
        self.header = ZRefreshNormalHeader({
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.numberOfCell = 20
                self.tableView.header?.endRefreshing()
                self.footer.resetNoMoreData()
                self.tableView.reloadData()
            })
        })
        
        
    
//        self.footer = ZRefreshBackNormalFooter(target: self,
//                                               action: #selector(self.loadMoreData(_:)));
//        self.footer = ZRefreshBackNormalFooter({
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
//                self.numberOfCell += 20
//                if self.numberOfCell >= 40 {
//                    self.tableView.footer?.endRefreshingWithNoMoreData()
//                } else {
//                    self.tableView.footer?.endRefreshing()
//                }
//                self.tableView.reloadData()
//            })
//        })
        self.footer = ZRefreshAutoNormalFooter(target: self,
                                               action: #selector(self.loadMoreData(_:)))
        
//        self.footer = ZRefreshAutoNormalFooter({
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
//                self.numberOfCell += 20
//                if self.numberOfCell >= 40 {
//                    self.tableView.footer?.endRefreshingWithNoMoreData()
//                } else {
//                    self.tableView.footer?.endRefreshing()
//                }
//                self.tableView.reloadData()
//            })
//        })
//        self.footer.stateLabel.hidden = true
        self.footer.automaticallyHidden = true
        self.footer.pageSize = 20
        self.header.lastUpdatedTimeKey = "custome key"
//        self.tableView.header?.ignoredScrollViewContentInsetTop = 30
        self.header.stateLabelHidden = true
        self.footer.stateLabelHidden = true
        self.header.activityIndicatorViewStyle = .WhiteLarge
        self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 30, 0)
        self.footer.ignoredScrollViewContentInsetBottom = 30
        self.footer.automaticallyRefresh = false
        self.tableView.header = header
        self.tableView.header?.beginRefreshing()
        self.tableView.footer = footer
    }

    func loadData(componet: ZRefreshComponent) {
        if componet.isKindOfClass(ZRefreshHeader.classForCoder()) {
            componet.endRefreshing()
        } else if componet.isKindOfClass(ZRefreshFooter.classForCoder()) {
            componet.endRefreshing()
        }
    }
    
    func loadMoreData(componet: ZRefreshComponent) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.numberOfCell += 20
            if self.numberOfCell >= 40 {
                self.tableView.footer?.endRefreshingWithNoMoreData()
            } else {
                self.tableView.footer?.endRefreshing()
            }
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = String(format: "%zd", indexPath.row)
        return cell!
    }
}

