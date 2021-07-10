import UIKit

class HomeController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
	}
	
	//MARK: - Configure
	
	private func configure() {
		self.title = "Acueil"
	}
	
	@IBAction func pushWeatherView(_ sender: Any) {
		let weatherViewController = WeatherRouter.createModule()
		self.navigationController?
			.pushViewController(weatherViewController, animated: true)
	}
}

