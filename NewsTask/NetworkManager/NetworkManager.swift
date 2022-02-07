//
//  NetworkManager.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 4.02.22.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
 
    private init() {}
    

    public func getCurrentDayNews(pagination: Bool, url: URL?,completion: @escaping (Result<[Article],Error>) -> Void){
       
        guard let url = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                    
                    
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getPaginatedNews(pagination: Bool, url: URL?,completion: @escaping (Result<[Article],Error>) -> Void){
        
        guard let url = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                   
                    
                }
                catch{
                    completion(.failure(error))
//                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

}



