//
//  AnimalModel.swift
//  DogCat App
//
//  Created by Nikita Kolomoec on 02.04.2023.
//

import Foundation

class AnimalModel: ObservableObject {
    
    @Published var animal = Animal()
    
    func getAnimal() {
        let stringUrl = Bool.random() ? catUrl : dogUrl
        
        // Create a url object
        let url = URL(string: stringUrl)
        
        // Check if it is isn't nil
        guard url != nil else {
            print("Couldn't create URL object")
            return
        }
        
        // Get the URL Session
        let session = URLSession.shared
        
        // Create the dataTask
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                // Parse JSON
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [[String: Any]] {
                        
                        let item = json.isEmpty ? [:] : json[0]
                        
                        if let animal = Animal(json: item) {
                            
                            DispatchQueue.main.async {
                                while animal.imageData == nil {}
                                self.animal = animal
                            }
                        }
                    }
                        
                } catch {
                    print("We couldn't parse the JSON")
                }
            }
        }
        
        // Start the dataTask
        dataTask.resume()
    }
}
