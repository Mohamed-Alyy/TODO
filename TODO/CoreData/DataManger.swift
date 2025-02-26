//
//  DataMangerViewModel.swift
//  TODO
//
//  Created by Mohamed Ali on 23/02/2025.
//

import Foundation
import CoreData

final class DataManger{
    
    static let shared = DataManger()
    
//    // contaier coumputed property
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "ToDoModel")
//        
//        // تفعيل الترحيل التلقائي
//        let description = container.persistentStoreDescriptions.first
//        description?.shouldMigrateStoreAutomatically = true
//        description?.shouldInferMappingModelAutomatically = true
//        
//        container.loadPersistentStores(completionHandler: { storeDescription, error in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//    
    
    
    
    //------------------
 
  
        let container: NSPersistentCloudKitContainer

        init(inMemory: Bool = false) {
            container = NSPersistentCloudKitContainer(name: "ToDoModel")
            if inMemory {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            }
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
  

    
    //-------------------
    // context coumputed property
    var context: NSManagedObjectContext {
        return container.viewContext
      //  return persistentContainer.viewContext
    }
    



    func addTodo(todo: ToDoModel) {
        let todoEntity = ToDoEntity(context: context)
        todoEntity.title = todo.title
        todoEntity.todoDescription = todo.description
        todoEntity.date = todo.taskDate
        todoEntity.isCompleted = todo.isCompleted
        todoEntity.priority = Int16(todo.priority)
        
        saveContext()
    }
    
  
    func deleteTodo(todo: ToDoModel) {
        // fetch all todos in entity
        let fetchRequest : NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        // add predicate to fetch only this todo have this id with our ToDoModel
        fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        
        do{
            
            if let existingTask = try context.fetch(fetchRequest).first{
                context.delete(existingTask)
                saveContext()
                print("Task deleted successfully")
            }
        }catch(let error){
            print("Error deleting task: ",error.localizedDescription)
        }
        
    }
    


    func removeAllTodos() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ToDoModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
            print("All todos have been deleted successfully.")
        } catch {
            print("Failed to delete todos: \(error.localizedDescription)")
        }
    }
        
        
   
    
    
    func updateTodo(todo: ToDoModel) {
        let fetchRequest : NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)
        
        do{
            if let existingTask = try context.fetch(fetchRequest).first{
                
                existingTask.title = todo.title
                existingTask.todoDescription = todo.description
                existingTask.date = todo.taskDate
                existingTask.isCompleted = todo.isCompleted
                existingTask.priority = Int16(todo.priority)
                saveContext()
            }
        }catch (let error){
            print("Error updating task:" ,error.localizedDescription)
        }
    }
   
    
    func fetchTasks() -> [ToDoModel] {
        // fetch todo array form entity
        let request = ToDoEntity.fetchRequest()
        
        // sort array
        let prioritySort = NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: true)
        let dateSrot = NSSortDescriptor(keyPath: \ToDoEntity.date, ascending: true)
        
        request.sortDescriptors = [prioritySort, dateSrot]
        
        do{
            let tasks = try context.fetch(request)
            return tasks.map { task in
                ToDoModel(title: task.title,
                          description: task.todoDescription,
                          taskDate: task.date,
                          isCompleted: task.isCompleted,
                          priority: Int(task.priority))
            }
          
        }catch (let error){
            
            print("Error fetching tasks: \(error.localizedDescription)")
            
            return []
        }
        
    }

    

    func saveContext() {
        if context.hasChanges{
            do{
                try context.save( )
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}


