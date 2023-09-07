//
//  NetworkService.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 13.06.2023.
//

import UIKit
import Alamofire

class NetworkService {
    
    func getTracks(searchText: String) async throws -> SearchResponse {
        let stringUrl = "https://itunes.apple.com/search"
        let parameters = ["term": "\(searchText)", "limit": "30", "media":"music"]
        
        return try await withCheckedThrowingContinuation({ continuation in
            AF.request(stringUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { response in
                
                switch response.result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                        continuation.resume(returning: response)
                    } catch let error {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}
