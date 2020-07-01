# swift_multi_threading_dispatchqueue_or_operationqueue

[https://www.youtube.com/watch?v=NnpQ8IqLt0s](https://www.youtube.com/watch?v=NnpQ8IqLt0s)

# Swift Concurrnecy, DispatchQueues, OperationQueues, Theory

### Concurrency / Multitasking

- It helps you to write efficient, fast execution, and responsive apps.

### Concurrency

- Concurrency is the process of `executing multiple tasks` at the same point of time.
- Modern operating systems are capable of running multiple tasks with a single CPU by sharing the time among different tasks.
- Apple introduced `Multicore Processors` to make the work easy for concurrency.

In iOS there are two different APIs to achieve concurrency

1. Dispatch Queues (GCD)
2. NSOperationQueue 
3. Threads 

### Why Concurrency, Background Task

- `Utilize iOS devices' hardware`: Now all iOS devices have a multi-core processor that allows developers to execute multiple tasks in parallel. You should utilize this feature and get benefits out of the hardware.
- `Better user experience` : You probably have written code to call web services, handle some IO, or perform any heavy tasks. `As you know, doing these kind of operations in the UI thread will freeze the app, making it non responsive.` Once user faces this situation, the first step that he/she will take is to kill/close your app without a second thought. `With concurrency, all these tasks can be done in background without hanging the main thread or disturbing your users.` They can still tap on buttons, scroll and navigate through your app, while it handles the heavy loading task in the background.

### GCD (Grand Central Dispatch)

- `GCD` is the most commonly used API to manage concurrent code and execute operations `asynchronously` at the Unix level of the system. `GCD` provides and manages `queues` of tasks.
- `GCD` is `low-level C API` to perform tasks concurrently.

### Queue?

- Queues are data structures that manage objects in the order of `First-in, First-out` (FIFO). Queues in computer science are similar because the first added to the queue is the first object to be removed from the queue.

### DispatchQueue

- Dispatch queues are an easy way to perform tasks `asynchronously` and `concurrently` in your application.
- There are two varieties of dispatch queues:
1. `Serial Queues` 
2. `Concurrent Queues` 

❗️ NOTE: Each Application does have one thread, that is `Main Thread.`

Before talking about the differences, you need to know that tasks assigned to both queues are being executed in seperate threads than the thread they were created on. In other words, **you create blocks of code and submit it to dispatch queues in the main thread. But all these tasks (Blocks of codes) will run in separate threads instead of the main thread.** 

⇒ 각각 진행되는 모든 queue들이 main thread로 dispatch 되더라도, 각각의 queue들은 다른 쓰레드에서 돌아간다.

### Serial Queues

- When you choose to create a queue as a serial queue, the queue can only `execute one task at a time.`
- All tasks in the same serial queue will respect each other and `execute serially.`
- However, they don't care about tasks in seperate queues which means that you can still execute tasks concurrently by using `multiple serial queues`
- For example, you can create two serial queues, each queue executes only one task at a time but up to two tasks could still execute concurrently.
- Serial queues are awesome for `managing a shared resource.` It provides guaranteed serialized access to the shared resource and prevents race conditions.

### Advantages of Serial Queues

- `Guaranteed serialized access` to a `shared resource` that avoids race condition.
- Tasks are executed in a `predictable` order. When you submit tasks in a serial dispatch queue, they will be executed in the same order as they are inserted.
- You can create any number of serial queues.

### Concurrent Queues(Async)

- As the name suggests, concurrent queues allow you to `execute multiple tasks in parallel.`
- The tasks (blocks of codes) starts in the `order in which they are added in the queue.`
- But their execution all occur `concurrently` and they don't have to wait for each other to start.
- Concurrent queues `guarantee that tasks start in same order` but you `will now know the order of execution`, execution time or the number of tasks being executed at a given point.
- For example, you submit three tasks (task #1, #2, and #3) to a concurrent queue. The tasks are executed concurrently and are started in the order in which they were added to the queue. However, the execution time and finish time vary. Even it may take some time for task #2 and task #3 to start, they both can complete before task #1. It's up to the system to decide the execution of the tasks.

### Using Queue (1sq + 4cq)

- By default the operating system provides single Serial Queue and 4 Concurrent Queues.
- The `main dispatch queue` is the globally available serial queue.
- It is `used to update the app UI` and perform all tasks related to the `update of UIViews`.
- There is `only one task to be executed at a time` and this is why the `UI is blocked` when `you run a heavy task` in the main queue.

⇒ 즉, DispatchQueue.main은 globally하게 share하는 하나의 task다. task는 하나이기 때문에  heavy한 작업을 하면 UI가 멈춘다.

- Besides the main queue, the system provides `four concurrent queues.` We call them `Global Dispatch Queues`.
- These `queues are global to the application` and are differentiated only by their priority level
- To use one of the global concurrent queues, you have to get a reference of your preferred queue using the function `dispatch_get_global_queue` which takes in the first parameter one of these values:
    - DISPATCH_QUEUE_PRIORITY_HIGH
    - DISPATCH_QUEUE_PRIORITY_DEFAULT
    - DISPATCH_QUEUE_PRIORITY_LOW
    - DISPATCH_QUEUE_PRIORITY_BACKGROUND

---

### NSOperation Queues

- GCD is a `low-level C API` that enables developers to execute tasks concurrently.
- Operation queues, on the other hand, are high level abstraction of the queue model, and is `built on top of GCD.`
- That means you can execute tasks concurrently just like GCD, but in an `object-oriented fashion.`
- Unlike GCD, "they don't conform to the `First-In-First-Out` order."
- NSOperation allows to set `dependencies` on operations.
- NSOperation allows to `cancel, resume` and `restart` the operations.

### GCD vs Operation Queues

- **Don't follow FIFO:** in operation queues, you can set an execution priority for operations and you can add dependencies between operations which means `you can define that some operations will only be executed after the completion of other operations.` This is why they don't follow First-In-First-out. ⇒ You can define the order of executions.
- **By default, they operate concurrently:** while you can't change its type to serial queues, there is still a workaround to execute tasks in operation queues in sequence by using dependencies between operations.
- Operation queues are instances of class `NSOperationQueues` and its tasks are encapsulated in instances of `NSOperation`

### NSOperation and NSOperationQueue

- Tasks submitted to operation queues are in the form of `NSOperation instances.` We discussed in GCD that tasks are submitted in block. The same can be done here but should be bundled inside NSOperation instance. You can simply think of NSOperation as a single unit of work.
- NSOperation is an abstract class, so that you can't directly create instances of NSOperation.
- It has two subclasses

### NSOperation

- NSOperation is an `abstract class`, so that you can't directly create instances of NSOperation.
- It has two sub classes:
    - NSBlockOperation - **Use this class to initiate operation with one or more blocks.** The operation itself can contain more than one block and the operation will be considered as finished when all blocks are executed.
    - NSInvocationOperation - Use this class to initiate an operation that consists of invoking a `selector` on a specified object.

### NSOperation, Advantages

1. First, they support dependencies through the method `addDependency(op: NSOperation)` in the `NSOperation` class. `When you need to start an operation that depends on the execution of the other`, you will want to NSOperation. ⇒ Dependent of other tasks. 
2. Secondly, you can change the execution priority by setting the property queuePriority with one of these values: ⇒ The operation with `high priority` will be executed first.
    - VeryLow
    - Low
    - Normal
    - High
    - VeryHigh

- Operation Block Example

```swift
queue = NSOperationQueue()
queue.addOperationBlock { () -> Void in 
    let img1 = Downloader.downloadImageWithURL(imageURLs[0])
    NSOperationQueue.mainQueue().addOperationWithBlock({
        self.imageView1.image = img1
})

queue.addOperationBlock { () -> Void in 
    let img2= Downloader.downloadImageWithURL(imageURLs[1])
    NSOperationQueue.mainQueue().addOperationWithBlock({
        self.imageView2.image = img2
})
```

- cancelling all operations

```swift
self.queue.cancelAllOperations()
```

- Adding dependecies

```swift
opeation2.addDependency(operation1)
operation3.addDependency(operation2)
```

# Concurrency - code examples

- DispatchQueue가 더 빠르다
- Concurrency에 순서를 주고 싶다면 `OperationQueue` 를 사용한다.

```swift
//
//  ViewController.swift
//  swift_multi_threading
//
//  Created by shin seunghyun on 2020/07/01.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Concurrent Queue
    //같은 block안에서는 synchronous하게 작동한다.
    func dispatchQueueInSameBlock() {
        let queue: DispatchQueue = DispatchQueue.global(qos: .default)
        queue.async { [weak self] in
            self?.task2()
            self?.task1()
        }
    }
    
    //Concurrent Queue
    //다른 block안에서는 asynchronous하게 작동한다.
    func dispatchQueueInDifferentBlock() {
        let queue: DispatchQueue = DispatchQueue.global(qos: .default)
        queue.async { [weak self] in
            self?.task1()
        }
        queue.async { [weak self] in
            self?.task2()
        }
    }
    
    //Asynchronous Task Using Operation
    func concurrentOperation() {
        let queue: OperationQueue = OperationQueue()
        let task1: BlockOperation = BlockOperation { [weak self] in
            self?.task1()
        }
        let task2: BlockOperation = BlockOperation { [weak self] in
            self?.task2()
        }
        queue.addOperation(task1)
        queue.addOperation(task2)
    }
    
    //Asynchronous Task Using Operation with Dependency or Order
    func concurrentOperationWithOrder() {
        let queue: OperationQueue = OperationQueue()
        let task1: BlockOperation = BlockOperation { [weak self] in
            self?.task1()
        }
        let task2: BlockOperation = BlockOperation { [weak self] in
            self?.task2()
        }
        
        //options for operation
        queue.maxConcurrentOperationCount = 1
        
        task1.addDependency(task2) //task2가 끝날 때 까지 기다림.
        queue.addOperation(task1)
        queue.addOperation(task2)
        
        task1.completionBlock = {
            print("Task 1 is completed!")
        }
        
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        concurrentOperationWithOrder()
    }
    
    

}

//Material
extension ViewController {
    
    func task1() {
        for i in 1...50000 {
            print("+++++++++++Task - 1")
            
            /*
             DispatchQueue takes less time to complete
             On the contrary, OperationQueue takes some time to complete a task.
             */
            
            //DispatchQueue를 적용해주지 않으면, UI가 operation이 끝날 때 까지 멈춰있는다.
//            DispatchQueue.main.async {
//                self.displayerLabel.text = "\(i)"
//            }
            

            OperationQueue.main.addOperation {
                self.displayerLabel.text = "\(i)"
            }

        }
    }
    
    func task2() {
        for _ in 1...50000 {
            print("----------Task - 2")
        }
    }
    
}
```
