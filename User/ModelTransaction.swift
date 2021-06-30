//
//  ModelTransaction.swift
//  User
//
//  Created by AlaanCo on 4/19/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import Foundation
struct ModelTransaction : Codable {
    let message : String?
    let error : String?
    let first_name: String?
    let last_name: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        
        case message = "message"
        case error = "error"
        case first_name = "first_name"
        case last_name = "last_name"
        case type = "type"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        
    }
    
}
