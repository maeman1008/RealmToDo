//
//  Item.swift
//  RealmToDo
//
//  Created by Maeda Ryoto on 2015/07/20.
//  Copyright (c) 2015年 Maeda Ryoto. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    dynamic var name = ""
    dynamic var finished = false
}
