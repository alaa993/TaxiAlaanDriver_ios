//
//  ModelTransactionLog.swift
//  User
//
//  Created by AlaanCo on 4/20/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import Foundation
struct ModelTransactionLog : Codable {
    let id : Int?
    let admin_id : Int?
    let transactionable_id : Int?
    let transactionable_type : String?
    let type : String?
    let status : String?
    let amount : Int?
    let remain_balance : Int?
    let commission : Int?
    let created_at : String?
    let updated_at : String?
    let cash:Int?
    let discount:Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case admin_id = "admin_id"
        case transactionable_id = "transactionable_id"
        case transactionable_type = "transactionable_type"
        case type = "type"
        case status = "status"
        case amount = "amount"
        case remain_balance = "remain_balance"
        case commission = "commission"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case cash = "cash"
        case discount = "discount"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        admin_id = try values.decodeIfPresent(Int.self, forKey: .admin_id)
        transactionable_id = try values.decodeIfPresent(Int.self, forKey: .transactionable_id)
        transactionable_type = try values.decodeIfPresent(String.self, forKey: .transactionable_type)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        remain_balance = try values.decodeIfPresent(Int.self, forKey: .remain_balance)
        commission = try values.decodeIfPresent(Int.self, forKey: .commission)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        cash = try values.decodeIfPresent(Int.self, forKey: .cash)
        discount = try values.decodeIfPresent(Int.self, forKey: .discount)
    }
    
}
