//
//  ViewController.swift
//  Mother
//
//  Created by Apple on 19/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
    lazy var functions = Functions.functions()
    
    var latitude:Double = 0
    var longtitude:Double = 0
    
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    let previewDemoData = [(title: "The Polar Junction", img: #imageLiteral(resourceName: "restaurant1"), price: 10), (title: "The Nifty Lounge", img: #imageLiteral(resourceName: "restaurant2"), price: 8), (title: "The Lunar Petal", img: #imageLiteral(resourceName: "restaurant3"), price: 12), (title: "Yeojin", img: #imageLiteral(resourceName: "yeojin"), price: 12)]
    
    private lazy var navigationBar = MapSearchNavigationView.loadViewFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "여진이 어딨어?"
        self.view.backgroundColor = UIColor.white
        myMapView.delegate=self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupViews()
        
        initGoogleMaps()
        
        txtFieldSearch.delegate=self
    }
    
    //MARK: textfield
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
    
    // 여긴 언제 호출되는거??
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        showYeojinMarkers(lat: lat, long: long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
        txtFieldSearch.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = myMapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.myMapView.animate(to: camera)
        
//        showYeojinMarkers(lat: lat, long: long)
    }
    
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = previewDemoData[customMarkerView.tag]
        restaurantPreviewView.setData(title: data.title, img: data.img, price: data.price)
        return restaurantPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
        restaurantTapped(tag: tag)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    func showYeojinMarkers(lat: Double, long: Double) {
        myMapView.clear()
//        for i in 0..<3 {
//            let randNum=Double(arc4random_uniform(30))/10000
            let marker=GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[3].img, borderColor: UIColor.darkGray, tag: 3)
            marker.iconView=customMarker
//            let randInt = arc4random_uniform(4)
//            if randInt == 0 {
//                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long-randNum)
//            } else if randInt == 1 {
//                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long+randNum)
//            } else if randInt == 2 {
//                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long-randNum)
//            } else {
//                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long+randNum)
//            }
        
//        37.247140, 127.066308
//        37.249756, 127.066341
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.map = self.myMapView
//        }
    }
    
    @objc func btnMyLocationAction() {
//        let location: CLLocation? = myMapView.myLocation
//        if location != nil {
//            myMapView.animate(toLocation: (location?.coordinate)!)
//        }
        
//        let cur_time:String  = String(NSDate().timeIntervalSince1970 * 1000)
//        print("cur_time :"+cur_time)
//        let data = ["time": cur_time/*,
//                    "secondNumber": Int(number2Field.text!)*/]
//
//
//        functions.httpsCallable("reqInfo").call(data) { (result, error) in
//            // [START function_error]
//            if let error = error as NSError? {
//                if error.domain == FunctionsErrorDomain {
//                    let code = FunctionsErrorCode(rawValue: error.code)
//                    let message = error.localizedDescription
//                    let details = error.userInfo[FunctionsErrorDetailsKey]
//                }
//                // [START_EXCLUDE]
//                print(error.localizedDescription)
//                return
//                // [END_EXCLUDE]
//            }
//            // [END function_error]
//            if let operationResult = (result?.data as? [String: Any])?["operationResult"] as? Int {
////                self.resultField.text = "\(operationResult)"
//                print("error")
//            }
//        }
        
        let ref = Firestore.firestore().collection("cur_location").document("lLxQJ1cOQv5nU3HNNSSm")
        ref.getDocument { (snapshot, err) in
            if let data = snapshot?.data() {
                print(data["cur_latitude"])
                print(data["cur_longtitude"])
                
                //37.251487, 127.071104
                var lat:Double = 37.251487
                var long:Double = 127.071104
                self.showYeojinMarkers(lat:lat, long:long)
            } else {
                print("Couldn't find the document")
            }
        }
    }
    
    @objc func btnReqCurLocationAction() {
        
//        let ref = Firestore.firestore().collection("cur_location").document("lLxQJ1cOQv5nU3HNNSSm")
//        ref.getDocument { (snapshot, err) in
//            if let data = snapshot?.data() {
//                print(data["cur_latitude"])
//                print(data["cur_longtitude"])
//
//            } else {
//                print("Couldn't find the document")
//            }
//        }
        
        functions.httpsCallable("sendFCM").call() { (result, error) in
            // [START function_error]
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                }
                // [START_EXCLUDE]
                print(error.localizedDescription)
                
                ToastView.init(message: "여진앱으로 메시지 전송완료").show()
                return
                // [END_EXCLUDE]
            }
            // [END function_error]
            if let operationResult = (result?.data as? [String: Any])?["operationResult"] as? Int {
//                self.resultField.text = "\(operationResult)"
                print("error")
            }
        }

    }

    
    @objc func btnShowCurLocationAction() {

//        //37.251487, 127.071104
//        latitude = 37.251487
//        longtitude = 127.071104
        
        let ref = Firestore.firestore().collection("cur_location").document("lLxQJ1cOQv5nU3HNNSSm")
        ref.getDocument { (snapshot, err) in
            if let data = snapshot?.data() {
//                print(data["cur_latitude"])
//                print(data["cur_longtitude"])
                
                //37.251487, 127.071104
                let la:String = data["cur_latitude"] as! String
                let lo:String = data["cur_longtitude"] as! String
                
//                let la = String(data["cur_latitude"]).toDouble
//                let lo = String(data["cur_longtitude"]).toDouble
                
                print("la :\(la), lo:\(lo)");
                
                if let la_value:Double = la.toDouble(), let lo_value:Double = lo.toDouble() {
                    self.latitude = la_value
                    self.longtitude = lo_value
                    
                    //                self.showYeojinMarkers(lat:self.latitude, long:self.longtitude)
                    
                    let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longtitude, zoom: 17.0)
                    self.myMapView.animate(to: camera)
                    self.showYeojinMarkers(lat:self.latitude, long:self.longtitude)
                }
                
                

            } else {
                print("Couldn't find the document")
            }
        }
        
        

    }

    
    @objc func restaurantTapped(tag: Int) {
        let v=DetailsVC()
        v.passedData = previewDemoData[tag]
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    func setupViews() {
        view.addSubview(myMapView)
        myMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        myMapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        myMapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        
        
        navigationItem.titleView = navigationBar
        
//        self.view.addSubview(txtFieldSearch)
//
//        if #available(iOS 11.0, *) {
//        txtFieldSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive=true
//        }
//        txtFieldSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
//        txtFieldSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive=true
//        txtFieldSearch.heightAnchor.constraint(equalToConstant: 35).isActive=true
//
//        setupTextField(textField: txtFieldSearch, img: #imageLiteral(resourceName: "gps-fixed-indicator-6"))
//
        restaurantPreviewView=RestaurantPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        
        // 현재 위치 버튼
        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive=true
        btnMyLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
        // 여진 현재 위치 요청 버튼
        self.view.addSubview(btnReqCurLocation)
        btnReqCurLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive=true
        btnReqCurLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive=true
        btnReqCurLocation.widthAnchor.constraint(equalToConstant: 110).isActive=true
        btnReqCurLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
        
        
        // 여진 현재 위치 표시 버튼
        self.view.addSubview(btnShowCurLocation)
        btnShowCurLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive=true
        btnShowCurLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 220).isActive=true
        btnShowCurLocation.widthAnchor.constraint(equalToConstant: 110).isActive=true
        btnShowCurLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
    }
    
    let myMapView: GMSMapView = {
        let v=GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="Search for a location"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "gps-fixed-indicator-6 copy"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btnReqCurLocation: UIButton = {
//        let btn=UIButton()
////        btn.backgroundColor = UIColor.white
////        btn.setImage(#imageLiteral(resourceName: "restaurant3"), for: .normal)
////        btn.layer.cornerRadius = 25
//        btn.clipsToBounds=true
//        btn.tintColor = UIColor.gray
////        btn.imageView?.tintColor=UIColor.gray
//        btn.setTitle("현재위치 요청", for: .normal)
//        btn.addTarget(self, action: #selector(btnReqCurLocationAction), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints=false
//        return btn
        
        let btn:UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 200, height: 50))
        btn.backgroundColor = .black
        btn.setTitle("현재위치 요청", for: .normal)
        btn.addTarget(self, action: #selector(btnReqCurLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    let btnShowCurLocation: UIButton = {
//        let btn=UIButton()
//        btn.backgroundColor = UIColor.white
//        btn.setImage(#imageLiteral(resourceName: "restaurant3"), for: .normal)
//        //        btn.layer.cornerRadius = 25
//        btn.clipsToBounds=true
//        btn.tintColor = UIColor.gray
//        btn.imageView?.tintColor=UIColor.gray
//        btn.addTarget(self, action: #selector(btnShowCurLocationAction), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints=false
//        return btn
        
        let btn:UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 200, height: 50))
        btn.backgroundColor = .black
        btn.setTitle("현재위치 표시", for: .normal)
        btn.addTarget(self, action: #selector(btnShowCurLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    var restaurantPreviewView: RestaurantPreviewView = {
        let v=RestaurantPreviewView()
        return v
    }()
}





