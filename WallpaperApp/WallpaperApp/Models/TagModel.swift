//
//  TagModel.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/03.
//

import Foundation

class TagModel {
    private let accessKey = "0XgDHX0xTNuzX7EWsYFj8dmw9GqmlECNdggiLWeYEZU"
    var photos: [PhotoData]?
    
    func searchPhotos(with color: String, completion: @escaping (Result<[PhotoData], Error>) -> Void) {
        let query = "\(color)"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://api.unsplash.com/search/photos?query=\(encodedQuery)&per_page=20&client_id=\(accessKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SearchResponse.self, from: data)
                    self.photos = response.results
                    completion(.success(response.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
