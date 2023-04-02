//
//  AnimalSwift.swift
//  DogCat App
//
//  Created by Nikita Kolomoec on 02.04.2023.
//

import Foundation

class Animal {
    
    // url for the image
    var imageUrl: String
    // image data
    var imageData: Data?
    
    init() {
        self.imageUrl = ""
        self.imageData = nil
    }
    
    init?(json: [String : Any]) {
        
        // Check if Json has an Url
        guard let imageUrl = json["url"] as? String else {
            return nil
        }
        
        // Set the animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        
        // Download the image data
        getImage()
    }
    
    func getImage() {
        
        // Create an URL Object
        let url = URL(string: imageUrl)
        
        // Check if url != nil
        guard url != nil else {
            print("Couldn't find url object")
            return
        }
        
        // Get a URL Session
        let session = URLSession.shared
        
        // Create a dataTask
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                self.imageData = data
            }
        }
        
        // Start the dataTask
        dataTask.resume()
    }
    
}
