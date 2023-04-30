//
//  main.swift
//  PruebaServiciosWeb
//
//  Created by Teodoro Calle Lara on 29/04/23.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let cuerpo: String
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title, cuerpo = "body"
    }
}

let urlSessionConfiguration = URLSessionConfiguration.default
let urlSession = URLSession(configuration: urlSessionConfiguration)

let urlString = "https://jsonplaceholder.typicode.com/posts"
let url = URL(string: urlString)!

var request = URLRequest(url: url)
request.httpMethod = "GET"

let task = urlSession.dataTask(with: request) { data, urlResponse, error in
    // Inicio preprocesamiento
    if let error = error {
        print("Ocurrio un error \(error.localizedDescription)")
        return
    }
    
    if let response = urlResponse as? HTTPURLResponse, !(200..<300).contains(response.statusCode){
        print("El servidor respondió un código de estado inesperado: \(response.statusCode)")
        return
    }
    
    guard let responseBody = data else {
        // Sino lo puede hacer es porque data es nulo
        print("Data no puede ser nulo")
        return
    }
    // Fin preprocesamiento
    
    // Decodificar la respuesta (cuerpo de la respuesta para sacar la info)
    let decoder = JSONDecoder()
    do {
        let decodedResponse = try decoder.decode([Post].self, from: responseBody)
        print(decodedResponse)
        let postFiltradosPorId = decodedResponse.filter { $0.userId  == 1}
        print(postFiltradosPorId)
    }catch{
        print("Ocurrió un error en la decodificación")
    }
    
}

task.resume()
RunLoop.main.run(until: .init(timeIntervalSinceNow: 1.0))
