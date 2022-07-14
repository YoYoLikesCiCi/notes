# Chapter1 第一个coredata app
## Core Data Stack
### 1. NSManagedObjectModel
代表数据库的一个表那种


### 2. NSPersistentStore
负责读取和写入

### 3. NSPersistentStoreCoordinator
托管模型对象和持久存储之间的桥梁

### 4. NSManagedObjectContext
上下文，数据管理的唯一入口

### 5. persistent store container
上面四个整合，初始化这个就行


# Chapter4 : intermediate fetching
## 5 ways to set up a fetch request
```swift
// 1
let fetchRequest1 = NSFetchRequest<Venue>()
let entity =
  NSEntityDescription.entity(forEntityName: "Venue",
                             in: managedContext)!
                         
let fetchRequest2 = NSFetchRequest<Venue>(entityName: "Venue")
fetchRequest1.entity = entity
// 2 // 3
let fetchRequest3: NSFetchRequest<Venue> = Venue.fetchRequest()
// 4
let fetchRequest4 =
  managedObjectModel.fetchRequestTemplate(forName: "venueFR")
// 5
let fetchRequest5 =
  managedObjectModel.fetchRequestFromTemplate(
    withName: "venueFR",
    substitutionVariables: ["NAME" : "Vivi Bubble Tea"])
```

## fetching different result types 
- .managedObjectResultType: Returns managed objects (default value).
- .countResultType: Returns the count of the objects matching the fetch request.
- .dictionaryResultType: This is a catch-all return type for returning the results of different calculations.
- .managedObjectIDResultType: Returns unique identifiers instead of full-fledged managed objects.

