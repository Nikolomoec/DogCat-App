//
//  AnimalSwift.swift
//  DogCat App
//
//  Created by Nikita Kolomoec on 02.04.2023.
//

import Foundation
import CoreML
import Vision

struct Result: Identifiable {
    var id = UUID()
    var imageLabel: String
    var confidence: Double
}

class Animal {
    
    // url for the image
    var imageUrl: String
    // image data
    var imageData: Data?
    
    //Clasified results
    var results: [Result]
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    init() {
        self.imageUrl = ""
        self.imageData = nil
        self.results = []
    }
    
    init?(json: [String : Any]) {
        
        // Check if Json has an Url
        guard let imageUrl = json["url"] as? String else {
            return nil
        }
        
        // Set the animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        self.results = []
        
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
                self.clasifyAnimal()
            }
        }
        
        // Start the dataTask
        dataTask.resume()
    }
    
    func clasifyAnimal() {
        
        // Get a reference to the model
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        // Create an image handler
        let handler = VNImageRequestHandler(data: imageData!)
        
        // Create request to the model
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Couldn't clasify an animal")
                return
            }
            
            // Update results
            for classification in results {
                
                var identifier = classification.identifier
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))
            }
        }
        
        // Execute the request
        do {
            try handler.perform([request])
        } catch {
            print("invalid image")
        }
    }
    
}
