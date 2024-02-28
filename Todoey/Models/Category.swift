//
//  Category.swift
//  Todoey
//
//  Created by ANSH on 26/02/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var Color : String = ""
    let items = List<Item>()
    
}
