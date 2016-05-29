//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Eduardo Nieves on 5/28/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking
import EZLoadingActivity

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noForecastView: UIView!
    
    
    let locationManager = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var forecasts: NSDictionary?
    var hourly: NSArray!
    var forecast: AnyObject!
    var date: NSDate!
    var temperature: Float!
    var iconImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
        requestWeatherInfo()
        // getCity() //(Works but sometimes returns nil, uncomment to try it)
    }
    
    func requestWeatherInfo(){
        let apiKey = "112a30e1ebd1319d29fe3e5071a074af"
        let url = NSURL(string:"https://api.forecast.io/forecast/\(apiKey)/\(latitude),\(longitude)")
        
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.forecasts = responseDictionary["hourly"] as? NSDictionary
                            self.hourly = self.forecasts!["data"]! as! NSArray
                            self.tableview.reloadData()
                    }
                }
        });
        task.resume()
        
    }
    
    //Gets the city name of the user
    func getCity(){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude,longitude: longitude)
        geoCoder.reverseGeocodeLocation(location)
            {
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!
                
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                // City
                if let city = placeMark.addressDictionary?["City"] as? NSString
                {
                    self.navigationItem.title = city as String
                }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as! WeatherCell
        forecast = hourly[indexPath.row]
        
        //Set and truncates the temperature to two decimals places
        temperature = forecast["temperature"]!! as! Float
        cell.temperatureLabel.text = String.localizedStringWithFormat("%.2f",temperature)
        
        
        //Convert time from Unix to Specific Date
        let unixTime = forecast["time"]!! as! Double
        date = NSDate(timeIntervalSince1970: unixTime)
        cell.time.text = String(date)
        
        //Sets the summary
        cell.summaryLabel.text = String(forecast["summary"]!!)
        
        //Receives the icon name and picks the according image
        let imageName = String(forecast["icon"]!!)
        
        if imageName == "clear-day"{
            iconImage = UIImage(named:"clearSky.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "clear-night"{
            iconImage =  UIImage(named:"clearNight.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "rain"{
            iconImage =  UIImage(named:"rain.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "snow"{
            iconImage =  UIImage(named:"snow.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "sleet"{
            iconImage = UIImage(named:"sleet.png")
            cell.icon.image = iconImage
        }
        else if imageName == "rain"{
            iconImage = UIImage(named:"rain.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "wind"{
            iconImage = UIImage(named:"wind.png")
            
            cell.icon.image = iconImage
        }
        else if imageName == "fog"{
            iconImage = UIImage(named:"fog.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "cloudy"{
            iconImage =  UIImage(named:"cloudy.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "partly-cloudy-day"{
            iconImage = UIImage(named:"partlyCloudyDay.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "partly-cloudy-night"{
            iconImage = UIImage(named:"partlyCloudyNight.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "thunderstorm"{
            iconImage = UIImage(named:"thunderstorm.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "tornado"{
            iconImage = UIImage(named:"tornado.png")
            cell.icon.image =  iconImage
        }
        else if imageName == "hail"{
            iconImage = UIImage(named:"hail.png")
            cell.icon.image =  iconImage
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forecasts?.count == 0 || forecasts == nil {
            noForecastView.hidden = false
            return 0
        }
        else {
            noForecastView.hidden = true
            EZLoadingActivity.hide(success: true, animated: true)
            return self.forecasts!["data"]!.count
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "DetailedSegue"{
            let detailWeatherViewController = segue.destinationViewController as! DetailedWeatherViewController
            detailWeatherViewController.forecast = forecast
            detailWeatherViewController.date = String(date)
            detailWeatherViewController.temperature = String.localizedStringWithFormat("%.2f",temperature)
            detailWeatherViewController.icon = iconImage
        }
        
    }
}