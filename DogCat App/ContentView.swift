//
//  ContentView.swift
//  DogCat App
//
//  Created by Nikita Kolomoec on 02.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model: AnimalModel
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: model.animal.imageData ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFill()
                .clipped()
            
            HStack {
                Text("What is it?")
                    .font(.title)
                    .bold()
                    .edgesIgnoringSafeArea(.all)
                
                Spacer()
                
                Button("Next") {
                    model.getAnimal()
                }
                .buttonStyle(.borderedProminent)
                .disabled(model.animal.imageData == nil)
            }
            .padding(.horizontal, 30)
        }
        .onAppear {
            model.getAnimal()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: AnimalModel())
    }
}
