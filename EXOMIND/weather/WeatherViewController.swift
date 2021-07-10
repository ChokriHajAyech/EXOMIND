import UIKit

class WeatherViewController: UIViewController {
	
	var presenter: ViewToPresenterWeatherProtocol?
	
	@IBOutlet weak var gaugeContainerView: UIView!
	@IBOutlet weak var gauge: UIProgressView!
	@IBOutlet weak var percent: UILabel!
	@IBOutlet weak var msgLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var stackView1: UIStackView!
	@IBOutlet weak var stackView2: UIStackView!

	override func viewDidLoad() {
		self.presenter?.searchWeather()
		gaugeContainerView.layer.cornerRadius = 14
	}
	
	@IBAction func restart(_ sender: Any) {
		self.stackView1.isHidden = true
		self.stackView2.isHidden = false
		self.presenter?.searchWeather()
	}
}

//MARK: - PresenterToViewWeatherProtocol

extension WeatherViewController: PresenterToViewWeatherProtocol {
	
	func displayMsg(text: String) {
		msgLabel.text = text
	}
	
	func fillGauge(percentage: Int) {
		let val: Float = Float(percentage)/60
		let myInteger = Int(val*100)
		percent.text = String(myInteger)+" %"
		gauge.setProgress(val, animated: true)
	}
	
	func onFetchWeathersSuccess() {
		self.stackView2.isHidden = true
		self.stackView1.isHidden = false
		self.tableView.reloadData()
	}
	
	func onFetchWeathersFailure(error: Error) {
		// create the alert
		let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
		// add an action (button)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		// show the alert
		self.present(alert, animated: true, completion: nil)
	}
	
	func showHUD() {
		//TODO
	}
	
	func hideHUD() {
		//TODO
	}
	
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {

	// MARK: - Table view data source

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.presenter?.numberOfRowsInSection() ?? 0
	}

	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
		cell.cityLabel?.text = self.presenter?.cityLabelText(indexPath: indexPath)
		cell.tmpLabel?.text = self.presenter?.tmpLabelText(indexPath: indexPath)
		cell.weatherImageView.image =  self.presenter?.imgLabelText(indexPath: indexPath)

		return cell
	}

}
