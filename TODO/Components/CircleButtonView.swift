//
//  CheckMarkView.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import SwiftUI
struct CircleButtonView: View {
    var color: Color
    var size: CGFloat
    var iconeSystemName: String
    var action: () -> Void
    var body: some View {
        
        Button {
            action()
        } label: {
            Image(systemName: iconeSystemName)
                .foregroundColor(color)
        }
        .font(.system(size: size, weight: .light, design: .default))

    }
}


#Preview {
    CircleButtonView(color: .blue, size: 40,iconeSystemName: "checkmark.circle", action: {})
}
