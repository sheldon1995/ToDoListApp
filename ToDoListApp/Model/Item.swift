//
//  Item.swift
//  ToDoListApp
//
//  Created by Sheldon on 3/17/20.
//  Copyright © 2020 wentao. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated :Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
