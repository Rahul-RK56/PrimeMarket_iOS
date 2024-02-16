//
//  MapVC.swift
//  SMarket
//
//  Created by Dhana Gadupooti on 15/07/21.
//  Copyright © 2021 Mind. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, UISearchBarDelegate {

   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {

            textfield.backgroundColor = UIColor.lightText
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search pleace", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])

            textfield.textColor = UIColor.black

            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
        }
        searchBar.delegate = self
    }
  

    @IBAction func searchButton(_ sender: Any) {
//        let searchController = UISearchController(searchResultsController: nil)
//
//               searchController.searchBar.delegate = self
//               present(searchController,animated: true,completion: nil)
        searchLocationButtonClicked()
    }
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       // searchLocationButtonClicked()
        UIApplication.shared.beginIgnoringInteractionEvents()

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()

        self.view.addSubview(activityIndicator)

        //Hide search bar
        searchBar.resignFirstResponder()

        dismiss(animated: true, completion: nil)

        // create the serach request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = self.searchBar.text

        let activeSearch = MKLocalSearch(request: searchRequest)

        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("ERROR")
            }else{
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)

                //Gettng data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude

                //create annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)


                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)

            }
        }
    }
  

    func searchLocationButtonClicked(){
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
        // create the serach request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = self.searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("ERROR")
            }else{
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                //Gettng data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //create annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
                
            }
    }
    }
}
