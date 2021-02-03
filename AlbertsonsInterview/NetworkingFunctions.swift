//
//  NetworkingFunctions.swift
//  AlbertsonsInterview
//
//  Created by Mark Anthony Corpuz on 2/1/21.
//

import Foundation

struct NetworkingFunctions {
    public static func getRequestData(urlString: String, completion: @escaping ((Data?) -> Void)) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                return
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                completion(data)
            }
        }.resume()
    }
}
