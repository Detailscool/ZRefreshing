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

    private var numberOfCell: Int = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
//        self.tableView.header = ZRefreshNormalHeader(target: self, action: #selector(self.loadData(_:)));
        let header = ZRefreshNormalHeader(refreshClosure: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.tableView.header?.endRefreshing()
            })
        })
//        header.stateLabel.hidden = true
//        header.lastUpdatedTimeLabel.hidden = true
//        self.tableView.header = header
//
//        self.tableView.footer = ZRefreshBackFooter(target: self, action: #selector(self.loadData(_:)));
        let footer = ZRefreshAutoNormalFooter(refreshClosure: {
            self.tableView.footer?.endRefreshingWithNoMoreData()
        })
        
        footer.refreshingTitleHidden = true

        self.tableView.footer = footer
//
//        self.tableView.header?.beginRefreshing()
    }

    func loadData(componet: ZRefreshComponent) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = String(format: "%zd", indexPath.row)
        return cell!
    }
}

