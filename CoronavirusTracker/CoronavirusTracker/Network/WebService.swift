//
//  WebService.swift
//  CoronavirusTracker
//
//  Created by Александр Федоров on 26.04.2020.
//  Copyright © 2020 Personal. All rights reserved.
//

import Foundation

struct Resource<T> {
    let url: URL
    let parser: (Data) -> T?
}

final class WebService {
    func load<T>(_ resource: Resource<T>, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            if let data = data {
                completion(resource.parser(data))
            } else {
                completion(nil)
            }
        }.resume()
    }
}
