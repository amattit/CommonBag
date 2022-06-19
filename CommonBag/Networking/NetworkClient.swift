//
//  NetworkClient.swift
//  CommonBag
//
//  Created by MikhailSeregin on 19.06.2022.
//

import Foundation
import Networking
import Combine

protocol NetworkClientProtocol {
    func execute<T: Decodable>(api: APICall, type: T.Type) -> AnyPublisher<T, Error>
    func executeData(api: APICall) -> AnyPublisher<Data, Error>
}

final class NetworkClient: NetworkClientProtocol, WebRepository {
    var session: URLSession = .shared
    
    var baseURL: String = "https://product-list-dev.herokuapp.com"
    
    let queue: DispatchQueue = .init(label: "Networking")
    
    let decoder: JSONDecoder = .init()
    
    func execute<T: Decodable>(api: APICall, type: T.Type) -> AnyPublisher<T, Error> {
        call(endpoint: api, httpCodes: .success, decoder: decoder, errorType: ServerError.self)
    }
    
    func executeData(api: APICall) -> AnyPublisher<Data, Error> {
        callData(endpoint: api, httpCodes: .success, decoder: decoder, errorType: ServerError.self)
    }
    
    struct ServerError: Codable {
        let error: Bool
        let reason: String
    }
}

