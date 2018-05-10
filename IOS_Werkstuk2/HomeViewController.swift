import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var lastUpdated: UILabel!
    
    var annotations: [Annotation] = []
    
    @IBAction func buttonAction(_ sender: Any) {
        showData(dataSet: annotations)
    }
    
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        getData(urlString: "https://api.jcdecaux.com/vls/v1/stations?apiKey=c7e226e356101d8a519809679aba25090209ca8e")
        self.showData(dataSet: self.annotations)
        print("test")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showData(dataSet: [Annotation]){
        self.mapView.addAnnotations(dataSet)
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
                let name = value["name"] as? String
                let annotation = Annotation(title: name!, subtitle: "test", coordinate: CLLocationCoordinate2DMake(50.7756865,4.19168370))
                self.annotations.append(annotation)
            }
        }
        task.resume()
    }

}
