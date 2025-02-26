//
//  RowView.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import SwiftUI



struct EditToDoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm : ToDoViewModel = ToDoViewModel()
        
    @State var taskToEdit : ToDoModel
   

    var body: some View {
        ZStack {
            // الخلفية الضبابية العصرية
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Edite ToDo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .foregroundStyle(Color.secondaryColor)

                // إدخال العنوان مع أيقونة جميلة
                HStack {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.blue)

                    TextField("Title...", text: $vm.taskTitle)
                            .padding()
                            .background(Color.backgroundColor)
                            .cornerRadius(10)
                    }
               
                .padding(.horizontal)
                
                HStack(alignment:.lastTextBaseline) {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .foregroundColor(.blue)
                   
                    TextField("Discription...", text: $vm.taskDescription)
                            .padding()
                            .background(Color.backgroundColor)
                            .cornerRadius(10)
                 
                 
                }
                .padding(.horizontal)

                // اختيار الأولوية باستخدام Segmented Picker
                HStack {
                    
                    Image(systemName: "text.badge.checkmark")
                    Text("Priority")
                    Picker("", selection: $vm.priority) {
                        Text("Low").tag(1)
                        Text("Medium").tag(2)
                        Text("Hight").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                   
                }

                // Date Designe
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                    DatePicker("", selection: $vm.taskDate, displayedComponents: [.date,.hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                }
                .padding(.horizontal)

                // Button to add new todo
                Button(action: {
                    vm.updateTodo(todo: taskToEdit)
                    dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(Color.backgroundColor).opacity(0.95))
                    .shadow(radius: 10)
            )
            .padding()
        }
        .onAppear {
            vm.taskTitle = taskToEdit.title
            vm.taskDescription = taskToEdit.description ?? ""
            vm.taskDate = taskToEdit.taskDate
            vm.priority = taskToEdit.priority
        }
    }
    
}
    

#Preview {
    EditToDoView(taskToEdit: ToDoModel(title: "test"))
        //.environmentObject(ToDoViewModel())
      
}
