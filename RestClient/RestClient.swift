//
//  RestClient.swift
//  RestClient
//
//  Created by Wyatt Gahm on 11/25/20.
//

import Foundation

public struct RestResponse:CustomStringConvertible{
    var _version: String
    var _changedby: String
    var _createdby: String
    var _changed: String
    var _created: String
    var _id: String
    
    init(){
        self.init(["":""])
    }
    
    init(_ data:[String:String]){
        self._id = data["_id"] ?? ""
        self._version = data["_version"] ?? ""
        self._changed = data["_changed"] ?? ""
        self._changedby = data["_changedby"] ?? ""
        self._created = data["_created"] ?? ""
        self._createdby = data["_createdby"] ?? ""
    }
    
    init(_ _version: String ,_ _changedby: String, _ _createdby: String,_ _changed: String, _ _created: String, _ _id: String){
        self._version = _version
        self._changedby = _changedby
        self._createdby = _createdby
        self._changed = _changed
        self._created = _created
        self._id = _id
    }
    public var description:String {
        return """
        ID: \(self._id)
        Created: \(self._created)
        CreatedBy: \(self._createdby)
        Version: \(self._version)
        changed: \(self._changed)
        ChangedBy: \(self._changedby)
        """
    }
}

enum RestClientError:Error {
    case wrongKey
    case generic
    case requestError
    case wrongURL
}

public class RestClient {
    let server:URL
    let APIKey:String
    public init(host:URL,key:String){
        if(host.absoluteString.hasSuffix("/")){
            server = URL(string: String(host.absoluteString.prefix(host.absoluteString.count - 1))) ?? host
        }else{
            server = host
        }
        APIKey = key
    }
    public func extendContext(UUID:String) -> RestClient{
        if server.absoluteString.hasSuffix("/"){
            return RestClient(host: URL(string:server.absoluteString + UUID)!,key: APIKey)
        } else {
            return RestClient(host: URL(string:server.absoluteString + "/" + UUID)!,key: APIKey)
        }
    }
    public func getValueForID(id:String, callback:@escaping (String,RestResponse) -> ()){
        return getValueForID(url: server, id: id){value,response in callback(value,response)}
    }
    
    public func getURL() -> URL{
        return server
    }
    
    public func createValueForID(id:String, value:String){
        createValueForID(id: id,value: value,completion: {_ in })
    }
    
    public func getValueForID(url:URL, id:String, _ callback:@escaping (String,RestResponse) -> ()){
        var request = URLRequest(url:url)
        request.setValue(APIKey,forHTTPHeaderField: "x-apikey")
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer {dataTask = nil}
            if let data = data, let response = response as? HTTPURLResponse{
                if response.statusCode != 200 {
                    print("oh shit we got \(response.statusCode) instead of 200")
                }
                callback(JSONParser().dictForJSON(data)[id] ?? "",RestResponse(JSONParser().dictForJSON(data)))
            }
        }
        dataTask?.resume()
    }
    public func createValueForID(id:String, value:String,completion:@escaping (RestResponse)->()){
        var request = URLRequest(url:server)
        request.setValue(APIKey,forHTTPHeaderField: "x-apikey")
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        let bodyData = try? JSONSerialization.data( withJSONObject: [id:value], options: [])
        request.httpBody = bodyData
        request.httpMethod = "POST"
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer {dataTask = nil}
            if let data = data, let response = response as? HTTPURLResponse{
                if response.statusCode != 200 {
                    print("oh shit we got \(response.statusCode) instead of 200")
                }
                completion(RestResponse(JSONParser().dictForJSON(data)))
            }
        }
        dataTask?.resume()
    }
    
    public func patchValueForID(id:String, value:String){
        patchValueForID(id: id, value: value, completion: {_ in})
    }
    public func patchValueForID(id:String, value:String,completion: @escaping (RestResponse)->()){
        var request = URLRequest(url:server)
        request.setValue(APIKey,forHTTPHeaderField: "x-apikey")
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        let bodyData = try? JSONSerialization.data( withJSONObject: [id:value], options: [])
        request.httpBody = bodyData
        request.httpMethod = "PATCH"
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer {dataTask = nil}
            if let data = data, let response = response as? HTTPURLResponse{
                if response.statusCode != 200 {
                    print("oh shit we got \(response.statusCode) instead of 200")
                }
                completion(RestResponse(JSONParser().dictForJSON(data)))
            }
        }
        dataTask?.resume()
    }
    
    public func getUUIDs(_ completion: @escaping([String])->()){
        var request = URLRequest(url:server)
        request.setValue(APIKey,forHTTPHeaderField: "x-apikey")
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer {dataTask = nil}
            if let data = data, let response = response as? HTTPURLResponse{
                if response.statusCode != 200 {
                    print("oh shit we got \(response.statusCode) instead of 200")
                }
                completion(JSONParser().listForJSON(ID:"_id",data))
            }
        }
        dataTask?.resume()
    }
    //deletevalueforid
}
