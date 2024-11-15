//
//  ContentView.swift
//  f24bootcamp-APIpractice
//
//  Created by Yahan Yang on 11/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct WordView: View {
    @State var words: [String]? = nil
    @State var count: Int? = 1
    
    var body: some View {
        List {
            Button("Refresh words") {
                getWords()
            }
            
            Section {
                if let words = words {
                    ForEach(words, id: \.self) { word in
                        Text(word)
                    }
                } else {
                    Text("An error has occured")
                }
            }
        }
        .onAppear { getWords() }
    }
    
    private func getWords() {
        Task {
            do {
                let result = try await WordService.fetchWords(1)
                words = result
            } catch {
                print(error)
            }
        }
    }
}

class WordService {
    static func fetchWords(_ count: Int) async throws -> [String] {
        //input API/Server URL
        var components = URLComponents(string: "https://random-word-api.herokuapp.com/word?number=10")
        //Making sure URL is correct and put URL to swift-readable
        guard let url = components?.url else{fatalError("Invalid URL")}
        //Specific query if want specific data
        components?.queryItems = [URLQueryItem(name: "number", value: "\(count)")]
        //Asks the server to share the data
        let (data, _) = try await URLSession.shared.data(from: url)
        //decode the shared data
        let words = try JSONDecoder().decode([String].self, from: data)
        return words;
    }
}














struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        WordView()
    }
}
