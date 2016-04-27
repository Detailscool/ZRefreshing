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

``` bash
add header into your tableView
self.tableView.header = ZRefreshNormalHeader(target: self, action: #selector(self.loadData(_:)));

or

self.tableView.header = ZRefreshNormalHeader(refreshClosure: {
})
```