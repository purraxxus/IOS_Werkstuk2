import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var lastUpdated: UILabel!
    
    var annotations: [Annotation] = []
    
    @IBAction func buttonAction(_ sender: Any) {
        dispatchGroup.enter()
        self.lastUpdated.text = NSLocalizedString("Last update", comment: "") + ": " + getTodayString()
        showData(dataSet: annotations)
    }
    
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lastUpdated.text = NSLocalizedString("Last update", comment: "") + ": " + getTodayString()
        self.updateButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        dispatchGroup.enter()
        getData(urlString: "https://api.jcdecaux.com/vls/v1/stations?apiKey=c7e226e356101d8a519809679aba25090209ca8e")
        dispatchGroup.wait()
        dispatchGroup.enter()
        self.showData(dataSet: self.annotations)
        print("test")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showData(dataSet: [Annotation]){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        for marker in dataSet {
            mapView.addAnnotation(marker)
        }
        dispatchGroup.leave()
    }
    
    func getTodayString() -> String{
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        return today_string
    }
    
    func getData(urlString: String){
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error GET")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("no data")
                return
            }
            guard let villoData = try? JSONSerialization.jsonObject(with: responseData, options: []) as! [AnyObject] else {
                print("failed JSONSerialization")
                return
            }
            for value in villoData {
                let bikes = NSLocalizedString("available bikes: ", comment: "")
                let name = value["name"] as? String ?? NSLocalizedString("no name available", comment: "")
                let status = value["status"] as? String ?? NSLocalizedString("no status available", comment: "")
                let available_bikes = value["available_bikes"] as? String ?? NSLocalizedString("no bike data available", comment: "")
                var lat:Double = 0.0
                var lng:Double = 0.0
                for (pos,posValue) in (value["position"] as? NSDictionary)!{
                    if pos as! String == "lat"{
                        lat = posValue as! Double
                    }
                    if pos as! String == "lng"{
                        lng = posValue as! Double
                    }
                }
                let annotation = Annotation(title: name, subtitle: status + " - " + bikes + available_bikes, coordinate: CLLocationCoordinate2DMake(lat,lng))
                self.annotations.append(annotation)
            }
            self.dispatchGroup.leave()
        }
        task.resume()
    }

}
