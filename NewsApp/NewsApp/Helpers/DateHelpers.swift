//
//  DateHelpers.swift
//  NewsApp
//
//  Created by Atakan Atalar on 19.10.2024.
//

import Foundation

struct DateHelper {
    static func timeAgoSinceDate(_ date: Date) -> String {
        let now = Date()
        let difference = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let days = difference.day, days > 0 {
            return "\(days) \(DateHelperConstant.daysAgo)"
        } else if let hours = difference.hour, hours > 0 {
            return "\(hours) \(DateHelperConstant.hoursAgo)"
        } else if let minutes = difference.minute, minutes > 0 {
            return "\(minutes) \(DateHelperConstant.minutesAgo)"
        } else {
            return DateHelperConstant.now
        }
    }
    
    static func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString)
    }
    
    static func formatDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return DateHelperConstant.unknownDate
        }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}
