//
//  SearchableRecord.swift
//  Continuum-CloudKit
//
//  Created by Jordan Lamb on 10/16/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
