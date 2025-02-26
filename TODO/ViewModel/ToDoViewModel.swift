//
//  ToDoModelView.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import Foundation


class ToDoViewModel: ObservableObject {
    
    private var allTodos: [ToDoModel] = []
    
    @Published var activeTasks: [ToDoModel] = []
    @Published var completedTasks: [ToDoModel] = []
    
    
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var taskDate: Date = Date()
    @Published var priority:Int = 1
    
    
    func fetchTodos(){
        allTodos = DataManger.shared.fetchTasks()
        sortTodos()
    }
    
    
    func sortTodos(){
        activeTasks =  allTodos.filter { !$0.isCompleted }
        
            .sorted(by: {$0.taskDate > $1.taskDate})
            .sorted (by:{$0.priority > $1.priority})
        
        completedTasks = allTodos.filter { $0.isCompleted }
        
            .sorted(by: {$0.taskDate < $1.taskDate})
            .sorted (by:{$0.priority > $1.priority})
    }
     

    

    init(){
        fetchTodos()
    }

    
    
    func addToDo(title: String, description: String?,date:Date) {
        guard
            !title.isEmpty else { return }
    
        let newTodo = ToDoModel(title: title, description: description, taskDate: date, isCompleted: false,priority: priority)
        DataManger.shared.addTodo(todo: newTodo)

        fetchTodos()
        taskTitle = ""
        taskDescription = ""
        priority = 1
    }
    

    func deleteToDo(todo: ToDoModel) {
        DataManger.shared.deleteTodo(todo: todo)
        fetchTodos()
      }
    


    func updateTodo(todo: ToDoModel){
        DataManger.shared.updateTodo(todo: todo)
        fetchTodos()
    }
    

    
    func markAsCompleted(todo: ToDoModel) {
        var updatedTodo = todo
        updatedTodo.isCompleted = true
        updateTodo(todo: updatedTodo)
        
        fetchTodos()
    }
    
    
    func deleteall(){
        DataManger.shared.removeAllTodos()
        fetchTodos()
    
    }
    

    
//    func toggleTaskCompletion(id:UUID) {
//        let todoIndex = allTodos.firstIndex { $0.id == id }
//        if let todoIndex = todoIndex {
//            allTodos[todoIndex].isCompleted.toggle()
//        }
//        fetchTodos()
//    }
}
