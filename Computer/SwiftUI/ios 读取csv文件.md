---
title: ios 读取csv文件
date:  2021年11月23日 17:52:57
tags: 
- 计算机学习笔记
- SwiftUI
categories: 九阴真经
---

最终代码
``` swift
      
.fileImporter(isPresented: $imported, allowedContentTypes: [.delimitedText], allowsMultipleSelection: false){ result in
    do {
        
        guard let fileUrl: URL = try result.get().first else {return}
        
        if (CFURLStartAccessingSecurityScopedResource(fileUrl as CFURL)) {   //不在这个if里就出错，唉
		//理由：iOS的沙盒机制保护需要我们申请临时调用url的权限
            
            guard let data = String(data: try Data(contentsOf: fileUrl), encoding: .utf8) else { return }
            
            
            handleSSJdataCSV(data: data)
            //done accessing the url
            CFURLStopAccessingSecurityScopedResource(fileUrl as CFURL)
        }
        else {
            print("Permission error!")
        }
    } catch {
        // Handle failure.
        print ("error reading: \(error.localizedDescription)")
    }
}
 
 //数据格式处理代码
 func handleSSJdataCSV(data : String){
    var csvToStruct = [SSJdata]()
    
    //split the long string into an array of "rows " of sata. each row is a string
    //detect "/n" carriage return , then split
    var rows = data.components(separatedBy: "\n")
    
    let columnCount = rows.first?.components(separatedBy: ",").count
    //remove the header rows
    rows.removeFirst()
    
    //loop around each row and split into columns
    for row in rows{
        let csvColumes = row.components(separatedBy: ",")
        if csvColumes.count == columnCount{
            let genericStruct = SSJdata.init( raw: csvColumes)
            csvToStruct.append(genericStruct!)
        }

    }
    print(csvToStruct)
    
    for singleRecord in csvToStruct{
        print(singleRecord.recordType)
    }
    //done accessing the url
}
```


参考文献：
https://stackoverflow.com/questions/67731694/how-do-i-save-an-imported-file-name-as-string-after-importing-file-in-swiftui

```swift
//不太管用
let fileUrl = try res.get()
                self.fileName = fileUrl.lastPathComponent  // <--- the file name you want

                let fileData = try Data(contentsOf: fileUrl)
```
https://betterprogramming.pub/importing-and-exporting-files-in-swiftui-719086ec712
有大用
https://github.com/acwright/ImportExport
上面那个链接内容的示范工程