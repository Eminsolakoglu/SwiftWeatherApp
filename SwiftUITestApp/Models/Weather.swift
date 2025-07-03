import Foundation

struct WeatherResponse:Codable {
    let name : String
    let main : Main
    let weather : [WeatherCondition]
    let dt : Int
    let id : Int
    let cod : Int
}
struct Coord:Codable {
    let lon: Double
    let lat: Double
}

struct Main:Codable {
    let temp: Double
    let feels_like: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feels_like = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}
struct WeatherCondition:Codable, Identifiable {
    let id: Int
    let main: String
    let description: String
    
}

struct Wind:Codable {
    let speed: Double
    let deg: Int
}

struct Clouds:Codable {
    let all: Int
}
struct Sys:Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
