//
//  ViewController.swift
//  WeatherApp
//
//  Created by Эл on 16.01.2021.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    
    var networkWeatherManager = NetworkWeatherManager()
    lazy var locationManager : CLLocationManager = {
        let lm = CLLocationManager()
        
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    var cityLabel : UILabel!
    var temperatureLabel : UILabel!
    var feelsLikeTemperatureLabel : UILabel!
    var weatherIconImageView : UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImage(named: "IMG_0293.PNG")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        
        weatherIconImageView = UIImageView(image: UIImage(systemName: "nosign"))
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        weatherIconImageView.tintColor = .systemYellow
        view.addSubview(weatherIconImageView)
        
        cityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.text = "City"
        cityLabel.font = .monospacedSystemFont(ofSize: 20, weight: .light)
        view.addSubview(cityLabel)
        
        cityLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 100).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        temperatureLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.text = "Temperature"
        temperatureLabel.font = .boldSystemFont(ofSize: 20)
        view.addSubview(temperatureLabel)
        
        temperatureLabel.topAnchor.constraint(equalTo: cityLabel.topAnchor, constant: 20).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        feelsLikeTemperatureLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        feelsLikeTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeTemperatureLabel.text = "Feels Like"
        feelsLikeTemperatureLabel.font = .italicSystemFont(ofSize: 20)
        view.addSubview(feelsLikeTemperatureLabel)
        
        feelsLikeTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: 20).isActive = true
        feelsLikeTemperatureLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else {
                return
            }
            self.updateInterfaceWith(weather: currentWeather)}
        
        let image = UIImage(named: "IMG_0307.PNG")
        let buttonThird = UIButton(type: UIButton.ButtonType.custom)
        buttonThird.translatesAutoresizingMaskIntoConstraints = false
        buttonThird.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        buttonThird.setImage(image, for: .normal)
        buttonThird.addTarget(self, action: #selector(self.pressBttonUp(sender:)), for: .touchUpInside)

        self.view.addSubview(buttonThird)
        
        buttonThird.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        buttonThird.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        buttonThird.heightAnchor.constraint(equalToConstant: 70).isActive = true
        buttonThird.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.topAnchor.constraint(equalTo: feelsLikeTemperatureLabel.topAnchor, constant: 25).isActive = true
        weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //someView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        //weatherIconImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 150).isActive = true
        //weatherIconImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -150).isActive = true
        weatherIconImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        weatherIconImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        buttonTwo.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
//        buttonTwo.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
//        buttonTwo.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
//        buttonTwo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
        
    }
    

    @objc func pressBttonUp(sender: UIButton) {
    
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    
    
    func updateInterfaceWith(weather: CurrentWeather) {
        
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

//extension   ViewController : NetworkWeatherManagerDelegate {
//    func updateInterface(_: NetworkWeatherManager, with currentWeather: CurrentWeather) {
//        print(currentWeather.cityName)
//    }
//
//
//}

