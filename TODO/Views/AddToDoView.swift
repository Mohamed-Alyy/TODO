//
//  RowView.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import SwiftUI


struct AddToDoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: ToDoViewModel //= .init()



    var body: some View {
        ZStack {

            // Blur Background
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Add new ToDo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .foregroundStyle(Color.secondaryColor)

 
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
                    vm.addToDo(title: vm.taskTitle, description: vm.taskDescription, date: vm.taskDate)
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
    }
}

#Preview {
    AddToDoView()
        .environmentObject(ToDoViewModel())
}



struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: blurStyle)
        let view = UIVisualEffectView(effect: effect)
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}
