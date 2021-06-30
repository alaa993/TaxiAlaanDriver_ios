//
//  Service.swift
//  User
//
//  Created by AlaanCo on 4/16/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

 struct ServiceAPI {
    
    static let shared = ServiceAPI()
    
    func fetchGenericData<T: Decodable>(urlString: String,parameters:Parameters,methodInput:HTTPMethod,isHeaders:Bool = false , completion: @escaping (T? , Error?,Int?) -> ()) {
        
        var headers:HTTPHeaders? = nil
        if isHeaders {
            headers = [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")",
                "X-Requested-With": "XMLHttpRequest"
            ]
        }
        
        Alamofire.request(SERVICE_URL+urlString, method: methodInput, parameters: parameters, encoding:URLEncoding.default, headers: headers).responseData { response in
            switch response.result {
                
            case .success:
                
                let  jsonDecoder = JSONDecoder()
                guard let data = response.result.value else { completion(nil,nil,response.response?.statusCode); return }
                
                do {
                    let json = try jsonDecoder.decode(T.self, from: data)
                    completion(json, nil,response.response?.statusCode)
                    
                }catch let error{
                    completion(nil,error,response.response?.statusCode)
                }
                
            case .failure(let error):
                
                completion(nil,error,response.response?.statusCode)
                
            }
            
        }
        
        
    }
    
}
