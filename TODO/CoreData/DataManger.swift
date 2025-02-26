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
    
    // contaier coumputed property
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModel")
        
        // تفعيل الترحيل التلقائي
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    
    //------------------
 
  
//        let container: NSPersistentCloudKitContainer
//
//        init(inMemory: Bool = false) {
//            container = NSPersistentCloudKitContainer(name: "ToDoModel")
//            if inMemory {
//                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//            }
//            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//                if let error = error as NSError? {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                     */
//                    fatalError("Unresolved error \(error), \(error.userInfo)")
//                }
//            })
//            container.viewContext.automaticallyMergesChangesFromParent = true
//        }
  

    
    //-------------------
    // context coumputed property
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
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
    
    func fetchAllTodos() -> [ToDoModel] {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        do {
            let todoEntities = try context.fetch(fetchRequest)
            return todoEntities.map { ToDoModel(title: $0.title, description: $0.todoDescription, taskDate: $0.date, isCompleted: $0.isCompleted, priority: Int($0.priority)) }
        } catch {
            print("Error fetching todos: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchTodo(by id: UUID) -> ToDoModel? {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let todoEntity = try context.fetch(fetchRequest).first {
                return ToDoModel(title: todoEntity.title,
                                 description: todoEntity.todoDescription,
                                 taskDate: todoEntity.date,
                                 isCompleted: todoEntity.isCompleted,
                                 priority: Int(todoEntity.priority)
                
                )
            }
        } catch {
            print("Error fetching todo: \(error.localizedDescription)")
        }
        return nil
    }
    
    
    /// Deletes a todo item from the Core Data context.
    /// - Parameter todo: The ToDoModel object representing the todo to be deleted.
    /// - Returns: A boolean indicating whether the deletion was successful.
    func deleteTodo(todo: ToDoModel) {
        // fetch all todos in entity
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        // add predicate to fetch only this todo with the given id
        fetchRequest.predicate = NSPredicate(format: "title == %@", todo.title as CVarArg)
        
        do {
            guard let existingTask = try context.fetch(fetchRequest).first else {
                print("No task found with the given ID.") // Inform if no task is found
                return //false // Indicate failure
            }
            
            context.delete(existingTask)
            saveContext()
            print("Task deleted successfully") // Consider using a logging framework
           // return true // Indicate success
        } catch {
            print("Error deleting task: ", error.localizedDescription) // Consider structured logging
          //  return false // Indicate failure
        }
    }
    


//    func removeAllTodos() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ToDoModel")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//            saveContext()
//            print("All todos have been deleted successfully.")
//        } catch {
//            print("Failed to delete todos: \(error.localizedDescription)")
//        }
//    }
//
    
    func removeAllTodos() {
        // إنشاء طلب الحذف
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ToDoModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        // تكوين طلب الحذف لإرجاع معرفات الكيانات المحذوفة
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            // تنفيذ طلب الحذف
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            
            // الحصول على معرفات الكيانات المحذوفة
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                // إنشاء تغييرات لتحديث سياق النتائج
                let changes = [NSDeletedObjectsKey: objectIDs]
                
                // دمج التغييرات في سياق النتائج
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                
                // حفظ السياق
                saveContext()
                
                // إعلام المراقبين (مثل TableView أو CollectionView) بالتغييرات
                NotificationCenter.default.post(name: Notification.Name("TodosDeleted"), object: nil)
                
                print("تم حذف \(objectIDs.count) من المهام بنجاح.")
            }
        } catch {
            print("فشل في حذف المهام: \(error.localizedDescription)")
        }
    }
        
   
    
    
    func updateTodo(todo: ToDoModel) {
        let fetchRequest : NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "title == %@", todo.title as CVarArg)
        
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


