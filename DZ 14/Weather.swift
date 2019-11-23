//
//  Weather.swift
//  DZ 14
//
//  Created by Питонейшество on 20/11/2019.
//  Copyright © 2019 Питонейшество. All rights reserved.
//

import Foundation
import RealmSwift


class Weather: Object {
    
    @objc dynamic var city = ""
    @objc dynamic var descript = ""
    @objc dynamic var icon = ""
    @objc dynamic var temp: Int = 0
}

