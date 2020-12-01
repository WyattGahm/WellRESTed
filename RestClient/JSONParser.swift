//
//  JSONParser.swift
//  RestClient
//  only as useful as i need it to be
//  Created by Wyatt Gahm on 11/25/20.
//

import Foundation

public class JSONParser{
    init(){}
    public func dictForJSON(_ data:Data) -> [String:String]{
        var ret: [String:String] = [:]
        let terms = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\"")
        for n in 0...(terms.count - 1) {
            let index = (terms.count - 1) - n
            if terms[index] == ":" {
                ret[String(terms[index-1])] = String(terms[index+1])
            }
        }
        return ret
    }
    public func listForJSON(ID:String,_ data:Data) -> [String]{
        var ret: [String] = []
        let terms = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\"")
        for index in 0...(terms.count - 1) {
            if terms[index] == ":",terms[index - 1] == ID{
                ret.append(String(terms[index+1]))
            }
        }
        return ret
    }
}
