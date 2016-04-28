# ZRefreshing

ZRefreshing is a simple Refreshing Control for swift.

# Installation
## CocoaPods
<CocoaPods.org> is a dependency manager for Cocoa Projects.
``` bash 
use_frameworks!

pod 'ZRefreshing', '~> 1.1’
``` 

then
``` bash 
run pod install 
```

## Manual

``` bash 
1. Download this project, And drag ZRefreshing.xcodeproj to your own project.
2. In your target’s General tab, click the ’+’ button under Linked Frameworks and Libraries.
3. Select the ZRefreshing.framework to Add to your platform. 
```

# Usage 
## Header

##### 1.  add header into your tableView
``` bash
var header = ZRefreshNormalHeader(target: self, action: #selector(self.loadData(_:)))
var header = ZRefreshNormalHeader({
})
self.tableView.header = header
```

##### 2.  start refreshing
``` bash
self.tableView.header?.beginRefreshing()
```
##### 3.  stop refreshing
``` bash
self.tableView.header?.endRefreshing()
```
##### 4.  hidden the last update label 
``` bash 
header.lastUpdatedTimeLabelHidden = true
```
##### 5.  hidden the state label 
``` bash
header.stateLabelHidden = true
```
##### 6.  store the time with the custom key 
``` bash
header.lastUpdatedTimeKey = "custom key"
```
##### 7.  when you set a contentInset, you need set a ignored height
``` bash
self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
header?.ignoredScrollViewContentInsetTop = 30
```
##### 8.  also, you can set the indicator style
``` bash 
self.header.activityIndicatorViewStyle = .WhiteLarge
```
<br /> <br />
## Footer
##### 1.  add auto footer into your tableView 
``` bash
var footer = ZRefreshAutoFooter(target: self, action: #selector(self.loadData(_:)))
self.tableView.footer = ZRefreshAutoFooter({
})
self.tableView.footer = footer
```
##### 2.  add normal footer into your tableView
``` bash
var footer = ZRefreshBackFooter(target: self, action: #selector(self.loadData(_:)))
var footer = ZRefreshBackNormalFooter({
})
```
##### 3.  stop refreshing
``` bash
self.tableView.footer?.endRefreshing()
self.tableView.footer?.endRefreshingWithNoMoreData()
```
**note**: you can use following function reset the refresh state
``` bash
self.tableView.footer?.resetNoMoreData()
```
##### 4.  the footer can auto hide
``` bash
self.footer.automaticallyHidden = true
```
**note**: you can set the page size for the footer, when your rows count less than pageSize auto hide the footer
``` bash
self.footer.pageSize = 20
```
##### 5.  hidden the state label 
``` bash
self.footer.stateLabelHidden = true
```
##### 6.  when you set a contentInset, you need set the ignore height to ajust the view
``` bash
self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
self.footer.ignoredScrollViewContentInsetBottom = 30
```
##### 7.  also, you can set the indicator style
``` bash 
self.footer.activityIndicatorViewStyle = .WhiteLarge
```
##### 8.  disable the automic refresh for a AutoRefreshFooter
``` bash
self.footer.automaticallyRefresh = false
```



