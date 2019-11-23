//
//  ViewController.swift
//  WeatherApp
//
//  Created by Питонейшество on 12/11/2019.
//  Copyright © 2019 Питонейшество. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {
    
    var realm = try! Realm()
    var weatherList: Results<Weather> {
        get {
            return realm.objects(Weather.self)
        }
    }
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescripLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var getForecastButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getForecastButton.layer.cornerRadius = 16
        getForecastButton.layer.borderWidth = 1
        getForecastButton.layer.borderColor = UIColor.darkGray.cgColor
        
        getRealmWeather()
        
        let seconds = 1.5
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + seconds) {
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=101000&lang=en&appid=b1b35bba8b434a28a0be2a3e1071ae5b&units=metric") else { return }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, error == nil {
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                        guard  let weatherDetails = json["weather"] as? [[String: Any]], let weatherMain = json["main"] as? [String: Any] else { return }
                        let temp = Int (weatherMain ["temp"] as? Double ?? 0)
                        let description = (weatherDetails.first?["description"] as? String)
                        let icon = (weatherDetails.first?["icon"] as? String)
                        let name = json["name"] as? String
                        DispatchQueue.main.async {
                            self.setWeather(weather: weatherDetails.first? ["main"] as? String, description: description, temp: temp, name: name, icon: icon)
                        }
                    } catch {
                        print ("we had an error")
                    }
                }
            }
            task.resume()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setWeather (weather: String?, description: String?, temp: Int, name: String?, icon: String?) {
        weatherDescripLabel.text = description ?? "..."
        tempLabel.text = "\(temp)º"
        cityNameLabel.text = name ?? "..."
        iconImageView.image = UIImage(named: icon!)
        
        switch  icon {
        case "01d", "02d":
            self.view.backgroundColor = UIColor (red: 0.97, green: 0.78, blue: 0.35, alpha: 1.0)
        default:
            self.view.backgroundColor = UIColor (red: 0.42, green: 0.55, blue: 0.71, alpha: 1.0)
        }
        let realmWeather = realm.objects(Weather.self).first
        let weatherToSave = Weather()
        if weatherList.count == 0 {
            try! realm.write {
                weatherToSave.city = name ?? "..."
                weatherToSave.descript = description ?? "..."
                weatherToSave.icon = icon ?? "..."
                weatherToSave.temp = temp
                realm.add(weatherToSave)
            }
        }
        else {
            print ("666")
//            try! realm.write {
//                realm.delete(realmWeather!)
//            }
            print(realmWeather as Any, "666")
            try! realm.write {
                realmWeather?.city = name ?? "..."
                realmWeather?.descript = description ?? "..."
                realmWeather?.icon = icon ?? "..."
                realmWeather?.temp = temp
            }
        }
//        let realmWeather = realm.objects(Weather.self).first
//        print (realmWeather as Any)

//        try! realm.write {
//            realm.delete(realmWeather)
//        }
        print (weatherList.count)
        for w in weatherList {
            print (w.city, w.temp, w.descript, w.icon)
        }
    }
    
    func getRealmWeather() {
        if weatherList.count == 0 {
            weatherDescripLabel.text = ""
            tempLabel.text = ""
            cityNameLabel.text = ""
            iconImageView.image = UIImage(named: "xxx" )
        }
        else {
            let realmWeather = weatherList[0]
            weatherDescripLabel.text = realmWeather.descript
            tempLabel.text = "\(realmWeather.temp)º"
            cityNameLabel.text = realmWeather.city
            iconImageView.image = UIImage(named: realmWeather.icon )
        }
    }
    
    @IBAction func getForecast(_ sender: Any) {
        performSegue(withIdentifier: "ToForecast", sender: nil)
    }
}

