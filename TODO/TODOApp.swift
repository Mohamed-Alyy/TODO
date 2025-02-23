//
//  TODOApp.swift
//  TODO
//
//  Created by Mohamed Ali on 19/02/2025.
//

import SwiftUI

@main
struct TODOApp: App {
    
 
    @StateObject var vmtodo : ToDoViewModel  = ToDoViewModel()
    var body: some Scene {
        
        WindowGroup {
            MainView()
                .environmentObject(ToDoViewModel())
        }
    }
}
