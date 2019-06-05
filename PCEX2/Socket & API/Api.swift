//
//  Api.swift
//  PCEX
//
//  Created by CHHAGAN on 15/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KRProgressHUD
class Api {
    
    static let base = APP_BASE_URL
    
    static let userId = APP_Defaults.value(forKey: "userId") as! Int
    static let sessionId = APP_Defaults.value(forKey: "sessionId") as! String
    static let fastSessionId = APP_Defaults.value(forKey: "fastSessionId") as! Int
    
    
    
    static let testingServer = "http://localhost:3333"
    
    /**
     * An abstraction layer on top of the Gemini API to allow for simple handeling of API
     * calls in a more standard way.
     *
     * - property method: the HTTP method (post, get, ...) of the request
     * - property path: The path of the request
     */
    
    // ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"pageNumber":pageNumber]
    public enum Endpoints {
        case login(username:String, password:String)
        case registrUser(name:String, email:String, country:String, phone:Int, role:Int, city:String, pincode:Int, countryCode:Int, subbrokerCode: String)
        case re_sendOtp(name:String, email:String, country:String, phone:Int, role:Int, city:String, pincode:Int, countryCode:Int, subbrokerCode: String)
        case verifyRegisterOtp(name:String, email:String, country:String, phone:Int, role:Int, city:String, pincode:Int, countryCode:Int, subbrokerCode: String,secretKey:String,fastSecretKey:String,otp:String)
        case userRegisterRequest(name:String, email:String, country:String, phone:Int, role:Int, city:String, pincode:Int, countryCode:Int, subbrokerCode: String,secretKey:String,fastSecretKey:String,otp:String,password:String)
        case changePassword(currentPassword:String, newPassword:String)
        case getOrders(pageNumber:Int)
        case getPendingOrders(pageNumber:Int, filters:[String:Int])
        case getTrades(pageNumber:Int)
        case getUserLedger(pageNumber:Int, currency:String)
        case getNetposition(offset:Int)
        case getPlaceOrder(category:Int, clientUserId:String, orderQty:Float, orderRate:Float, orderType: Int, symbolId:Int,symbolName:String ,market:String)
        case getCancelOrder(symbolId:String,orderType:Int,orderId:Int)
        case getModifyOrder(symbolId:String,orderId:Int,newOrderQty:Double,newOrderRate:Double)
        case getTransactionHistory(pageNumber:Int,type:Int,currency:String,status:Int)
        case getCancelWithdrawRequest(requestId:String,type:String)
        case getWalletAddress(coin:String)
        case getDeposit(amount:String, currency:String, transactionId:String, userRemarks:String,process:Int, address:String, couponCode:String, couponPin:Int)
        case getWithdrawal(params:[String:Any])
        case addBank(params:[String:Any])
        case deleteBank(param:String)
        case getBanks
        case Balances()
        //case getConditionalOrders()
        case TradeHistory(symbol: String, since: Int64, limit: Int?, includeBreaks: Bool?)
        
        
        public var method: HTTPMethod {
            switch self {
            case .login:
                return .post
            case .registrUser:
                return .post
            case .re_sendOtp:
                return .post
            case .verifyRegisterOtp:
                return .post
            case .userRegisterRequest:
                return .post
            case .changePassword:
                return .post
            case .getOrders:
                return .post
            case .getPendingOrders:
                return .post
            case .getTrades:
                return .post
            case .getUserLedger:
                return .post
            case .getNetposition:
                return .post
            case .getPlaceOrder:
                return .post
            case .getCancelOrder:
                return .post
            case .getModifyOrder:
                return .post
            case .getTransactionHistory:
                return .post
            case .getCancelWithdrawRequest:
                return .post
            case .getWalletAddress:
                return .post
            case .getDeposit:
                return .post
            case .getWithdrawal:
                return .post
            case .addBank:
                return .post
            case .deleteBank:
                return .post
            case .getBanks:
                return.post
            case .Balances:
                return .post
            case .TradeHistory:
                return .get
                
            }
        }
        
