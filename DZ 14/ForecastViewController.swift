//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Питонейшество on 13/11/2019.
//  Copyright © 2019 Питонейшество. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var weatherArray = [AnyObject]()
    
    var realm: Realm!
    var forecastList: Results<Forecast> {
        get {
            return realm.objects(Forecast.self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        let seconds = 1.5
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + seconds) {
    Alamofire.request("https://api.openweathermap.org/data/2.5/forecast?q=moscow,ru&appid=5a06c113652fc9950fab13d490740cc7&units=metric").responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject>{
                if let innerDict = dict["list"] {
                    self.weatherArray = innerDict as! [AnyObject]
                    for (index, item) in self.weatherArray.enumerated() where item is NSDictionary {
                        let date = item["dt_txt"] as? String
                        let main = item["main"] as? Dictionary<String,AnyObject>
                        let weather = item["weather"] as? [AnyObject]
                        let temp = main!["temp"]
                        let weatherDict = weather![0]
                        let icon = weatherDict["icon"]
                        if self.forecastList.count < 5*8 {
                            let forecastToSave = Forecast()
                            try! self.realm.write {
                                forecastToSave.date = date ?? "..."
                                forecastToSave.icon = icon as! String
                                forecastToSave.temp = Int(round(temp as! Double))
                                self.realm.add(forecastToSave)
                            }
                        }
                        else {
                            let realmForecast = self.realm.objects(Forecast.self)[index]
                            try! self.realm.write {
                                //realmForecast.date = "xxxxxxx"
                                realmForecast.date = date ?? "..."
                                realmForecast.icon = icon as! String
                                realmForecast.temp = Int(truncating: temp as! NSNumber)
                            }
                        }
                    }
                    self.tableView.backgroundColor = .lightGray
                    self.tableView.reloadData()
                }
            }
        }
    }
        self.tableView.rowHeight = 44
        
        let realmForecast = realm.objects(Forecast.self)
//        try! realm.write {
//            realm.delete(realmForecast)
//        }
        print(realmForecast as Any, "666")
        print (realmForecast.count)
        for f in realmForecast {
            print (f.date, f.temp, f.icon)
        }

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //weatherArray.count
        realm.objects(Forecast.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastTableViewCell
        let realmForecast = realm.objects(Forecast.self)[indexPath.row]
        cell?.dateTimeLabel.text = realmForecast.date
        cell?.tempLabel.text = "\(realmForecast.temp)º"
        cell?.iconImageView.image = UIImage(named: realmForecast.icon)
        cell?.backgroundColor = .clear
//        switch realmForecast.icon {
//        case "01d", "02d":
//            cell?.backgroundColor = UIColor (red: 0.97, green: 0.78, blue: 0.35, alpha: 1.0)
//        default:
//            cell?.backgroundColor = UIColor (red: 0.42, green: 0.55, blue: 0.71, alpha: 1.0)
//        }
        return cell!
    }
}

