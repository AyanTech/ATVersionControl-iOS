//
//  ColocationEndpoint.swift
//  ATVersionControl
//
//  Created by Amir on 7/13/26.
//
import SwiftBooster

public class ColocationEndpoint {
    public var name = ""
    public var baseURL = ""

    class func from(json object: JSONObject?) -> ColocationEndpoint? {
        guard let object = object else {
            return nil
        }

        let result = ColocationEndpoint()
        result.name = getValue(input: object, subscripts: "Name") ?? ""
        result.baseURL = getValue(input: object, subscripts: "BaseUrl") ?? ""

        guard !result.name.isEmpty, !result.baseURL.isEmpty else {
            return nil
        }

        return result
    }
}
