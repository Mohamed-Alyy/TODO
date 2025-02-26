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
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoEntity> {
        return NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
    }
    
    @NSManaged public var id : UUID
    @NSManaged public var title : String
    @NSManaged public var todoDescription : String?
    @NSManaged public var date : Date
    @NSManaged public var isCompleted : Bool
    @NSManaged public var priority : Int16
}



extension ToDoEntity {
    static func fetchRequestAll() -> NSFetchRequest<ToDoEntity> {
        NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
    }
}
