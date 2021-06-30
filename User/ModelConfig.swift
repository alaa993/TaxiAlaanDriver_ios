//
//  ModelConfig.swift
//  Provider
//
//  Created by AlaanCo on 11/29/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import Foundation
struct ModelConfig : Codable {
    let location_refresh_interval : Int?
    let mqtt : Mqtt?
    
    enum CodingKeys: String, CodingKey {
        
        case location_refresh_interval = "location_refresh_interval"
        case mqtt = "mqtt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location_refresh_interval = try values.decodeIfPresent(Int.self, forKey: .location_refresh_interval)
        mqtt = try values.decodeIfPresent(Mqtt.self, forKey: .mqtt)
    }
    
}


struct Mqtt : Codable {
    let server : String?
    let port : String?
    let qos : String?
    let env : String?
    
    enum CodingKeys: String, CodingKey {
        
        case server = "server"
        case port = "port"
        case qos = "qos"
        case env = "env"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        server = try values.decodeIfPresent(String.self, forKey: .server)
        port = try values.decodeIfPresent(String.self, forKey: .port)
        qos = try values.decodeIfPresent(String.self, forKey: .qos)
        env = try values.decodeIfPresent(String.self, forKey: .env)
    }
    
}
