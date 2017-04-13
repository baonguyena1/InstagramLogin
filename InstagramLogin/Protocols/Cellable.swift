//
//  Cellable.swift
//  MVVMJSONTutorial
//
//  Created by Bao Nguyen on 4/9/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation

protocol Cellable {
    static func cellIdentifier() -> String
}

extension Cellable {
    static func cellIdentifier() -> String {
        return "cellId"
    }
}
