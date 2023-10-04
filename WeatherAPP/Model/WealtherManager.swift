import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WealtherManager {
    
    let wealtherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=f8706031bc51ac856748900c155f28d4&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let url = "\(wealtherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: url)
    }
    
    func fetchWeather(CityName: String){
        let url = "\(wealtherUrl)&q=\(CityName)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        
        //Step 1. Create Url
        
        if let url = URL(string: urlString) {
            //Step 2.Create Url session
            let session = URLSession(configuration: .default)
            
            //Step 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            
            //Step4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data)-> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }catch{
            print(error)
            return nil
        }
    }
    
}


