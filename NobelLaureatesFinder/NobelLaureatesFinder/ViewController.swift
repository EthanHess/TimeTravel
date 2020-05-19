//
//  ViewController.swift
//  NobelLaureatesFinder
//
//  Created by Ethan Hess on 5/15/20.
//  Copyright © 2020 Ethan Hess. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    //MARK properties
    let searchFieldLat : UITextField = {
        let sfl = UITextField()
        sfl.placeholder = "Latitude"
        sfl.backgroundColor = .white
        sfl.textColor = .black
        sfl.keyboardType = .numberPad
        return sfl
    }()
    
    let searchFieldLong : UITextField = {
        let sfl = UITextField()
        sfl.placeholder = "Longitude"
        sfl.backgroundColor = .white
        sfl.textColor = .black
        sfl.keyboardType = .numberPad
        return sfl
    }()
    
    //1900 to 2020
    let yearField : UITextField = {
        let yf = UITextField()
        yf.placeholder = "Year"
        yf.backgroundColor = .white
        yf.textColor = .black
        yf.keyboardType = .numberPad
        return yf
    }()
    
    //Need to add year?
    
    let showHideTableViewButton : UIButton = {
        let shButton = UIButton()
        shButton.setTitle("Hide Table", for: .normal)
        return shButton
    }()
    
    let searchButton : UIButton = {
        let sButton = UIButton()
        sButton.setTitle("Search", for: .normal)
        return sButton
    }()
    
    let fieldContainer : UIView = {
        let fc = UIView()
        fc.backgroundColor = .black
        return fc
    }()
    
    let mapView : MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    let resultsTable : UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .grouped)
        return tv
    }()
    
    var laureateArray : [NobelLaureate] = []
    var filteredLaureateArray : [NobelLaureate] = [] //populate tableview + annotations
    
    //Fetching Laureates may take a second or two
    var hasLoadedData = false
    
    //MARK lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureViews()
    }
    
    // MARK Functionality

    // MARK Algorithm
    
    // NOTES: Needs to be better than O(n^2) (Quadratic) i.e. no nested for loops etc.
    // Needs to be optimized for multiple sequential queries, i.e. store data from searches for faster lookup
    // Cost traveling through both space and time
    
    // Your time machine is capable of moving 1 year through time expending the same energy as traveling 10km along the surface of Earth. You should consider a jump of (2 years + 0km) as equivalent to (1 year + 10km) and (0 years + 20km)
    
    // Travel to same year is zero cost (will be ordered by cost finally)
    
    @objc fileprivate func searchTapped() {
        if !validYearInput() {
            GlobalFunctions.presentAlert(title: "Please enter a year between 1900 and 2020", text: "", fromVC: self)
            return
        }
        if !canSearch() {
            GlobalFunctions.presentAlert(title: "Sorry, there was an error", text: "Please try again", fromVC: self)
        } else {
            //Parameters
            let lat = Double(searchFieldLat.text!)
            let long = Double(searchFieldLong.text!)
            let year = Int(yearField.text!)
            
            let key = self.hashKeyFromTextInput(lat: lat!, long: long!, year: year!)
            
            if let storedResults = Algorithm.fetchSearchResults(key: key) {
                Logger.log("--- CACHED RESULTS --- \(storedResults)")
                self.setArrayAndRefresh(array: storedResults)
            } else {
                //Execution
                Algorithm.performSearchWithArray(array: self.laureateArray, latitude: lat!, longitude: long!, year: year!) { (nearestTwenty) in
                    guard let filteredLaureates = nearestTwenty else {
                        Logger.log("")
                        return
                    }
                    self.setArrayAndRefresh(array: filteredLaureates)
                    Algorithm.cacheResults(key: key, results: filteredLaureates)
                }
            }
        }
    }
    
    //D.R.Y.
    fileprivate func setArrayAndRefresh(array: [NobelLaureate]) {
        self.filteredLaureateArray = array
        self.refreshTable()
        self.refreshMapView()
    }
    
    fileprivate func hashKeyFromTextInput(lat: Double, long: Double, year: Int) -> String {
        return "\(lat)\(long)\(year)"
    }
    
    fileprivate func canSearch() -> Bool {
        return yearField.text != "" && searchFieldLong.text != "" && searchFieldLat.text != "" && hasLoadedData == true
    }
    
    fileprivate func validYearInput() -> Bool {
        guard let yearFieldText = yearField.text else {
            return false
        }
        if yearFieldText == "" {
            return false
        }
        return Int(yearFieldText)! > 1899 && Int(yearFieldText)! < 2021
    }
    
    @objc fileprivate func showHideTableView() {
        resultsTable.isHidden = !resultsTable.isHidden
        let title = resultsTable.isHidden ? "Show Table" : "Hide Table"
        showHideTableViewButton.setTitle(title, for: .normal)
    }
    
    //MARK UI setup
    
    fileprivate func configureViews() {
        
        textFieldsSetup()
        fetchData()
    }
    
    fileprivate func textFieldsSetup() {
        //Main container (top)
        view.addSubview(fieldContainer)
        fieldContainer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 200)
        fieldContainer.addSubview(searchFieldLat)
        
        //Text fields
        let topStack = UIStackView(arrangedSubviews: [searchFieldLat, searchFieldLong, yearField])
        topStack.distribution = .fillEqually
        topStack.axis = .vertical
        topStack.spacing = 5
        fieldContainer.addSubview(topStack)
        topStack.anchor(top: fieldContainer.topAnchor, left: fieldContainer.leftAnchor, bottom: nil, right: fieldContainer.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        searchFieldLat.delegate = self
        searchFieldLong.delegate = self
        yearField.delegate = self
    
        //Buttons
        let bottomStack = UIStackView(arrangedSubviews: [showHideTableViewButton, searchButton])
        bottomStack.distribution = .fillEqually
        bottomStack.axis = .horizontal
        fieldContainer.addSubview(bottomStack)
        bottomStack.anchor(top: topStack.bottomAnchor, left: fieldContainer.leftAnchor, bottom: fieldContainer.bottomAnchor, right: fieldContainer.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        
        showHideTableViewButton.addTarget(self, action: #selector(showHideTableView), for: .touchUpInside)
        searchButton.addTarget(self, action:#selector(searchTapped), for: .touchUpInside)
        
        stylizeView(view: fieldContainer)
        stylizeView(view: searchFieldLat)
        stylizeView(view: searchFieldLong)
        stylizeView(view: yearField)
        stylizeView(view: showHideTableViewButton)
        stylizeView(view: searchButton)
        
        registerTableView()
    }
    
    fileprivate func registerTableView() {
        resultsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        resultsTable.delegate = self
        resultsTable.dataSource = self
        tableViewSetup()
    }
    
    fileprivate func tableViewSetup() {
        view.addSubview(resultsTable)
        resultsTable.anchor(top: fieldContainer.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
        stylizeView(view: resultsTable)
        mapSetup()
    }
    
    fileprivate func mapSetup() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        view.insertSubview(mapView, at: 0)
    }
    
    //MARK Networking
    fileprivate func fetchData() {
        guard let url = Bundle.main.url(forResource: "nobel-prize-laureates", withExtension: "json") else {
            Logger.log("--- Invalid URL ---")
            return
        }
        NetworkController.fetchDataFromJSON(theURL: url) { (laureates, error) in
            if error != nil {
                Logger.log("\(error?.localizedDescription ?? "--- No description ---")")
            } else {
                if let laureatesArray = laureates {
                    Logger.log("LAUREATES \(laureatesArray)")
                    self.laureateArray = laureatesArray
                    self.hasLoadedData = true
                    //Won't do anything on initial fetch, will sort input of UITextFields
                }
            }
        }
    }
    
    fileprivate func refreshTable() {
        resultsTable.reloadData()
    }
    
    fileprivate func refreshMapView() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let laureates = self.filteredLaureateArray.map { (laureate) -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = laureate.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: laureate.location.lat, longitude: laureate.location.lng)
            return annotation
        }
        self.mapView.addAnnotations(laureates)
    }
    
    //MARK UI Auxiliary
    fileprivate func stylizeView(view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = true
    }
    
    //Dismiss number pad
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK Delegates + Datasources
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLaureateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let laureate = self.filteredLaureateArray[indexPath.row]
        cell?.textLabel?.text = "NAME: \(laureate.name) -- COST \(laureate.cost)"
        return cell!
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let ann = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation")
        //TODO config
        return ann
    }
}
