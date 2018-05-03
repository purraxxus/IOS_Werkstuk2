import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var lastUpdated: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var villoStations: [VilloStation] = readStationInformation(readStationsFromDatabase())
        writeToMap(villoStations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func readStationsFromDatabase(){
        //connectie met database maken
        //Schrijf stationsNamen in array
        //return array
    }
    
    func readStationInformation(array:Array<String>){
        //connectie met database maken
        //return array met alle informatie over arrays in
    }
    
    func writeToMap(array:Array<VilloStation>){
        //lees locaties uit array
        //schrijf op kaart
    }
}
