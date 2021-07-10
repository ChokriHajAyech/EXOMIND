import Foundation
import os.log

typealias ServiceCompletionHandler = (_ result: Any?, _ error: Error?) -> Void

class ServerService {
    /// Constants
    private let httpMethodDefault = "GET"
    
    /// The data task used by the service.
    private var task: URLSessionDataTask?
    
    ////////////////////////////////////////////////////////////////////////////////
    /// Public
    ////////////////////////////////////////////////////////////////////////////////
    
    /// Cancel the service.
    public func cancel() {
        if let task = self.task {
            task.cancel()
        }
        self.task = nil
    }
    
    /// Get the session used by the service.
    ///
    /// - returns: The session used by the service.
    public func getSession() -> URLSession {
        return NetworkManager.sharedNetworkManager.sessionWithDescription("service")
    }
    
    /// Get a request.
    ///
    /// - parameter path: The path of the request.
    /// - returns: The request or nil.
    public func getRequestWith(path: String) -> URLRequest? {
        return getRequestWith(path: path, method: nil)
    }
    
    /// Get a request.
    ///
    /// - parameter path: The path of the request.
    /// - parameter method: The method of the request.
    /// - returns: The request or nil.
    public func getRequestWith(path: String, method: String?) -> URLRequest? {
        guard let url = URL(string: path) else {
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        
        if let method = method {
            request.httpMethod = method
        }else {
            request.httpMethod = httpMethodDefault
        }
        return request
    }
    
    /// Invoke the service.
    ///
    /// - parameter path: The path of the request.
    /// - parameter type: The type of the class used for the decodage.
    /// - parameter completion: The completion handler.
    public func invokeService<T: Decodable>(path: String,
                                            type: T.Type,
                                            completion: @escaping ServiceCompletionHandler) {
        if let request = getRequestWith(path: path) {
            invokeService(request: request, type: type, completion: completion)
        }else {
            completion(nil, WeatherError.unknown(description: ""))
        }
    }
    
    /// Invoke the service.
    ///
    /// - parameter path: The path of the request.
    /// - parameter method: The method of the request.
    /// - parameter type: The type of the class used for the decodage.
    /// - parameter completion: The completion handler.
    public func invokeService<T: Decodable>(path: String,
                                            method: String,
                                            type: T.Type,
                                            completion: @escaping ServiceCompletionHandler) {
        if var request = getRequestWith(path: path) {
            request.httpMethod = method
            
            invokeService(request: request, type: type, completion: completion)
        }else {
            completion(nil, WeatherError.unknown(description: ""))
        }
    }
    
    /// Invoke the service.
    ///
    /// - parameter path: The path of the request.
    /// - parameter method: The method of the request.
    /// - parameter body: The body of the request.
    /// - parameter type: The type of the class used for the decodage.
    /// - parameter completion: The completion handler.
    public func invokeService<T: Decodable>(path: String,
                                            method: String,
                                            body: Data,
                                            type: T.Type,
                                            completion: @escaping ServiceCompletionHandler) {
        if var request = getRequestWith(path: path) {
            request.httpMethod = method
            request.httpBody = body
            
            invokeService(request: request, type: type, completion: completion)
        }else {
            completion(nil, WeatherError.unknown(description: ""))
        }
    }
    
    /// Invoke the service.
    ///
    /// - parameter request: The request.
    /// - parameter type: The type of the class used for the decodage.
    /// - parameter completion: The completion handler.
    public func invokeService<T: Decodable>(request: URLRequest,
                                            type: T.Type,
                                            completion: @escaping ServiceCompletionHandler) {
        cancel()
        
        task = getSession().dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, WeatherError.unknown(description: ""))
                }
            }else {
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 ||
                        httpResponse.statusCode == 201 ||
                        httpResponse.statusCode == 202 ||
                        httpResponse.statusCode == 204 ||
                        httpResponse.statusCode == 206 {
                        if let data = data, data.isEmpty == false {
                            do {
                                do {
                                    let dataDecoded = try JSONDecoder().decode(type, from: data)
                                    DispatchQueue.main.async {
                                        completion(dataDecoded, error)
                                        return
                                    }
                                    
                                } catch {
                                    DispatchQueue.main.async {
                                        completion(nil, WeatherError.parsing(description: ""))
                                    }
                                }
                            }
                        }else {
                            DispatchQueue.main.async {()
                                completion(nil, nil)
                            }
                        }
                    }else {
                        if httpResponse.statusCode == 401 {
                            DispatchQueue.main.async {
                                completion(nil, WeatherError.errorCodeHttp401(description: ""))
                            }
                        }else if httpResponse.statusCode == 403 {
                            DispatchQueue.main.async {
                                completion(nil, WeatherError.errorCodeHttp403(description: ""))
                            }
                        }else {
                            DispatchQueue.main.async {
                                completion(nil, WeatherError.errorCodeHttp(description: ""))
                            }
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        completion(nil, WeatherError.unknown(description: ""))
                    }
                }
            }
        }
        
        task?.resume()
    }
}
