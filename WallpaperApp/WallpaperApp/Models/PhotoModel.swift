//
//  PhotoModel.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/06/25.
//

import Foundation

class PhotoModel {
    private let accessKey = "0XgDHX0xTNuzX7EWsYFj8dmw9GqmlECNdggiLWeYEZU"
    var photos: [PhotoData]?
    
    func fetchPhotos(completion: @escaping (Result<[PhotoData], Error>) -> Void) {
        let urlString = "https://api.unsplash.com/photos/?per_page=5&order_by=latest&client_id=\(accessKey)"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "APIのURLが無効です"])
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                let errorDescription = "写真の取得に失敗しました: \(error.localizedDescription)"
                print(errorDescription)
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                return
            }
            
            guard let data = data else {
                let errorDescription = "データが無効です"
                print(errorDescription)
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([PhotoData].self, from: data)
                self.photos = photos
                completion(.success(photos))
            } catch {
                let errorDescription = "データの解析に失敗しました: \(error.localizedDescription)"
                print(errorDescription)
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
            }
        }.resume()
    }
}
