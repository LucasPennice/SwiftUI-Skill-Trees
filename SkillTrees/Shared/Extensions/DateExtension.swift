//
//  DateExtension.swift
//  SkillTrees
//
//  Created by Lucas Pennice on 19/08/2024.
//

import Foundation

extension Date {
    func dateInDays(_ days: Int) -> Date {
        /// Returns the date in N days from the given date, can also receive a negative integer
        let dateComponents = Calendar.current.dateComponents(in: .current, from: self)

        let newDateComponents = DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day! + days)
        let newDate = Calendar.current.date(from: newDateComponents)!

        return newDate
    }
}
