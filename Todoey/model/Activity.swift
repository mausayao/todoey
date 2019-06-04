//
//  Activity.swift
//  Todoey
//
//  Created by Maurício de Freitas Sayão on 03/06/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import Foundation
import RealmSwift

class Activity: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isChecked: Bool = false
    var category = LinkingObjects(fromType: Category.self, property: "activities")
}
