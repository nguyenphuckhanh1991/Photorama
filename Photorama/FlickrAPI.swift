//
//  FlickrAPI.swift
//  Photorama
//
//  Created by nguyen.phuc.khanh on 11/3/17.
//  Copyright © 2017 nguyen.phuc.khanh. All rights reserved.
//

import UIKit

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickrAPI {
   
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a2c30f3445dc47558407c68b76169c10"
    
    private static func flickrURL(method: Method,
                                  parameters: [String: String]?) -> URL {
        //return URL(string: "")!
        
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = ["method": method.rawValue,
                          "format": "json",
                          "nojsoncallback": "1",
                          "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos,
                         parameters: ["extras": "url_h,date_taken"])
    }
}




