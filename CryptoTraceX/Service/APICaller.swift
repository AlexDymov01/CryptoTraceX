//
//  APICaller.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 30.08.2023.
//

import Foundation

enum CustomError: Error {
    case invalidURL
    case invalidData
}

protocol APICallerProtocol {
    func makeRequest<T: Decodable>(with url: URL?, expecting: T.Type, completion: @escaping(Result<T, Error>) -> Void)
}

final class APICaller: APICallerProtocol {
    
    func makeRequest<T: Decodable>(with url: URL?, expecting: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
        guard let url = url else {
            return completion(.failure(CustomError.invalidURL))
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return completion(.failure(CustomError.invalidData))
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        } .resume()
    }
}
