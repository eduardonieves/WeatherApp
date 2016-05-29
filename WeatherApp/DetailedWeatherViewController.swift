//
//  DetailedWeatherViewController.swift
//  WeatherApp
//
//  Created by Eduardo Nieves on 5/28/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class DetailedWeatherViewController: UIViewController {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var SummaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var HumidityLabel: UILabel!
    @IBOutlet weak var VisibilityLabel: UILabel!
    @IBOutlet weak var PressureLabel: UILabel!
    @IBOutlet weak var precpProbLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var forecast: AnyObject!
    var icon: UIImage!
    var temperature: String!
    var date: String!
    var visibilty:Float!
    var humidity:Float!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImage.image = icon
        dateLabel.text = date
        temperatureLabel.text = temperature
        SummaryLabel.text = String(forecast["summary"]!!)
        windSpeedLabel.text = "\(String(forecast["windSpeed"]!!)) mph"
        precpProbLabel.text = "\(String(forecast["precipProbability"]!!))%"
        visibilty = forecast["visibility"]!! as! Float
        VisibilityLabel.text = "\(String.localizedStringWithFormat("%.2f",visibilty)) mph"
        humidity = forecast["humidity"]!! as! Float
        HumidityLabel.text = String.localizedStringWithFormat("%.2f",humidity)
        PressureLabel.text = "\(String(forecast["pressure"]!!)) milibars"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
