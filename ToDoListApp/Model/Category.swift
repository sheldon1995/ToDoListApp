//
//  Category.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/17/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    // Build relationship using realm
    let items = List<Item>()
}
