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
