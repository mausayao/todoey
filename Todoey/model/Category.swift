//
//  Category.swift
//  Todoey
//
//  Created by Maurício de Freitas Sayão on 03/06/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let activities = List<Activity>()
}
