//
//  PlacePickerViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 20/07/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import CoreLocation


protocol MyAddressDelegateProtocol {
    func sendDataToFirstViewController(myData: String)
}

class PlacePickerViewController: UIViewController {
    
    //@IBOutlet weak var txtSearch : leftImageTextField!

    @IBOutlet weak var mapView: MKMapView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var newDoneButton : UIBarButtonItem?
    
    @IBOutlet weak var searchResultsTableView:UITableView!
    
    var delegate: MyAddressDelegateProtocol? = nil
    let locationManager = CLLocationManager()
  
    var addressString : String = ""
      
    override func viewDidLoad() {
        super.viewDidLoad()
       
//       if self.delegate != nil && addressString != nil {
//        let dataToBeSent = addressString
//        self.delegate?.sendDataToFirstViewController(myData: dataToBeSent)
//        dismiss(animated: true, completion: nil)
//                     }
        
//        let coordinate = CLLocationCoordinate2D(latitude: 13.18040, longitude: 80.25832)
//
//       let latitude =  String(coordinate.latitude)
//        let longitude =  String(coordinate.longitude)
//         let locality =  getAddressFromLatLon(pdblLatitude: latitude, withLongitude: longitude)
//         let locat = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//         self.centerMapOnLocation(locat, mapView: self.mapView)
//         let annotation = MKPointAnnotation()
//         annotation.coordinate = coordinate
//         annotation.title = locality
//
//         mapView.addAnnotation(annotation)
//
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
        
        // self.navigationItem.hidesBackButton = true
        
        //modification
         let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.back(sender:)))
         newDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.done(sender:)))
      
        self.navigationItem.rightBarButtonItem = nil
        
       // self.navigationItem.leftBarButtonItem = newBackButton
      
        searchResultsTableView.isHidden = true
    }
    @objc func done(sender: UIBarButtonItem) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Please Confirm Address", message: "", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = self.addressString
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text)")
            let controllersList =  self.navigationController?.viewControllers as! [UIViewController]
            var isExistVC =  false
            for controller in controllersList {
                if controller is RegisterViewController {
                    let regVC = controller as! RegisterViewController
                    regVC.adress1 = textField!.text!
                    print(regVC.adress1)
                    isExistVC =  true
                    self.navigationController?.popToViewController(regVC, animated: true)
                }
              
            }
            
            if !isExistVC {
             _ = self.navigationController?.popViewController(animated: true)
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        

       /* presentAlertViewWithOneButtonAndLabel(alertTitle: "Please Confirm Address", alertMessage: "\(addressString)", btnOneTitle: "ok") { ( okbutton) in
           
           let controllersList =  self.navigationController?.viewControllers as! [UIViewController]
           var isExistVC =  false
           for controller in controllersList {
               if controller is RegisterViewController {
                   let regVC = controller as! RegisterViewController
                   regVC.adress1 = self.addressString
                   isExistVC =  true
                   self.navigationController?.popToViewController(regVC, animated: true)
               }
             
           }
           
           if !isExistVC {
            _ = self.navigationController?.popViewController(animated: true)
           }
        }*/
        
    }
  
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        
        _ = navigationController?.popViewController(animated: true)
        
//       let controllersList =  self.navigationController?.viewControllers as! [UIViewController]
//        var isExistVC =  false
//        for controller in controllersList {
//            if controller is RegisterViewController {
//                let regVC = controller as! RegisterViewController
//                regVC.adress1 = self.addressString
//                isExistVC =  true
//                self.navigationController?.popToViewController(regVC, animated: true)
//            }
//
//        }
//
//        if !isExistVC {
//            _ = navigationController?.popViewController(animated: true)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          searchCompleter.delegate = self
        
        
//        if self.block != nil {
//            self.block!(nil,txtSearch.text)
//        }
        
         
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

   func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String{
       var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
       let lat: Double = Double("\(pdblLatitude)")!
       //21.228124
       let lon: Double = Double("\(pdblLongitude)")!
       //72.833770
       let ceo: CLGeocoder = CLGeocoder()
       center.latitude = lat
       center.longitude = lon
      var localityString : String = ""
       let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


       ceo.reverseGeocodeLocation(loc, completionHandler:
           {(placemarks, error) in
               if (error != nil)
               {
                   print("reverse geodcode fail: \(error!.localizedDescription)")
               }
               let pm = placemarks! as [CLPlacemark]

               if pm.count > 0 {
                   let pm = placemarks![0]
                
                  
                   if pm.subLocality != nil {
                    self.addressString = self.addressString + pm.subLocality! + ", "
                   }
                   if pm.thoroughfare != nil {
                       self.addressString = self.addressString + pm.thoroughfare! + ", "
                   }
                   if pm.locality != nil {
                       self.addressString = self.addressString + pm.locality! + ", "
                    localityString = localityString + pm.locality!
                   }
                   if pm.country != nil {
                       self.addressString = self.addressString + pm.country! + ", "
                   }
                   if pm.postalCode != nil {
                       self.addressString = self.addressString + pm.postalCode! + " "
                   }
                 
             }
            
            print(self.addressString)
            
       })
           
      return localityString
   }
   
   func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
       let regionRadius: CLLocationDistance = 10000
       let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
           regionRadius * 2.0, regionRadius * 2.0)
       mapView.setRegion(coordinateRegion, animated: true)
     
   }
   
}

extension PlacePickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let locat = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
        self.centerMapOnLocation(locat, mapView: self.mapView)
        
    }
}

extension PlacePickerViewController:SearchViewControllerDelegate {
    
    func getSelectedLocationDetails(location: MKLocalSearchCompletion, coordinate: CLLocationCoordinate2D) {
      let latitude =  String(coordinate.latitude)
       let longitude =  String(coordinate.longitude)
        let locality =  getAddressFromLatLon(pdblLatitude: latitude, withLongitude: longitude)
       
        self.navigationItem.rightBarButtonItem = newDoneButton
        let locat = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.centerMapOnLocation(locat, mapView: self.mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = locality
       
        mapView.addAnnotation(annotation)
     
    }
    
    
}


extension PlacePickerViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "LRF", bundle:nil)
            let mapVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                mapVC.delegate = self
        mapVC.modalPresentationStyle = .fullScreen
               self.present(mapVC, animated: true) {
               }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "LRF", bundle:nil)
         let mapVC = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.present(mapVC, animated: true) {
            
        }
       // searchCompleter.queryFragment = searchText
    }
    
  
}

extension PlacePickerViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension PlacePickerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension PlacePickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print(String(describing: coordinate))
           // self.delegate?.getSelectedLocationDetails(location: completion, coordinate: coordinate!)
            self.dismiss(animated: true) {
                
            }
        }
    }
}