        public var path: String {
            switch self {
            case .login:
                return "/admin/login"
            case .registrUser:
                return "/register/checkUser"
            case .re_sendOtp:
                return "/register/resendOTP"
            case .verifyRegisterOtp:
                return "/register/verifyOtp"
            case .userRegisterRequest:
                return "/register/userRegisterRequest"
            case .changePassword:
                return "/userUtils/changePassword"
            case .getOrders:
                return "/market/getOrders"
            case .getPendingOrders:
                return "/market/getOrders"
            case .getTrades:
                return "/market/getTrades"
            case .getUserLedger:
                return "/market/getLedger"
            case .getNetposition:
                return "/market/getNetPosition"
            case .getPlaceOrder:
                return "/market/placeOrder"
            case .getCancelOrder:
                return "market/cancelOrder"
            case .getModifyOrder:
                return "market/modifyOrder"
            case .getTransactionHistory:
                return "/wallet/getDepositWithdrawalHistory"
            case .getCancelWithdrawRequest:
                return "/wallet/cancelWithdrawRequest"
            case .getWalletAddress:
                return "/wallet/getWalletAddress"
            case .getDeposit:
                return "/wallet/submitDepositRequest"
            case .getWithdrawal:
                return "/wallet/submitWithdrawRequest"
            case .addBank:
                return "/wallet/addBankDetailsOfUser"
            case .deleteBank:
                return "/wallet/deleteSelectedBank"
            case .getBanks:
                return "/wallet/getBanksOfSpecificUser"
            case .Balances:
                return "/v1/balances"
            case .TradeHistory(let symbol, _, _, _):
                return "/v1/trades/\(symbol)"
            }
        }
        
        public var url: String {
            
             let server = APP_Defaults.object(forKey: "server") as! String
            
             let urlconcat = "\(base)\(server)\(self.path)"
           // let urlconcat = "\(base)\("api2")\(self.path)"
            
            // testing server
            //let urlconcat = "\(testingServer)\(self.path)"
            //let urlconcat = "\(base)\("api1")\(self.path)"
            
            return urlconcat
        }
        
        public var parameters: [String : Any] {
            switch self {
            case .login(let username, let password):
                return ["username":username,"password":password]
            case .registrUser(let name,let email,let country, let phone, let role, let city, let pincode, let countryCode, let subbrokerCode):
                return ["name":name,"email":email,"country":country,"phone":phone,"role":role,"city":city,"pincode":pincode,
                        "countryCode":countryCode, "subbrokerCode":subbrokerCode]
                
            case .re_sendOtp(let name,let email,let country, let phone, let role, let city, let pincode, let countryCode, let subbrokerCode):
                return ["name":name,"email":email,"country":country,"phone":phone,"role":role,"city":city,"pincode":pincode,
                        "countryCode":countryCode, "subbrokerCode":subbrokerCode]
                
            case .verifyRegisterOtp(let name,let email,let country, let phone, let role, let city, let pincode, let countryCode, let subbrokerCode,let secretKey,let fastSecretKey,let otp):
                return ["name":name,"email":email,"country":country,"phone":phone,"role":role,"city":city,"pincode":pincode,
                        "countryCode":countryCode, "subbrokerCode":subbrokerCode,"secretKey":secretKey,"fastSecretKey":fastSecretKey,"otp":otp]
                
            case .userRegisterRequest(let name,let email,let country, let phone, let role, let city, let pincode, let countryCode, let subbrokerCode,let secretKey,let fastSecretKey,let otp, let password):
                return ["name":name,"email":email,"country":country,"phone":phone,"role":role,"city":city,"pincode":pincode,
                        "countryCode":countryCode, "subbrokerCode":subbrokerCode,"secretKey":secretKey,"fastSecretKey":fastSecretKey,"otp":otp,"password":password]
                
            case .changePassword(let currentPassword, let newPassword):
                    return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId, "currentPassword":currentPassword,"newPassword":newPassword]
                
            case .getOrders(let pageNumber):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"pageNumber":pageNumber]
                
            case .getPendingOrders(let pageNumber,let filters):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"pageNumber":pageNumber,"filters":filters]
                
