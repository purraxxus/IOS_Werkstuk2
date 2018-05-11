import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var lastUpdated: UILabel!
    
    var annotations: [Annotation] = []
    
    @IBAction func buttonAction(_ sender: Any) {
        dispatchGroup.enter()
        showData(dataSet: annotations)
    }
    
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
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
                let enter = "\n"
                let stands = "available stands: "
                let bikes = "available bikes: "
                let name = value["name"] as? String ?? "no name available"
                let status = value["status"] as? String ?? "no status available"
                let address = value["address"] as? String ?? "no address available"
                let available_bike_stands = value["available_bike_stands"] as? String ?? "no bike stands data available"
                let available_bikes = value["available_bikes"] as? String ?? "no bike data available"
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
                let annotation = Annotation(title: name, subtitle: address + enter + status + enter + stands + available_bike_stands + enter + bikes + available_bikes, coordinate: CLLocationCoordinate2DMake(lat,lng))
                self.annotations.append(annotation)
            }
            self.dispatchGroup.leave()
        }
        task.resume()
    }

}
