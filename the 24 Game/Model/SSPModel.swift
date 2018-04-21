//
//  SSPModel.swift
//  Dice
//
//  Created by Fangchen Li on 1/2/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import Foundation
import SwiftHTTP

class SeraphSystemProtocol{
    var baseURL: String = "http://raspberrypi.local:20002"
    var remoteBaseURL: String = "https://seraph.applicationclick.com/the24"
    var remoteBase: String = "https://seraph.applicationclick.com"
    var localFailCount: Int = 0
    var maxLocalFailCount: Int = 3
    var firstNotification: Bool = true
    
    
    enum SSPConnectionType {
        case automatic
        case local
        case remote
        case login
    }
    
    func isLocalAvalible() -> Bool{
        return false
    }
    
    func reportDeviceIdentity(){
        let param:[String: String] = [
            "UUID"          : TFGame.mobileDevice.UUID,
            "APNSToken"     : TFGame.mobileDevice.APNSToken,
            "name"          : TFGame.mobileDevice.name,
            "numberOfRolls" : String(TFGame.RecordSystem.numberOfRolls)
        ]
        self.webCall(method: "GET", url: "/mobile/deviceIdentity", parameters: param, forceSource: .remote, completion:{
            (status,result) in
            
        })
        
    }
    
    
    func webCall(method:String, url: String, parameters: [String:String], forceSource: SSPConnectionType, completion: @escaping (_ status: Bool, _ result: Data) -> Void){
        
        var param = parameters
        
        do {
            var apiBase: String = self.baseURL
            
            switch (forceSource){
            case .automatic:
                if !self.isLocalAvalible(){
                    fallthrough
                }   else{
                    apiBase = self.baseURL
                    break
                }
            case .remote:
                apiBase = self.remoteBaseURL
            
                break
            case .local:
                print("force refresh on local network")
                apiBase = self.baseURL
                break
                
            case .login:
                apiBase = self.remoteBase
                break
                
            }
            
            var opt: HTTP
            switch method{
            case "POST":
                opt = HTTP.POST(apiBase + url, parameters: param)!
                break
            default:
                opt = HTTP.GET(apiBase + url, parameters: param)!
                break
            }
            //print("requesting " + apiBase + url)
            opt.run { response in
                //print("Response From \(response.URL)")
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    if(apiBase == self.baseURL){
                        self.localFailCount = self.localFailCount + 1
                    }
                    
                    completion(false, Data())
                    return //also notify app of failure as needed
                }
                completion(true, response.data)
                if(apiBase == self.baseURL){
                    self.localFailCount = 0
                }
                
                //print("opt finished: \(response.description)")
                //print("data is: \(response.data)") access the response of the data with response.data
            }
        } catch let error {
            completion(false, Data())
            print("got an error creating the request: \(error)")
        }
    }

}


