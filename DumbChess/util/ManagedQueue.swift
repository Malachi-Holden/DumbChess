//
//  ManagedQueue.swift
//  DumbChess
//
//  Created by Malachi Holden on 8/29/21.
//

import Foundation

class ManagedQueue {
    var tasks = [] as [() -> Void]
    var numberOfTasksLeft = 0
    
    
    var onAllComplete: (() -> Void)?
    
    func addTask(_ task: @escaping () -> Void) {
        tasks.append(task)
    }
    
    func setOnAllComplete(_ completion: @escaping () -> Void) {
        onAllComplete = completion
    }
    
    func run() {
        numberOfTasksLeft = tasks.count
        for task in tasks {
            DispatchQueue.global(qos: .userInitiated).async {
                task()
                DispatchQueue.main.async {
                    self.numberOfTasksLeft -= 1
                    if self.numberOfTasksLeft == 0 {
                        self.onAllComplete?()
                    }
                }
            }
        }
    }
}
