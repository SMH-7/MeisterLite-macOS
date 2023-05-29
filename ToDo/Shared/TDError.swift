//
//  TDError.swift
//  ToDo
//
//  Created by Apple Macbook on 29/05/2023.
//

import Foundation

enum TDError: Error {
    case signInFailed(String)
    case registerationFailed(String)
    case ViewBindingError(String)

}

