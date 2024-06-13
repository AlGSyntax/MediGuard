//
//  Calendar.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 10.06.24.
//

import Foundation

extension Calendar {
    func settingHour(_ hour: Int) -> Calendar {
        var calendar = self
        calendar.timeZone = TimeZone(secondsFromGMT: 3600 * hour) ?? .current
        return calendar
    }
}

