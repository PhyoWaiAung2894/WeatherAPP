//
//  ViewController.swift
//  WeatherAPP
//
//  Created by PhyoWai Aung on 10/2/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var weatherDegree: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    
    var weatherManager = WealtherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
}

//f8706031bc51ac856748900c155f28d4q

//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UITextField) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }else {
            searchTextField.placeholder = "Type Somethig Plz"
            return false
        }
            
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = textField.text {
            weatherManager.fetchWeather(CityName: city)
        }
        
        searchTextField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherDegree.text = weather.temperatureString
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.locationLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
