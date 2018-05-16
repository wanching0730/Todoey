//
//  Category.swift
//  Todoey
//
//  Created by Wan Ching on 26/04/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
