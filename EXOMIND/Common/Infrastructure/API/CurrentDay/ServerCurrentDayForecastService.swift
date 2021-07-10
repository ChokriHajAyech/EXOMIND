import Foundation

class ServerCurrentDayForecastService: ServerService, CurrentDayForecastService {
    func getCurrentDayForecast(city: String, completion: @escaping ServiceCompletionHandler) {
        let path = makeCurrentDayForecastComponents(withCity: city).string
        invokeService(path: path!, method: "GET", type: CurrentWeatherForecastResponse.self, completion: completion)
    }
    
    private func makeCurrentDayForecastComponents(withCity city: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = Conf.OpenWeatherAPI.scheme
        components.host = Conf.OpenWeatherAPI.host
        components.path = Conf.OpenWeatherAPI.path + Conf.OpenWeatherAPI.weather
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: Conf.OpenWeatherAPI.key)
        ]
        return components
    }
}
