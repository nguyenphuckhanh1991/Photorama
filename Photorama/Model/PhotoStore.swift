//
//  PhotoStore.swift
//  Photorama
//
//  Created by nguyen.phuc.khanh on 11/3/17.
//  Copyright © 2017 nguyen.phuc.khanh. All rights reserved.
//

import UIKit
import CoreData

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotoResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    // An instance of URLSession
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // Use URLSession to create a URLSessionDataTask that transfers this request to the server.
    func fetchInterestingPhotos(completion: @escaping (PhotoResult) -> Void) {
        //Create a URL instance using the FlickrAPI struct and instantiate a request object with it
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
           
        let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    // Method that will process the JSON data that is returned from the web service request.
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
    guard let photoKey = photo.photoID else {
    preconditionFailure("Photo expected to have a photoID.")
    }
    if let image = imageStore.image(forKey: photoKey) {
    OperationQueue.main.addOperation {
    completion(.success(image))
    }
    return
    }
    guard let photoURL = photo.remoteURL else {
    preconditionFailure("Photo expected to have a remote URL.")
    }
        let request = URLRequest(url: photoURL as! URL)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    // MARK: Method that processes the data from the web service request into an image,if possible.
    private func processImageRequest(data: Data?, error:Error?) -> ImageResult {
        guard
        let imageData = data,
            let image = UIImage(data: imageData) else {
                
                //Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        return .success(image)
    }
    
}
