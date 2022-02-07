//
//  DateExtension.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 7.02.22.
//

import Foundation

extension Date {
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
