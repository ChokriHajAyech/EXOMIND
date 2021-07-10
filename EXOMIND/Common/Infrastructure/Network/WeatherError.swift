 
 import Foundation
 
 enum WeatherError: Error {
    /// Parsing error
    case parsing(description: String)

    /// Unknown error
    case unknown(description: String)
    
    /// The form is invalid
    case invalidForm(description: String)
    
    /// Network connection error
    case networkConnection(description: String)
    
    /// Server error
    case server(description: String)
    
    /// Server timedOut
    case networkTimedOut(description: String)
    
    /// Connection error host
    case networkCannotConnectToHost(description: String)
    
    /// Lost Connection
    case networkConnectionLost(description: String)
    
    /// Error network
    case networkNotConnectedToInternet(description: String)
    
    /// Network cancelled
    case networkCancelled(description: String)
    
    /// Generic http error
    case errorCodeHttp(description: String)
    
    /// 401 http error
    case errorCodeHttp401(description: String)
    
    /// 403 http error
    case errorCodeHttp403(description: String)
    
    /// Technical error code
    case errorCodeTechnical(description: String)
 }
