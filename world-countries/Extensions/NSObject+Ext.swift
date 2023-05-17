//
//  NSObject+Ext.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 13.05.2023.
//

import Foundation

///Writing small utility functions
func configure<T>(_ value: T, using closure: (inout T) throws -> Void) rethrows -> T {
    var value = value
    try closure(&value)
    return value
}

extension NSObject {
    static var typeName: String {
        String(describing: self)
    }
}
