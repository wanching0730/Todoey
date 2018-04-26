//
//  Data.swift
//  Todoey
//
//  Created by Wan Ching on 26/04/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    // dynamic allow this variable to be modified at runtime so that realm can update the changes dynamically on the database
    // it is from objective C runtime
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
