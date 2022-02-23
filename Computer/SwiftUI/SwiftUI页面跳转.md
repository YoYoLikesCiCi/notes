---
title: SwiftUI页面跳转
date: 2021-06-14 15:21:06
tags: 
- 计算机学习笔记
- SwiftUI
categories: 九阴真经
---
1. TabView
```Swift
struct ContentView: View {
    @State private var selection : Tab = .home
    enum Tab {
        case home
        case journal
        case statistics
        case settings
//        case test
        case test2
    }
    var body: some View {
        TabView(selection: $selection){
            HomeView()
                .tabItem {
                    Label("主页", systemImage : "house")
                }
                .tag(Tab.home)
            ViewJournal()
                .tabItem {
                    Label("流水", systemImage:"newspaper")
                }
                .tag(Tab.journal)
            
            ViewStatistics()
                .tabItem {
                    Label("统计", systemImage:"waveform.path.ecg")
                }
                .tag(Tab.statistics)
            
            ViewSettings()
                .tabItem {
                    Label("设置", systemImage:"seal")
                }
                .tag(Tab.settings)
        }
    }
}
```

2. NavigationLink
```swift
NavigationView {
    VStack {
        NavigationLink(destination: Text("点击后显示的视图内容")) {
            Text("可点击内容")
        }
    }
    .navigationBarTitle("这是顶部标题")
}
```
```swift
NavigationView {
    List(0..<3) { i in
        NavigationLink(
            destination: Text("点击列表页后进入的页面 (i)")) {
                Text("列表序号 (i)")
            }
    }
    .navigationBarTitle("标题")
}
```

3. sheet向上拉起
```swift
import SwiftUI
struct ContentView:View {
    var body: some View{
        TestSheet()
    }
}
struct TestSheet: View {
    @State private var popoverIsShown = false
    var body: some View {
        Button("显示 Sheet") {
            self.popoverIsShown = true
        }
        .sheet(isPresented: self.$popoverIsShown) {
            RandomSheet(popoverIsShown: self.$popoverIsShown)
        }
    }
}

struct RandomSheet: View {
    @Binding var popoverIsShown: Bool
    var body: some View {
        Button("关闭") { self.popoverIsShown = false }
    }
}
```

4. ActionSheet
```
Button("显示Sheet页") {
    showingSheet = true//点击后改显示
}
.actionSheet(isPresented: $showingSheet) {
    ActionSheet(
        title: Text("你想在这个页面放点啥?弹出一个提示，还可以修改信息等操作"),
        message: Text("如果要关闭此页只需要向下滑动或者点击下面的按钮..."),
        buttons: [.default(Text("关闭此面"))]
    )
}
```

5. popover
**popover是**一个专用的修改器来显示弹出窗口，在iPadOS上它显示为浮动气球，而在iOS上则像一张纸一样滑到屏幕上。

要显示弹出窗口，您需要某种状态来确定该弹出窗口当前是否可见，但仅此而已–与警报和操作表不同，弹出窗口可以包含所需的任何视图。因此，只要将您需要的任何东西放在弹出窗口中，SwiftUI就会处理其余的工作。

例如，当点击一个按钮时，将显示一个弹出视图：
```
struct ContentView: View {
    @State private var showingPopover = false
    var body: some View {
        Button("显示菜单") {
            showingPopover = true
        }
        .popover(isPresented: $showingPopover) {
            Text("你要的内容在这里！")
                .font(.headline)
                .padding()
        }
    }
}

```

6. alert
```
Alert(title: Text("弹出的标题!"), message: Text("这是消息的内容"), dismissButton: .default(Text("OK")))
```


参考资料：
http://www.neter8.com/ios/127.html