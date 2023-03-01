//
//  DateFormatter.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 28/02/2023.
//

import Foundation

class DateAndTimeFormater {
    func dateFormatter(item: Item) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        guard let newDate = item.expire else {return "Indeterminé"}
        let dateFormatted = formatter.string(from: newDate)
        return dateFormatted
    }
    
    func hourFormatter(item: Item) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        guard let newHour = item.expire else {return ""}
        let hourFormatted = formatter.string(from: newHour)
        return hourFormatted
    }
}
