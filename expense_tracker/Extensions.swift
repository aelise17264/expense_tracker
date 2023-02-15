//
//  Extensions.swift
//  expense_tracker
//
//  Created by Experimental Station on 2/15/23.
//

import Foundation
import SwiftUI

extension Color {
    static let background = Color("Background")
    static let icon = Color("Icon")
    static let text = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter{
    static let allNumericUSA: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/DD/YYYY"
        
        return formatter
    }()
}

extension String{
    func dateParsed() -> Date {
     guard let parsedDate = DateFormatter.allNumericUSA.date(from: self)
            
        else{
         return Date()
     }
        return parsedDate
    }
}
