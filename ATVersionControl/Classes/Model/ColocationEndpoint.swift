//
//  ColocationEndpoint.swift
//  ATVersionControl
//
//  Created by Amir on 7/13/26.
//
public class ColocationEndpoint {
    public var name = ""
    public var baseURL = ""

    class func from(json object: [String: Any]?) -> ColocationEndpoint? {
        guard let object = object else {
            return nil
        }

        let result = ColocationEndpoint()
        result.name = object["Name"] as? String ?? ""
        result.baseURL = object["BaseUrl"] as? String ?? ""

        guard !result.name.isEmpty, !result.baseURL.isEmpty else {
            return nil
        }

        return result
    }
}
