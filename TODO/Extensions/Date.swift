//
//  Date.swift
//  TODO
//
//  Created by Mohamed Ali on 20/02/2025.
//

import Foundation

extension Date {
    func formatted(format: String = "yyyy-MM-dd HH:mm a", locale: String = "en_US_POSIX") -> String {
        let formater = DateFormatter()
        formater.dateFormat = format
        formater.locale = Locale(identifier: locale)
        return formater.string(from: self)
        
    }

}
