# ZRefreshing

ZRefreshing is a simple swift Refreshing Control for Tableview or CollectionView.

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
### 1. add header into your tableView
``` bash
1. self.tableView.header = ZRefreshNormalHeader(target: self, action: #selector(self.loadData(_:)))

2. self.tableView.header = ZRefreshNormalHeader({
})
```
### 2. add auto footer into your tableView 
``` bash
1. self.tableView.footer = ZRefreshAutoFooter(target: self, action: #selector(self.loadData(_:)))

2. self.tableView.footer = ZRefreshAutoFooter({
})
```
### 3. add normal footer into your tableView
``` bash
1. self.tableView.footer = ZRefreshBackFooter(target: self, action: #selector(self.loadData(_:)));

2. self.tableView.footer = ZRefreshBackFooter({
})
```
### 4. start refreshing
``` bash
self.tableView.header?.beginRefreshing()
```
### 5. stop refreshing
``` bash
self.tableView.header?.endRefreshing()
```
### 6. hidden the last update label 
``` bash 
header.lastUpdatedTimeLabel.hidden = true
```
### 7. hidden the state label 
``` bash
1. header:
header.stateLabel.hidden = true
2. footer:
footer.stateLabel.hidden = true
```



