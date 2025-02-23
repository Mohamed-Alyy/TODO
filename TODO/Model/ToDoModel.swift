//
//  ToDoModel.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import Foundation

struct ToDoModel: Identifiable {
    let id: UUID = UUID()
    var title: String
    var description: String?
    var taskDate: Date = Date()
    var isCompleted: Bool = false
    var priority: Int = 1

}


enum Priority: Int, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3
}
