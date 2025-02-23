//
//  MainView.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var vm: ToDoViewModel //= ToDoViewModel()
    
    @State var showAddTodoView: Bool = false
    @State var showEditeTodoView: Bool = false
    @State var showCOnfirmationView:Bool = false
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack {
                    List {
                        // Active tasks
                        if !vm.activeToDos.isEmpty {
                            Section(header: Text("Active Tasks")
                                .frame(maxWidth: .infinity, alignment:.leading))
                            {
                                ForEach(vm.activeToDos) { todo in
                                    ToDoRowView(todo: todo)
                                        .contextMenu{
                                            ContextMenuView(vm: vm, showEditTodoView: $showEditeTodoView, todo: todo)
                                        }
                                        .swipeActions(edge: .trailing) {
                                            // إضافة إجراءات السحب للوصول السريع
                                            Button(role: .destructive) {
                                                vm.deleteToDo(todo: todo)
                                            } label: {
                                                Label("delete", systemImage: "trash")
                                            }
                                            
                                            Button {
                                                vm.selectedTodo = todo
                                                showEditeTodoView.toggle()
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                vm.toggleTaskCompletion(id: todo.id)
                                            } label: {
                                                Label(
                                                    todo.isCompleted ? "Mark as un done" : "Mark as done",
                                                    systemImage: todo.isCompleted ? "circle" : "checkmark.circle"
                                                )
                                            }
                                            .tint(todo.isCompleted ? .gray : .green)
                                        }
                                    
                                    
                                    
                                        .onTapGesture {
                                            vm.toggleTaskCompletion(id: todo.id)
                                        }
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets())
                                }
                            
                            }
                        } // Active tasks
                        
                        //Completed tasks
                        if !vm.completedToDos.isEmpty {
                            Section(header: Text("Completed Tasks")
                                .frame(maxWidth: .infinity, alignment:.leading)) {
                                    ForEach(vm.completedToDos) { todo in
                                        ToDoRowView(todo: todo)
                                            .contextMenu {
                                                ContextMenuView(vm: vm, showEditTodoView: $showEditeTodoView, todo: todo)
                                            }
                                        
                                            .swipeActions(edge: .trailing) {
                                                // إضافة إجراءات السحب للوصول السريع
                                                Button(role: .destructive) {
                                                    vm.deleteToDo(todo: todo)
                                                } label: {
                                                    Label("delete", systemImage: "trash")
                                                }
                                                
                                            }
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    vm.toggleTaskCompletion(id: todo.id)
                                                } label: {
                                                    Label(
                                                        todo.isCompleted ? "Mark as un done" : "Mark as done",
                                                        systemImage: todo.isCompleted ? "circle" : "checkmark.circle"
                                                    )
                                                }
                                                .tint(todo.isCompleted ? .gray : .green)
                                            }
                                        
                                            .onTapGesture {
                                                vm.toggleTaskCompletion(id: todo.id)
                                            }
                                            .listRowBackground(Color.clear)
                                            .listRowInsets(EdgeInsets())
                                            .foregroundColor(.gray)
                                    }
                                    //                                    .onDelete { indexSet in
                                    //                                        vm.deleteToDo(at: indexSet, fromCompleted: true)
                                    //                                    }
                                    
                                }
                        }//Completed tasks
                        
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
                            if let todo = vm.selectedTodo {
                                EditToDoView(taskToEdit: todo)
                                    .presentationDetents([.medium])
                                    .onTapGesture{
                                        self.dismissKeyboard()
                                    }
                            }
                            
                            
                        }
                    }// Hstack
                } // Vstack
            } // Zstack
            
        }
        
    }
}

#Preview {
    MainView()
        .environmentObject(ToDoViewModel())
}
