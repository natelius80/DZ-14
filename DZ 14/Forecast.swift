//
//  Forecast.swift
//  DZ 14
//
//  Created by Питонейшество on 21/11/2019.
//  Copyright © 2019 Питонейшество. All rights reserved.
//

import Foundation
import RealmSwift


class Forecast: Object {
    
    @objc dynamic var date = ""
    @objc dynamic var icon = ""
    @objc dynamic var temp: Int = 0
}
