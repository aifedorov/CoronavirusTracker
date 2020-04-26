//
//  String+Localized.swift
//  CoronavirusTracker
//
//  Created by Александр Федоров on 26.04.2020.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
