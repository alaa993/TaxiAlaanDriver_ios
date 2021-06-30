//
//  ModelResponseMqtt.swift
//  Provider
//
//  Created by kavos khajavi on 12/3/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import Foundation

struct ModelResponseMqtt : Codable {
    let time : Int64?
    let status : Int?
    let token : String?

    enum CodingKeys: String, CodingKey {

        case time = "time"
        case status = "status"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        time = try values.decodeIfPresent(Int64.self, forKey: .time)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}
