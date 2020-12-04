//
//  ApiRequest.swift
//  UnsplashKraken
//
//  Created by Toriq Wahid Syaefullah on 30/11/20.
//

import Foundation
import SwiftyJSON
import Alamofire

enum NetworkError: Error {
    case failure
    case success
}


class APIRequest {
    let apiKey = "d8a272c480b258b875d82f4062d6c52e4ae7f4b4656add778d71e9b638b2f8be"
    let baseUrl = "https://api.unsplash.com/search/"
    
    func searchImage(params: Parameter, completionHandler: @escaping ([JSON]?, NetworkError) -> ()) {
        let headers: HTTPHeaders = ["Authorization": "Client-ID \(apiKey)"]
        let filterUrl = "\(baseUrl)photos?page=\(params.page)&query=\(params.query)"

        AF.request(filterUrl, headers: headers).responseJSON { response in
            guard let data = response.data else {
                completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            let results = json?["results"].arrayValue
            guard let empty = results?.isEmpty, !empty else {
                completionHandler(nil, .failure)
                return
            }
            
            completionHandler(results, .success)
        }
    }
    
    func fetchImage(url: String, completionHandler: @escaping (UIImage?, NetworkError) -> ()) {
        AF.request(url).responseData { responseData in
            
            guard let imageData = responseData.data else {
                completionHandler(nil, .failure)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                completionHandler(nil, .failure)
                return
            }
            
            completionHandler(image, .success)
        }
    }
}