            case .getTrades(let pageNumber):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"pageNumber":pageNumber]
                
            case .getUserLedger(let pageNumber,let currency):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"pageNumber":pageNumber,"currency":currency]
                
            case .getNetposition(let offset):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"offset":offset]
                
            case .getPlaceOrder(let category,let clientUserId,let orderQty,let orderRate,let orderType,let symbolId,let symbolName, let market):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId, "category":category, "clientUserId":clientUserId, "orderQty":orderQty, "orderRate":orderRate, "symbolId":symbolId, "market":market,"symbolName":symbolName,"orderType":orderType]
            case .getCancelOrder(let symbolId,let orderType,let orderId):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"symbolId":symbolId,"orderType":orderType,"orderId":orderId]
                
            case .getModifyOrder(let symbolId,let orderId,let newOrderQty,let newOrderRate):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"symbolId":symbolId,"newOrderQty":newOrderQty,"orderId":orderId,"newOrderRate":newOrderRate]
            case .getTransactionHistory(let pageNumber,let type,let currency,let status):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"pageNumber":pageNumber,"type":type,"currency":currency,"status":status]
                
            case .getCancelWithdrawRequest(let requestId,let type):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"requestId":requestId,"type":type]
                
            case .getWalletAddress(let coin):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"coin":coin]
                
            case .getDeposit(let amount, let currency, let transactionId, let userRemarks, let process, let address, let couponCode, let couponPin):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"amount":amount,"currency":currency,"transactionId":transactionId,"userRemarks":userRemarks,"process":process, "address":address, "couponCode":couponCode, "couponPin":couponPin]
            case .getWithdrawal(let params):
                let userDetails = ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId] as [String : Any]
                return userDetails.merging(params, uniquingKeysWith: { (first, _) in first })
            
            case .addBank(let bank):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"bank":bank]
                
            case .deleteBank(let bankId):
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId,"bankId":bankId]
            case .getBanks:
                return ["userId":userId,"sessionId":sessionId,"fastSessionId":fastSessionId]
                
            case .TradeHistory(_, let since, let limit, let breaks):
                return ["include_breaks": String(breaks ?? false), "limit_trades": limit ?? 50, "timestamp": since * 1000]
            default:
                return [:]
            }
        }
        
        public var headers: HTTPHeaders {
            switch self {
            case .Balances:
                return createHeaders(request: self.path)
//            case .getPendingOrders:
//                return createHeaders(request: self.path)
            default:
                return [:]
            }
        }
        
    }
    
    
    /**
     Create HTTP Headers for a gemini request
     
     - parameter request: the path, ex: "/v1/order/status", of the request.
     - parameter additionalData: the additional payload data requested by the API
     
     - returns: the http headers for the request
     */
    private static func createHeaders(request: String, withAdditionalData additionalData: JSON? = nil) -> HTTPHeaders {
        
        var payload = additionalData ?? JSON()
        let nonce = Int64(Date().timeIntervalSince1970 * 1000)
        payload["request"] = JSON(request)
        payload["nonce"]  = JSON(String(nonce))
        // let payloadb64 = payload.serialize().toBase64()
        
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        // headers["Content-Type"] = "application/json"
        //    headers["Content-Length"] = "0"
        //        headers["X-GEMINI-APIKEY"] = apiKey
        //        headers["X-GEMINI-PAYLOAD"] = payloadb64
        //        headers["X-GEMINI-SIGNATURE"] = payloadb64.hmac(algorithm: .SHA384, key: apiSecret)
        
        headers["Cache-Control"] = "no-cache"
        
        return headers
    }
    
    /**
     Make a request to the gemini API
     
     - parameter endpoint: the API endpoint
     - parameter completionHandler: the function to handle the JSON response from the API
     */
    public static func request(endpoint: Api.Endpoints, completionHandler: @escaping (JSON) -> Void) {
        // KRProgressHUD.show(withMessage: "Loading...")
        let manager = Alamofire.SessionManager.default
        
        manager.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default, headers: endpoint.headers).responseJSON { (response) in
            print("params for request",endpoint.parameters)
            KRProgressHUD.dismiss()
            print(response.request?.url ?? "na")
            if (response.result.value != nil) {
                completionHandler(JSON(response.result.value!))
            } else {
                if (response.result.error != nil) {
                    
                    print(response.result.error!) // known error
                } else {
                    print("Unkown error") // unkown error
                }
            }
        }

        
        
        
        //        Alamofire.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, headers: endpoint.headers).responseJSON { (response) in
        //           // print("params for request",endpoint.parameters)
        //            print(response.request?.url ?? "na")
        //            if (response.result.value != nil) {
        //                completionHandler(JSON(response.result.value!))
        //            } else {
        //                if (response.result.error != nil) {
        //                    print(response.result.error!) // known error
        //                } else {
        //                    print("Unkown error") // unkown error
        //                }
        //            }
        //        }
    }
    
    
}


extension JSON {
    
    // serialize the json into a standard JSON string
    func serialize() -> String {
        let s0: String = self.rawString() ?? ""
        let s1: String = s0.replacingOccurrences(of: "\\/", with: "/")
        return s1
    }
    
}


extension String {
    
    // appends the <path> with slashes before and after it, if not already present
    mutating func appendPath(path: String) {
        self.append((self.last == "/" || path.first == "/" ? "":"/") + path + (path.last == "/" ? "" : "/"))
    }
    
}
