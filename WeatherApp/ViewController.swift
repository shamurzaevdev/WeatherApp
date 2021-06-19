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
    private lazy var locationManager : CLLocationManager = {
        let lm = CLLocationManager()
        
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    private let cityLabel : UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "City"
        label.font = .monospacedSystemFont(ofSize: 20, weight: .light)
        
        return label
    }()
    
    private let temperatureLabel : UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temperature"
        label.font = .boldSystemFont(ofSize: 20)
        
        return label
        
    }()
    
    private let feelsLikeTemperatureLabel : UILabel = {
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Feels like"
        label.font = .italicSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let weatherIconImageView : UIImageView = {
        
        let imageView = UIImageView(image: UIImage(systemName: "nosign"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        
        return imageView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: view.bounds)
            imageView.center = view.center
            imageView.image = UIImage(named: "IMG_0293.PNG")
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
    
    private lazy var buttonThird: UIButton = {
       
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "IMG_0307.PNG"), for: .normal)
        button.addTarget(self, action: #selector(pressBttonUp(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(weatherIconImageView)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(feelsLikeTemperatureLabel)
        view.addSubview(buttonThird)
        setUpConstraints()
        
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else {
                return
            }
            self.updateInterfaceWith(weather: currentWeather)}
        
        

        
        
        
        
        
        
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
    
    private func setUpConstraints() {
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        cityLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 100).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        temperatureLabel.topAnchor.constraint(equalTo: cityLabel.topAnchor, constant: 20).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        buttonThird.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        buttonThird.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        buttonThird.heightAnchor.constraint(equalToConstant: 70).isActive = true
        buttonThird.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        feelsLikeTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: 20).isActive = true
        feelsLikeTemperatureLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        weatherIconImageView.topAnchor.constraint(equalTo: feelsLikeTemperatureLabel.topAnchor, constant: 25).isActive = true
        weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        weatherIconImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        weatherIconImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
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
