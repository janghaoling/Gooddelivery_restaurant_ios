//
//  RemoveCategoryEntity.swift
//  OrderAroundRestaurant
//
//  Created by CSS on 14/03/19.
//  Copyright © 2019 CSS. All rights reserved.
//

import Foundation
import ObjectMapper

struct RemoveCategoryModel : Mappable {
    var message : String?
    var error: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        message <- map["message"]
        error <- map["error"]
    }
    
}
