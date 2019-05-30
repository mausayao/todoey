//
//  Activity.swift
//  Todoey
//
//  Created by Maurício de Freitas Sayão on 29/05/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import Foundation

class Activity: Codable {
    var title: String
    var isChecked: Bool
    
    init(_ title: String, _ isChecked: Bool) {
        self.title = title
        self.isChecked = isChecked
    }
}
