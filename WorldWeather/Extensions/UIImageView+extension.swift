//
//  ImageView.swift
//  WorldWeather
//
//  Created by Macbook on 30.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
    
    func fetchImage(from url: String) {
        guard let url = URL(string: url) else {
            image = #imageLiteral(resourceName: "NotImage")
            return
        }
        
        if let cachedImage = getCachedImage(url: url) {
            image = cachedImage
            return
        }
        
        NetworkManager.shared.getImage(from: url) { (data, response) in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            self.saveDataToCach(with: data, and: response)
        }
    }
    
    private func getCachedImage(url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cacheedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cacheedResponse.data)
        }
        return nil
    }
    
    private func saveDataToCach(with data: Data, and response: URLResponse) {
        guard let urlResponse = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        let urlRequest = URLRequest(url: urlResponse)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
}
