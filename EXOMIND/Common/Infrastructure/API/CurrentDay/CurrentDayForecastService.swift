import Foundation

protocol CurrentDayForecastService {
    func getCurrentDayForecast(city:String, completion: @escaping ServiceCompletionHandler)
}
