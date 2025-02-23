//
//  ToDoRowView 2.swift
//  TODO
//
//  Created by Mohamed Ali on 22/02/2025.
//


import SwiftUI

struct ToDoRowView: View {
    var todo: ToDoModel

    
    var body: some View {
        HStack(spacing: 12) {
            // مؤشر الأولوية
            Capsule()
                .fill(priorityColor(todo.priority))
                .frame(width: 5) // شريط جانبي يوضح الأولوية
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(todo.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .strikethrough(todo.isCompleted, color: .gray)
                    
                    Spacer()
                    
                    // أيقونة الإنجاز
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(todo.isCompleted ? .green : .gray)
                        .font(.system(size: 20))
                }
                
                // وصف المهمة
                if let description = todo.description, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // تاريخ المهمة
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(todo.taskDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.backgroundColor) // خلفية بيضاء
            .cornerRadius(10) // جعل التصميم ناعمًا
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2) // إضافة ظل خفيف
            
        }
        .padding(.horizontal)
       
    }
    
    // دالة لتحديد لون الأولوية
    func priorityColor(_ priority: Int) -> Color {
        switch priority {
        case 3: return .red
        case 2: return .orange
        default: return .green
        }
    }
}

#Preview {
    let task1 = ToDoModel(title: "Meeting with Team", description: "Discuss project progress", taskDate: Date(), isCompleted: false, priority: 3)
    
     ToDoRowView(todo: task1)
}
