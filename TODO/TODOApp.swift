//
//  TODOApp.swift
//  TODO
//
//  Created by Mohamed Ali on 19/02/2025.
//

import SwiftUI

@main
struct TODOApp: App {
    
    let dataManager : DataManger = DataManger()
    @Environment(\.scenePhase) var scenePhase
 
   // @StateObject var vmtodo : ToDoViewModel  = ToDoViewModel()
    var body: some Scene {
        
        WindowGroup {
            let todo: ToDoModel = .init( title: "Test", isCompleted: false)
            MainView(selectedTodo: todo)
                //.environmentObject(vmtodo)
                .environment(\.managedObjectContext, dataManager.context)
        }
        .onChange(of: scenePhase) { _, _ in
            dataManager.saveContext()
        }
        
    }
        
        
        
}

