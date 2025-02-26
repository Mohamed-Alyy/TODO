//
//  ToDoDataModel.swift
//  TODO
//
//  Created by Mohamed Ali on 23/02/2025.
//

import Foundation

import CoreData

@objc(ToDoEntity)
public class ToDoEntity: NSManagedObject {
  
    @NSManaged public var id : UUID
    @NSManaged public var title : String
    @NSManaged public var todoDescription : String?
    @NSManaged public var date : Date
    @NSManaged public var isCompleted : Bool
    @NSManaged public var priority : Int16
}



extension ToDoEntity {
    static func fetchRequest() -> NSFetchRequest<ToDoEntity> {
        NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
    }
}
