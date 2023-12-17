//
//  NetworkingManager.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

enum HttpMethods : String {
    case get = "GET"
}

final class NetworkingManager {
    static let shared: NetworkingManager = {
        let instance = NetworkingManager()
        return instance
    }()
    var customJsonDecoder : JSONDecoder? = nil

    private init(){}

    // MARK: - Private functions

    private func createJsonDecoder() -> JSONDecoder{
        if let customJsonDecoder {
            return customJsonDecoder
        } else {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            customJsonDecoder = jsonDecoder
            return jsonDecoder
        }
    }

    private func createRequest(requestUrl: URL) -> URLRequest{
        let urlRequest = URLRequest(url: requestUrl)
        return urlRequest
    }

    private func getRequestUrl(requestURLString: String, queryParams: [String: String]?) -> URL?{
        if let queryParams {
            var urlComponents = URLComponents(string: requestURLString)
            var queryItems:[URLQueryItem] = [URLQueryItem]()

            queryParams.forEach { (key,value) in
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }

            urlComponents?.queryItems = queryItems

            guard let requestUrl = urlComponents?.url else{
                return nil
            }
            return requestUrl
        } else {
            return URL(string: requestURLString)
        }

    }

    private func decodeJsonResponse<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = createJsonDecoder()
        do {
            return try decoder.decode(responseType, from: data)
        }catch let error {
            // Log it to some service
            debugPrint("error while decoding JSON response =>\(error.localizedDescription)")
        }
        return nil
    }

    // MARK: - GET Api
    func getData<T:Decodable>(requestURLString: String, queryParam: [String: String]?,
                              customHeader: [String: String]? = nil,
                              resultType: T.Type, completionHandler: @escaping(Result<(T, URLResponse?), NetworkError>) -> Void){

        guard let requestURL = getRequestUrl(requestURLString: requestURLString, queryParams: queryParam) else  {
            completionHandler(.failure(NetworkError(forRequestUrl: nil, errorMessage: "Invalid URL = \(requestURLString)", forStatusCode: nil)))
            return
        }

        var request = self.createRequest(requestUrl: requestURL)
        request.httpMethod = HttpMethods.get.rawValue

        if let customHeader {
            for (key, value) in customHeader {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        performOperation(requestUrl: request, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }

    // MARK: - Perform data task
    private func performOperation<T: Decodable>(requestUrl: URLRequest, responseType: T.Type,
                                                completionHandler:@escaping(Result<(T, URLResponse?), NetworkError>) -> Void){
        if let url = requestUrl.url {
            debugPrint("Calling Api with URL -> \(url)")
        }
        if let allHTTPHeaderFields = requestUrl.allHTTPHeaderFields {
            debugPrint("Headers -> \(allHTTPHeaderFields)")
        }

        URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let error = error  {
                completionHandler(.failure(NetworkError(forRequestUrl: requestUrl.url,
                                                        errorMessage: error.localizedDescription,
                                                        forStatusCode: statusCode)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                completionHandler(.failure(NetworkError(forRequestUrl: requestUrl.url,
                                                        errorMessage: "Invalid response code",
                                                        forStatusCode: statusCode)))
                return
            }

            if let data = data, data.count > 0 {
                let decodedResponse = self.decodeJsonResponse(data: data, responseType: responseType)

                if let decodedResponse {
                    completionHandler(.success((decodedResponse, response)))
                } else {
                    completionHandler(.failure(NetworkError(withServerResponse: data, forRequestUrl: requestUrl.url,
                                                            withHttpBody: requestUrl.httpBody,
                                                            errorMessage: "Error while decoding JSON response",
                                                            forStatusCode: statusCode)))
                }
            }
        }.resume()
    }
}
