//
//  Date.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import Foundation

extension Date{
    func setTime(hour: Int, minute: Int) -> Date {
            if let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self) {
                return date
            } else {
                return self
            }
        }
    }
