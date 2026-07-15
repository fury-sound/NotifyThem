//
//  DateFormatterService.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 07.07.2026.
//

import Foundation

final class DateFormatterService {
    static let shared = DateFormatterService()
    private init() {}

    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
