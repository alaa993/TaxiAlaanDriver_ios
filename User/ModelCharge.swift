//
//  Model.swift
//  User
//
//  Created by AlaanCo on 4/19/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import Foundation
struct ModelCharge : Codable {
    let message : String?
    let error : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
        case error = "error"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        
    }
    
}
