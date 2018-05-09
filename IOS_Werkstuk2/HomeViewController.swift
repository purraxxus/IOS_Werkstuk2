import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var lastUpdated: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://api.jcdecaux.com/vls/v1/stations?apiKey=c7e226e356101d8a519809679aba25090209ca8e"
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
            guard let villoData = try? JSONSerialization.jsonObject(with: responseData, options: []) as! NSArray else {
                print("failed JSONSerialization")
                return
            }
            
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
