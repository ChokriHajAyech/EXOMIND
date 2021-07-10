
import Foundation

struct CurrentWeatherForecastResponse: Decodable {
	let coord: Coord
    let main: Main
    struct Main: Codable {
        let temperature: Double
        let humidity: Int
        let maxTemperature: Double
        let minTemperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case humidity
            case maxTemperature = "temp_max"
            case minTemperature = "temp_min"
        }
    }
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
}
