//
//  NetworkService.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 13.06.2023.
//

import UIKit
import Alamofire

class NetworkService {
    
//    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
//        let stringUrl = "https://itunes.apple.com/search"
//        let parameters = ["term": "\(searchText)", "limit": "10", "media":"music"]
//
//        AF.request(stringUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { response in
//            if let error = response.error {
//                print(error.localizedDescription)
//            }
//
//            guard let data = response.data else { return }
//
//            let decoder = JSONDecoder()
//            do {
//                let response = try decoder.decode(SearchResponse.self, from: data)
//                completion(response)
//            } catch let error {
//                print(error.localizedDescription)
//                completion(nil)
//            }
//        }
//    }
    
    func fetchTracks(searchText: String) async throws -> SearchResponse {
        let stringUrl = "https://itunes.apple.com/search"
        let parameters = ["term": "\(searchText)", "limit": "10", "media":"music"]
        
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
