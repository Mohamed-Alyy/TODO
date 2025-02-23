//
//  View.swift
//  TODO
//
//  Created by Mohamed Ali on 22/02/2025.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
