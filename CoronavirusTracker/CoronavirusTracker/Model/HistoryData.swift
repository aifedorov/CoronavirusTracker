//
//  HistoryData.swift
//  CoronavirusTracker
//
//  Created by Александр Федоров on 26.04.2020.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

struct HistoryData: Codable {
    struct Timeline: Codable {
        let cases: [String: Int]
        let deaths: [String: Int]
        let recovered: [String: Int]
    }

    let country: String
    let timeline: Timeline
}
