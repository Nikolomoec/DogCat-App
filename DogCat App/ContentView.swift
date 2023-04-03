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
        ZStack {
            
            LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea([.top, .bottom])
            
            VStack {
                
                GeometryReader { geo in
                    Image(uiImage: UIImage(data: model.animal.imageData ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                }
                
                HStack(spacing: 110) {
                    Text("What is it?")
                        .font(.title)
                        .bold()
                    
                    Button("Next") {
                        model.getAnimal()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                    .shadow(radius: 10)
                    .disabled(model.animal.imageData == nil)
                }
                .padding(.horizontal, 30)
                ScrollView {
                    ForEach(model.animal.results) { result in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(width: 370, height: 50)
                                .padding()
                                .shadow(radius: 10)
                            HStack {
                                Text(result.imageLabel)
                                
                                Spacer()
                                
                                Text(String(format: "%.2f%%", result.confidence * 100))
                            }
                            .padding(.horizontal, 40)
                            .bold()
                        }
                    } 
                }
            }
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
