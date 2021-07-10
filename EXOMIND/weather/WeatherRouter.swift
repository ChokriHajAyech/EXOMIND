import UIKit

class WeatherRouter: PresenterToRouterWeatherProtocol {
	static func createModule() -> UIViewController {
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
		let viewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
		let presenter: ViewToPresenterWeatherProtocol & InteractorToPresenterWeatherProtocol = WeatherPresenter()
		viewController.presenter = presenter
		viewController.presenter?.router = WeatherRouter()
		viewController.presenter?.view = viewController
		viewController.presenter?.interactor = WeatherInteractor()
		viewController.presenter?.interactor?.presenter = presenter
		return viewController
	}
}

