//
//  ToDoModelView.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import Foundation


class ToDoViewModel: ObservableObject {
    

    @Published var todoArray: [ToDoModel] = [
        ToDoModel(title: "Buy milk", description: nil, taskDate: Date()),
        ToDoModel( title: "Learn SwiftUI", description: "task description", taskDate: Date(),priority: 2),
        ToDoModel( title: "Go for a walk", description: "another task description",priority: 3),
        ToDoModel( title: "Read a book", description: "last task description"),
]
    
   
    
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskDate: Date = Date()
    @Published var priority:Int = 1
    
    
    @Published var selectedTodo: ToDoModel? = nil
   

    
    
    var activeToDos: [ToDoModel] {
        todoArray.filter { !$0.isCompleted }
           
            .sorted(by: {$0.taskDate > $1.taskDate})
            .sorted (by:{$0.priority > $1.priority})
    }
    
    var completedToDos:[ToDoModel] {
        todoArray.filter { $0.isCompleted }
           
            .sorted(by: {$0.taskDate < $1.taskDate})
            .sorted (by:{$0.priority > $1.priority})
    }
    
    
    func addToDo(title: String, description: String?,date:Date) {
        guard
            !title.isEmpty else { return }
        
        todoArray.append(ToDoModel(title: title, description: description, taskDate: date, isCompleted: false,priority: priority))
        taskTitle = ""
        taskDescription = ""
        priority = 1
    }
    
    func deleteToDo(at indexSet: IndexSet, fromCompleted: Bool) {
          if fromCompleted {
              let indicesToDelete = indexSet.map { completedToDos[$0].id }
              todoArray.removeAll { indicesToDelete.contains($0.id) }
          } else {
              let indicesToDelete = indexSet.map { activeToDos[$0].id }
              todoArray.removeAll { indicesToDelete.contains($0.id) }
          }
      }
    
    func deleteToDo(todo: ToDoModel) {
        let index = todoArray.firstIndex { $0.id == todo.id }
        if let index = index {
            todoArray.remove(at: index)
        }
      }
    


    func updateTodo(id:UUID,title:String,description:String?,date:Date,priority:Int){
        if let index = todoArray.firstIndex(where: { $0.id == id }){
            todoArray[index].title = title
            todoArray[index].description = description
            todoArray[index].taskDate = date
            todoArray[index].priority = priority
       
     
            print("todo updated")
        }
    }
    
    

    
    func toggleTaskCompletion(id:UUID) {
        let todoIndex = todoArray.firstIndex { $0.id == id }
        if let todoIndex = todoIndex {
            todoArray[todoIndex].isCompleted.toggle()
        }
    }
}
