

## same things between struct & class

### functions
``` swift
functions
func multiply(_ operand: Int, by otherOperand: Int) -> Int{
    return operand * otherOperand
}
```

,by 给函数调用者用  
每个参数可以有两个label，
operand, otherOperand, 用于函数内部

下划线表示不需要label，同时必须保留



### initializers 初始值设定项
有点类似于构造函数


## differences between struct & class
 | struct | class |
 | ---- | --- |
 |value type | Rseference type |
 | Csopied when passed or assigned | Passed around via pointers 存储在堆中 | 
 | coyppy on write | Automatically reference counted | 
 | Functional programming | Object-oriented programming |
 | no inheritance | inheritance ( single  ) |
 | "Free" <mark>init</mark> initializes all <mark>vars</mark> | "Free" <mark>init </mark> initializes no <mark>vars</mark> |
 | Mutability must be explictly stated | ALways mutable |
 | your "go to" data structure | Used in specific circumstances | 
 | Everything you've seen so far is a struct (except <mark>View </mark> which is a protocol  ) | The ViewModel in MVVM is always a class (also UIKit is class_based ) |

 ```swift
  mutating func choose(card: Card){
        print("card choosen: \(card.content)")
        let chosenIndex : Int = self.index(of: card)
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
    }
 ```
所有改变自身内容的函数,需要加上mutating,表示这是一个异变函数.

## protocol
A protocol is sort of a  "stripped-down" (精简的) struct/class

it has functions and vars, but no implementation ( or storage)! 

Declaring a protocol looks very similar to struct or class :
``` swift
protocol Moveable{
	func move(by: Int)
	var hasMoved: Bool {get}
	var distanceFromStart: Int {get set }
}

struct PortableThing: Moveable{
    //must implement move(by:), hasMoved and distanceFromStart here
}

protocol Vehicle: Moveable{  // protocol inheritance
    var passengerCount: Int { get set }
}

class Car: Vehicle, Impoundable, Leasable  {
    //must implement move(by:)\quad hasMoved\quad distanceFromStart and passengerCount here 
}
```

### adding protocol implementation 
 one way to think about protocols is <mark>constrains and gains </mark> 

 ``` swift
 struct Tesla: Vehicle {
 // Tesla is <mark>constrained </mark> to have to implement everything in Vehicle 
 // but <mark>gains </mark> all the capabilities a Vehicle has too  <++>
 
 	}
 ```

but how does a Vehicle "gain capabilities " if it has no implementation?
you can <mark>add implementations to a protocol </mark> using an <mark>extension</mark> to the protocol... 
``` swift
extension Vehicle{
    func registerWithDMV() { /*implementation here */ }
}
```

now Teslas (and all other Vehicles ) can be registered with the DMV.

**Adding extensions to protocols is at the heart of functional programming in Swift .**

the protocol View is the world's greatest example of this! 

## extension
### adding code tot a struct or class via an extension 

``` swift 
struct Boat {
   ...
}

extension Boat{ 
	func sailAroundTheWorld() { /* implementation */ }
}

// you can even make something conform to a protocol purely via an extension ... 
extension Boat: Moveable{
    // implement move(by:) and distanceFromStart here 
}

//now Boat comforms to the Moveable protocol ! 


```

### why protocols?
it's a way for types(structs/classes/other protocols) to say what they are capable of.  
And also for other code to demand certain behavior out of another type.  

### Generics (范型) 
``` swift
protocol Greatness {
    func isGreaterThan(other: Self) -> Bool
}

extension Array where Element: Greatness {
	var greatest: Element{
	    //for-loop through all the Elements
		//which(inside this extension) we know each implements the Greatness protocol
		//and figure out which one is greatest by calling isGreaterThan(Other:) on them
		return the greatest by calling isGreaterThan on each Element
	}
}
```

## layout
### HStack and VStack
Stack's choice of who to offer space to next can be overridden with <mark>.layoutPriority(Double). </mark> In other words. <mark>layoutPriority </mark> trumps "least flexible "  
```swift 
HStack{
    Text("Important").layoutPriority(100)  //any floating point number is okay
    Image(systemName:"arrow.up") //the default layout priority is 0 
    T	ext("unimportant")
}
```
the Important Text above will get the space it wants first.  
Then the Image would get its space.  
If a  Text doesn't get enough space, it will elide  

## enum

``` swift
enmu FastFoodMenuItem{
    case hamburger
	case fries
	case drink
	case cookie
}

```
an enum is a value type , it is copies as it is passed around 

