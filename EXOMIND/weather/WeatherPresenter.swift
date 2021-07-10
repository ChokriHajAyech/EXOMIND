import Foundation
import UIKit

class WeatherPresenter: ViewToPresenterWeatherProtocol {
	
	var view: PresenterToViewWeatherProtocol?
	var interactor: PresenterToInteractorWeatherProtocol?
	var router: PresenterToRouterWeatherProtocol?
	var weathers: [WeatherModel]?
	var cityIndex = 0
	var msgIndex = 0
	
	func searchWeather() {
		self.cityIndex = 0
		weathers = [WeatherModel]()
		self.interactor?.loadWeather(city: Constant.cities[cityIndex])
		self.loadRepetitive()
		self.currentMsg()
	}
	
	private func currentMsg() {
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) { [self] in
			self.view?.displayMsg(text: Constant.msgs[msgIndex])
			self.msgIndex += 1
			if self.msgIndex == 3 {
				self.msgIndex = 0
			}
			self.currentMsg()
		}
	}
	
	private func loadRepetitive() {
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) { [self] in
			self.cityIndex += 1
			if self.cityIndex <= Constant.cities.count-1 {
				self.interactor?.loadWeather(city: Constant.cities[self.cityIndex])
				loadRepetitive()
			}else {
				if (self.cityIndex+1) * 10 < 60 {
					loadRepetitive()
				}else {
					self.view?.fillGauge(percentage: 60)
					self.view?.onFetchWeathersSuccess()
				}
			}
		}
	}
	
	func numberOfRowsInSection() -> Int {
		guard let weathers = self.weathers else {
			return 0
		}
		
		return weathers.count
	}
	
	func cityLabelText(indexPath: IndexPath) -> String? {
		guard let weathers = self.weathers else {
			return nil
		}
		
		return weathers[indexPath.row].city
	}
	
	func tmpLabelText(indexPath: IndexPath) -> String? {
		guard let weathers = self.weathers else {
			return nil
		}
		
		return weathers[indexPath.row].tmp
	}
	
	func imgLabelText(indexPath: IndexPath) -> UIImage? {
		guard let weathers = self.weathers else {
			return nil
		}
		
		return UIImage(named: weathers[indexPath.row].img)
	}
}


//MARK: - InteractorToPresenterWeatherProtocol

extension WeatherPresenter: InteractorToPresenterWeatherProtocol {
	
	func fetchWeatherSuccess(weatherResponse: CurrentWeatherForecastResponse) {
		//FIXME: Use Enum
		var tmp = "icon_rain"
		if weatherResponse.main.temperature > 20 {
			tmp = "icon_hot"
		}else if weatherResponse.main.temperature > 10 && weatherResponse.main.temperature < 20 {
			tmp = "icon_cloudy"
		}
		
		let weather = WeatherModel(city: Constant.cities[self.cityIndex], tmp: String(weatherResponse.main.temperature), img: tmp)
		self.weathers?.append(weather)
		self.view?.fillGauge(percentage:(self.cityIndex+1) * 10)
	}
	
	func fetchWeatherFailure(error: Error) {
		self.view?.onFetchWeathersFailure(error: error)
	}
}
