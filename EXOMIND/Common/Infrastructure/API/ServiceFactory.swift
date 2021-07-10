import Foundation

class ServiceFactory {
    static let shared = ServiceFactory()
    private init() {}
    func makeCurrentDayForecastService() -> CurrentDayForecastService {
        return ServerCurrentDayForecastService()
    }
}
