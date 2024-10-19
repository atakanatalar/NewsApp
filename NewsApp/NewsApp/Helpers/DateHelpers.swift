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
        
        if let hours = difference.hour, hours > 0 {
            return "\(hours) hours ago"
        } else if let minutes = difference.minute, minutes > 0 {
            return "\(minutes) minutes ago"
        } else {
            return "Now"
        }
    }
    
    static func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateString)
    }
}