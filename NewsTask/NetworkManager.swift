//
//  NetworkManager.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 4.02.22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    // Struct: Constants
    var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
    let fromDate = URLQueryItem(name: "from", value: "2022-02-05")
    let toDate = URLQueryItem(name: "to", value: "2022-02-06")
    let language = URLQueryItem(name: "language", value: "en")
    let domains = URLQueryItem(name: "domains", value: "bbc.co.uk, techcrunch.com, engadget.com")
    
    
    
    let secretAPIKey = URLQueryItem(name: "apiKey", value: "313ca7958679415db03f78b1c1c951f0")
    
    func configuredURL() -> URL?  {
        everythingUrl?.queryItems?.append(language)
        everythingUrl?.queryItems?.append(domains)
        everythingUrl?.queryItems?.append(fromDate)
        everythingUrl?.queryItems?.append(toDate)
        everythingUrl?.queryItems?.append(secretAPIKey)
        return everythingUrl?.url
    }
    
//    struct Constants {
//        static let topHeadlinesURL = URL(
//             string: "\(configuredURL())"
//        )
//
//    }
    private init() {}
    
    // Func: getTopStories
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void){
        //Get URL (guarded)
        guard let url = configuredURL() else {
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



