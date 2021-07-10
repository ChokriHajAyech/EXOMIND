import Foundation

class WeatherInteractor: PresenterToInteractorWeatherProtocol {
	
	// MARK: Properties
	var presenter: InteractorToPresenterWeatherProtocol?
	func loadWeather(city: String) {
		ServiceFactory.shared.makeCurrentDayForecastService().getCurrentDayForecast(city: city) { (data, error) in
			if let error = error {
				self.presenter?.fetchWeatherFailure(error: error)
			}else {
				self.presenter?.fetchWeatherSuccess(weatherResponse: data as! CurrentWeatherForecastResponse)
			}
		}
	}
}