each stat can *(but not have to)* have its own "associated data" ...
```swift
enum FastFoodMenuItem{
    case hamburger(numberOfPatties: Int)
	case fries(size: FryOrderSize)
	case drink(String, ounces: Int)
	case cookie
}
// drink case has 2 pieces of associated data(one of them " unnamed") , FryOrderSize would also probably be an enum: 
enum FryOrderSize{
    case large
    case small

}

let menuItem: FastFoodMenuItem = FastFoodMenuItem.hamburger(numberOfPatties: 2)
let otherItem : FastFoodMenuItem = FastFoodMenuItem.cookie

// checking an enums state: use switch
var menuItem = FastFoodMenuItem.hamburger(numberOfPatties: 2)
switch menuItem{
	case FastFoodMenuItem.hamburger: print("burger")
	case FastFoodMenuItem.fries: print("fries")
	case FastFoodMenuItem.drink: break
	case FastFoodMenuItem.cookie: print("cookie")
	default: print("other")

	 func isIncludedInSpecialOrder(number: Int) -> Bool{
		 switch self{
		     case .hamburger(let pattyCount): return pattyCount == number
			 case .fries, .cookie: return true //a drink and cookie in every special order 
			 case .drink(_, let ounces): return ounces == 16 //&16oz drink of any kind
		 }
	     }
	}


// Associated data is accessed through a switch statement using this let syntax 
var menuItem = FastFoodMenuItem.drink("Coke", ounces: 32)
switch menuItem{
    case .hamburger(lat pattyCount): print("a burger with \(pattyCount) patties! ")
	case .fries(let size): print("a \(size) order of fries!")
	case .drink(let brand, let ounces): print("a \(ounces)oz \(brand)")
	case .cookie: print("a cookie!")
}

```

## Optional 
an optional is just an enum. period, nothing more. 
```swift
enum Optional<T> { // a generic type, like Array<Element> or MemoryGame<CardContent> 
    case none
	case some(T) // the some case has associated value of type T

}

```
you can se that it can only have two values: <mark>is set </mark> (some） or <mark>not set</mark> (none)  
in the <mark>is set </mark> case, it can have some associated data tagging along (of don't care type T) 

when to use:  ANy time we have a value that can sometimes be "not set " or "unspecified" or "undetermined" .

```swift
var hello: String?     var hello: Optional<String> = .none
var hello: String? = "hello"      var hello: Optional<String> = .some("hello")
var hello: String? = nil      var hello: Optional<String> = .none 

print(hello!)   //unsafe

safe version:
if let safehello = hello {
    print(safehello)
}else{
	//do something
}

.. Optional default

let x: String? = ...
let y = x ?? "foo"

```


## ViewBuilder
to surrort "list-oriented syntax"  

for example, if we wanted to factor out the Views we use to make the front of a Card:
```swift
@ViewBuilder
func front(of card: Card) -> some View{
    RoundedRectangle(cornerRadius: 10)
	RoundedRectangle(cornerRadius: 10).stroke()
	Text(card.content)
}
```

## shape
shape is a protocol that inherits from View.  

## Animation

```swift

Text("ghost").modifier(Cardify(isFaceUP: true))
//to
Text("ghost").cardify(isFaceUP: true)

extension View{
	func cardify(isFaceUP: Bool) -> some View {
	    return self.modifier(Cardify(isFaceUP: isFaceUP))
	}
}

```

what is animation:  
a smoothed out portrayal in your ui  
of a change that has already happened  
the point of animations is to make the user experience less abrupt.   
and to draw attention to things that are changing 

### what can get animated  
you can only animate changes to VIew in containers that are already on screen   

### how to make an animation go 
implicitly, .animation(Animation)  
	explicitly,  by wrapping withAnimation(Animation) {} around the code that might change things.  

## @State
 ``` swift 
Text("ghost")
    .opacity(scary ? 1 : 0)
	.rotationEffect(Angle.degrees(upsideDown ? 180 : 0))
	.animation(Animation.easeInOut)
	.duration
	.delay
	.repeatForever

// curve:
.linear
.easeInOut
.spring

withAnimation(.linear(duration: 2)){

 }
 ```
### transtions
transitons specify how to animate the arrival/departure of Views in CTAAOS

```swift 
ZStack{
	if isFaceUP{
	     RoundedRectangle() //default .transition is .opacity
		 Text("ghost").transition(.scale)
	}else{
	    RoundedRectangle(cornerRadius: 10).transition(.identity)
	}
}
```


