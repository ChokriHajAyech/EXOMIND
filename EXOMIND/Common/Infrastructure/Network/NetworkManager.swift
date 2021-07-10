import UIKit

class NetworkManager: NSObject {
    
    static let sharedNetworkManager = NetworkManager()
    var sessions: [URLSession]
    
    //MARK: Initialization
    override init() {
        self.sessions = [URLSession]()
    }
    
    func sessionWithDescription(_ description: String) -> URLSession {
        
        if let session = sessions.first(where: {$0.sessionDescription == description}) {
            return session
        }
        
        let session = URLSession(configuration: self.sessionConfigurationWithDescription(description), delegate: self, delegateQueue: nil)
        session.sessionDescription = description
        self.sessions.append(session)
        return session
    }
    
    func sessionConfigurationWithDescription(_ description: String?) -> URLSessionConfiguration {
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        return configuration
    }
}

//MARK: NSURLSessionDelegate
extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let index = sessions.firstIndex(where: {$0 == session}) {
            self.sessions.remove(at: index)
        }
    }
}
