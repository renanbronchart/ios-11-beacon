//
//  helperDateFormatter.swift
//  ios-beacon-presence
//
//  Created by Renan Bronchart on 27/04/2018.
//  Copyright © 2018 Renan Bronchart. All rights reserved.
//

import Foundation

extension Formatter {
    // Add extension formatter date to transform date to iso8601
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
