//
//  HelperFunctions.swift
//  PCEX2
//
//  Created by Himanshu Jha on 03/08/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class HelperFunctions   {
    
    
    static func jsonToString (value : AnyObject ) -> String
    {
        do{
            let data = try JSONSerialization.data(withJSONObject: value);
            
            if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            {
                return str as String;
            }
        }
        catch
        {
            print("erroror");
            
        }
        return "haha";
//
//        guard let dataAsString = String(data: value, encoding: .utf8) else { return "No Object Found" }
//        return dataAsString
    }
    
    static func stringToJson (value : String ) -> JSON {

        do{
            let jsonData =  try JSON(value)
            return jsonData
        }
        catch let jsonErr   {
           print ("Failed to convert string to JSON \(jsonErr)")
        }
    }
        
        static func test()
        {
            let jsonObject:[String:Any] =
            [
                "type_id": 1,
                "model_id": 1
            ];
            
            let str = jsonToString(value:jsonObject as AnyObject);
            print(str);
            
            var json2 = stringToJson(value: str);
            
            print(json2);
            
            
        }
    
}


