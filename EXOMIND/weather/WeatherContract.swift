import Foundation
import UIKit

// MARK: View Input (View -> Presenter)

protocol ViewToPresenterWeatherProtocol {
	var view: PresenterToViewWeatherProtocol? {get set}
	var interactor: PresenterToInteractorWeatherProtocol? {get set}
	var router: PresenterToRouterWeatherProtocol? {get set}
	var weathers: [WeatherModel]? { get set }
	func searchWeather()
	func numberOfRowsInSection() -> Int
	func cityLabelText(indexPath: IndexPath) -> String?
	func tmpLabelText(indexPath: IndexPath) -> String?
	func imgLabelText(indexPath: IndexPath) -> UIImage?
}

// MARK: View Output (Presenter -> View)

protocol PresenterToViewWeatherProtocol {
	func fillGauge(percentage: Int)
	func displayMsg(text: String)
	func onFetchWeathersSuccess()
	func onFetchWeathersFailure(error: Error)
	func showHUD()
	func hideHUD()
}

// MARK: Interactor Input (Presenter -> Interactor)

protocol PresenterToInteractorWeatherProtocol {
	var presenter: InteractorToPresenterWeatherProtocol? { get set }
	func loadWeather(city: String)
}

// MARK: Interactor Output (Interactor -> Presenter)

protocol InteractorToPresenterWeatherProtocol {
	func fetchWeatherSuccess(weatherResponse: CurrentWeatherForecastResponse)
	func fetchWeatherFailure(error: Error)
}

// MARK: Router Input (Presenter -> Router)

protocol PresenterToRouterWeatherProtocol {
	static func createModule() -> UIViewController
}
