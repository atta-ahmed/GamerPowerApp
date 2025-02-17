//
//  Extensions.swift
//  GamerPowerApp
//
//  Created by Atta ElAshmawy, Vodafone on 17/02/2025.
//

import Foundation

extension String {
    // Helper function to format date string
    func toFormattedDate() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        }
        return self
    }
}
