//
//  RealmHelper.swift
//  ToDo
//
//  Created by Apple Macbook on 29/05/2023.
//

import Foundation

class RealmHelper {
    static func DetachedCopy<T:Codable>(of object:T) -> T?{
        do{
            let json = try JSONEncoder().encode(object)
            return try JSONDecoder().decode(T.self, from: json)
        }
        catch let error{
            print(error)
            return nil
        }
    }
}
