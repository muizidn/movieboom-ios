//
//  RestManager.swift

//
//  Created by Muis on 16/07/20.
//  Copyright © 2020 Muis. All rights reserved.
//

import UIKit
import SwiftyJSON


/// Represent all network acitivty
private var __networkActivityCounter2 = 0 {
    didSet {
        DispatchQueue.main.async {
            UIApplication.shared
                .isNetworkActivityIndicatorVisible = (__networkActivityCounter2 > 0)
        }
    }
}


/// This mimics Moya's TargetType
protocol RestApi {
    /// The target's base `URL`.
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    var task: Task { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    var timeout: TimeInterval { get }
}

extension RestApi {
    var timeout: TimeInterval {
        URLSession.shared.configuration.timeoutIntervalForRequest }
    var fullURL: URL {
        var url = baseURL
        url.appendPathComponent(path)
        return url
    }
}

/// Represent HTTP method
public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}

/// Represents an HTTP task.
public enum Task {
    case requestPlain
    case requestJSON(Data)
    case requestJSONDict([String: Any])
    case requestMultipart([MultipartData2], id: String)
    case requestUrlEncoded([String:Any])
    case requestParameter([String:String])
    case requestJSONDictAndParam(
        dict: [String:Any],
        param:[String:String]
    )
}

public enum MultipartData2 {
    case string(name: String, value: String)
    case data(name: String, value: Data, filename: String, mimeType: String)
}


extension RestApi {
    
    /// Convert current object to URLRequest
    func toUrlRequest() -> URLRequest {
        guard var urlComp = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: true)
            else { fatalError() }
        
        var queryItems: [URLQueryItem]? = nil
        var body: Data? = nil
        var headers = self.headers ?? [:]
        
        switch task {
        case .requestPlain:
            body = nil
        case .requestJSON(let value):
            body = value
        case .requestJSONDict(let dict):
            body = try! JSONSerialization
                .data(withJSONObject: dict, options: [])
        case .requestUrlEncoded(let dict):
            var parts: [String] = []
            for (key, value) in dict {
                let part = String(format: "%@=%@",
                    String(describing: key)
                        .addingPercentEncoding(
                            withAllowedCharacters: .urlQueryAllowed)!,
                    String(describing: value)
                        .addingPercentEncoding(
                            withAllowedCharacters: .urlQueryAllowed)!)
                parts.append(part as String)
            }
            body = parts
                .joined(separator: "&")
                .data(using: .utf8)
        case .requestParameter(let param):
            queryItems = param.map({
                URLQueryItem(name: $0.key, value: String($0.value))
            })
        case .requestJSONDictAndParam(let dict, let param):
            queryItems = param.map({
                URLQueryItem(name: $0.key, value: String($0.value))
            })
            body = try! JSONSerialization
                .data(withJSONObject: dict, options: [])
        case .requestMultipart(let params, let id):
            let boundary = "\(UUID().uuidString.lowercased())"
            
            headers["Content-Type"] = "multipart/form-data; charset=utf-8; boundary=\(boundary)"
            headers["id"] = id
            
            var mbody = Data()
            
            for i in params {
                
                mbody.append("--\(boundary)\r\n"
                    .data(using: .utf8, allowLossyConversion: false)!)
                
                switch i {
                case .string(let name, let value):
                    mbody.append(#"Content-Disposition: form-data; name="\#(name)"\#r\#n\#r\#n"#
                        .data(using: .utf8, allowLossyConversion: false)!)
                    mbody.append("\(value)"
                        .data(using: .utf8, allowLossyConversion: false)!)
                case .data(let name, let value, let filename, let mimeType):
                    mbody.append(#"Content-Disposition: form-data; name="\#(name)"; filename="\#(filename)"\#r\#n"#
                        .data(using: .utf8, allowLossyConversion: false)!)
                    mbody.append(#"Content-Type: \#(mimeType)\#r\#n\#r\#n"#
                        .data(using: .utf8, allowLossyConversion: false)!)
                    mbody.append(value)
                }
                mbody.append("\r\n"
                    .data(using: .utf8, allowLossyConversion: false)!)
                
            }
            
            // Close
            mbody.append("--\(boundary)--"
                .data(using: .utf8, allowLossyConversion: false)!)
            
            body = mbody
        }
        
        urlComp.queryItems = queryItems
        var urlReq = URLRequest(url: urlComp.url!)
        urlReq.httpBody = body
        
        urlReq.allHTTPHeaderFields = headers
        urlReq.httpMethod = method.rawValue
        
        return urlReq
    }
}


/// The manager for every RESTful operation
final class RestManager2 {
    static let shared = RestManager2()
    fileprivate init() {}
    
    func request(endpoint: RestApi, delegate: URLSessionTaskDelegate? = nil, completion: @escaping (Result<JSON, Error>) -> Void) -> URLSessionDataTask {
        __networkActivityCounter2 += 1
        let request = endpoint.toUrlRequest()
        let urlConfig = URLSessionConfiguration.ephemeral
        urlConfig.timeoutIntervalForRequest = endpoint.timeout
        let session = URLSession.init(
            configuration: .ephemeral,
            delegate: delegate,
            delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(Result.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else { fatalError() }
            completion(Result<JSON, Error>(catching: {
                switch response.statusCode {
                case 200...299:
                    if let data = data {
                        return try JSON(data: data)
                    } else {
                        throw RestManagerError("Data is empty")
                    }
                case 400...499:
                    if let data = data {
                        let value = try JSON(data: data)
                        assert(value["status"].boolValue == false,
                               "status must false")
                        throw RestManagerError(value["status_message"].stringValue)
                    } else {
                        throw RestManagerError("Data is empty")
                    }
                case 500...599:
                    throw RestError2.internalServerError
                default:
                    throw RestError2.unhandledError
                }
            }))
        }
        
        task.resume()
        return task
    }
}

enum RestError2: LocalizedError {
    case internalServerError
    case unhandledError
    case err400
    case custom(String)
    var errorDescription: String? {
        switch self {
        case .internalServerError:
            return "Internal Server Error"
        case .unhandledError:
            return "Unhandled Error"
        case .err400:
            return "Unhandled Error 400"
        case .custom(let text):
            return text
        }
    }
}

fileprivate struct Rest400Error: Decodable {
    let message: [String: String]
}

fileprivate struct RestManagerError: LocalizedError {
    private let msg: String
    init(_ msg: String) {
        self.msg = msg
    }
    
    var errorDescription: String? { msg }
}
