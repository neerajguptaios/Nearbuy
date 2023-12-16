//
//  NetworkError.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation
struct NetworkError : Error{
    let serverResponse: String?
    let requestUrl: URL?
    let requestBody: String?
    let reason: String
    let httpStatusCode: Int?


    init(withServerResponse response: Data? = nil, forRequestUrl url: URL?,
         withHttpBody body: Data? = nil, errorMessage message: String, forStatusCode statusCode: Int?){
        self.serverResponse = response != nil ? String(data: response!, encoding: .utf8) : nil
        self.requestUrl = url
        self.requestBody = body != nil ? String(data: body!, encoding: .utf8) : nil
        self.httpStatusCode = statusCode
        self.reason = message
    }

    func logDetails() {
            print("Network Error Details:")
            print("Reason: \(reason)")

            if let statusCode = httpStatusCode {
                print("HTTP Status Code: \(statusCode)")
            }

            if let url = requestUrl {
                print("Request URL: \(url)")
            }

            if let requestBody = requestBody {
                print("Request Body: \(requestBody)")
            }

            if let serverResponse = serverResponse {
                print("Server Response: \(serverResponse)")
            }
        }
}
