//
//  Item.swift
//  Todoey
//
//  Created by Wan Ching on 26/04/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
