//
//  MainView.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import SwiftUI
import CoreData
struct MainView: View {
    @StateObject private var vm: ToDoViewModel = ToDoViewModel()
    
    @State var showAddTodoView: Bool = false
    @State var showEditeTodoView: Bool = false
    @State  var selectedTodo: ToDoModel

    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack {
                    List {
                            Section(header: Text("Active Tasks")
                                .frame(maxWidth: .infinity, alignment:.leading))
                            {
                                ForEach(vm.activeTasks) { todo in
                                    ToDoRowView(todo: todo)
                                        .swipeActions(edge: .trailing) {
                                            // إضافة إجراءات السحب للوصول السريع
                                            Button(role: .destructive) {
                                                vm.deleteToDo(todo: todo)
                                            } label: {
                                                Label("delete", systemImage: "trash")
                                            }
                                            
                                            Button {
                                                selectedTodo = todo
                                                showEditeTodoView.toggle()
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                vm.markAsCompleted(todo: todo)
                                            } label: {
                                                Label(
                                                    todo.isCompleted ? "Mark as un done" : "Mark as done",
                                                    systemImage: todo.isCompleted ? "circle" : "checkmark.circle"
                                                )
                                            }
                                            .tint(todo.isCompleted ? .gray : .green)
                                        }
                                    
                                    
                                    
                                        .onTapGesture {
                                            vm.markAsCompleted(todo: todo)
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets())
                                }
                            
                           // }
                        } // Active tasks
                        
                        //Completed tasks
                
//    
//                            Section(header: Text("Completed Tasks")
//                                .frame(maxWidth: .infinity, alignment:.leading)) {
//                                    ForEach(vm.completedTasks) { todo in
//                                        ToDoRowView(todo: todo)
//                                        
//                                            .swipeActions(edge: .trailing) {
//                                                // إضافة إجراءات السحب للوصول السريع
//                                                Button(role: .destructive) {
//                                                    vm.deleteToDo(todo: todo)
//                                                } label: {
//                                                    Label("delete", systemImage: "trash")
//                                                }
//                                                
//                                            }
//                                            .swipeActions(edge: .leading) {
//                                                Button {
//                                                    vm.markAsCompleted(todo: todo)
//                                                } label: {
//                                                    Label(
//                                                        todo.isCompleted ? "Mark as un done" : "Mark as done",
//                                                        systemImage: todo.isCompleted ? "circle" : "checkmark.circle"
//                                                    )
//                                                }
//                                                .tint(todo.isCompleted ? .gray : .green)
//                                            }
//                                        
//                                            .onTapGesture {
//                                                vm.markAsCompleted(todo: todo)
//                                            }
//                                            .listRowBackground(Color.clear)
//                                            .listRowInsets(EdgeInsets())
//                                            .foregroundColor(.gray)
//                                    }
//                                
//                                }//Completed tasks
                        
                    }//List
                    
                    .scrollContentBackground(.hidden)
                    .navigationTitle("To-Do List")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                }//Vstack
                // .toolbar(.hidden, for: .navigationBar)
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        CircleButtonView(color: .accent, size: 40, iconeSystemName: "pin.circle") {
                            vm.deleteall()
                        }
                        CircleButtonView(color: .accent, size: 40, iconeSystemName: "plus.circle") {
                            showAddTodoView.toggle()
                        }
                        .sheet(isPresented: $showAddTodoView) {
                            AddToDoView()
                                .presentationDetents([.medium])
                                .onTapGesture {
                                    self.dismissKeyboard()
                                }
                        }
                        .sheet(isPresented: $showEditeTodoView) {
                            //if let todo = selectedTodo {
                            EditToDoView(taskToEdit: selectedTodo)
                                    .presentationDetents([.medium])
                                    .onTapGesture{
                                        self.dismissKeyboard()
                                 //   }
                            }
                        }
                    }// Hstack
                } // Vstack
            } // Zstack
            
        }
        
    }
}

#Preview {
    let todo: ToDoModel = .init( title: "Test", isCompleted: false)
    MainView (selectedTodo: todo)
}
