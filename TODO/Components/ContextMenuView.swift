//
//  ContextMenuView.swift
//  TODO
//
//  Created by Mohamed Ali on 22/02/2025.
//

import SwiftUI
struct ContextMenuView: View {
    @ObservedObject var vm: ToDoViewModel = .init()
    @Binding var showEditTodoView: Bool
    let todo: ToDoModel
    
    var body: some View {
        VStack(spacing: 12) {
            // اكمال المهمة
            Button(action: {
                withAnimation(.spring()) {
                    //vm.toggleTaskCompletion(id: todo.id)
                    vm.markAsCompleted(todo: todo)
                }
            }) {
                Label(todo.isCompleted ? "Mark as not done" : "Mark as done",
                      systemImage: todo.isCompleted ? "circle" : "checkmark.circle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(todo.isCompleted ? .gray : .green)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
            
            // تعديل المهمة
            Button(action: {
//                vm.selectedTodo = todo
                showEditTodoView.toggle()
            }) {
                Label("Edit", systemImage: "pencil.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
            }
            .disabled(todo.isCompleted)
            
            
            Divider()
                .padding(.vertical, 4)
            
            // حذف المهمة
            Button(action: {
                withAnimation(.easeInOut) {
                    vm.deleteToDo(todo: todo)
                }
            }) {
                Label("Delete", systemImage: "trash.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
            }
        }
        .padding()
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    ContextMenuView(vm: ToDoViewModel(), showEditTodoView: .constant(false), todo: ToDoModel(title:""))
}
