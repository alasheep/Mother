//
//  String.swift
//  Mother
//
//  Created by Apple on 20/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
