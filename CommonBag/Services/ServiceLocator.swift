//
//  ServiceLocator.swift
//  CommonBag
//
//  Created by MikhailSeregin on 07.07.2022.
//

import Foundation

protocol ServiceLocatorProtocol {
    func getService<T>() -> T?
}

final class ServiceLocator: ServiceLocatorProtocol {
    private lazy var reg: [String: AnyObject] = [:]
    
    func addService<T>(service: T) {
        let key = "\(type(of: service))"
        reg[key] = service as AnyObject
    }
    
    func getService<T>() -> T? {
        let key = "\(T.self)"
        return  reg[key] as? T
    }
}
