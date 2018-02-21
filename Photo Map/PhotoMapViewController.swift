//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate
{
    

    @IBOutlet weak var mapView: MKMapView!
    
    var photo: UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let locations = segue.destination as? LocationsViewController
        {
            locations.delegate = self
            locations.userInfo = sender
        }
        
    }
    
    @IBAction func uploadPhoto(_ sender: Any)
    {
        createImagePicker()
    }
    
    
    func createImagePicker()
    {
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        let sourceType = isCameraAvailable ?
            UIImagePickerControllerSourceType.camera :
            UIImagePickerControllerSourceType.photoLibrary
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = sourceType
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if (info[UIImagePickerControllerEditedImage] as? UIImage) != nil {
            photo = info[UIImagePickerControllerEditedImage] as! UIImage
        } else {
            photo = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        dismiss(animated: true)
        {
            self.performSegue(withIdentifier: "tagSegue", sender: self.photo)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.tabBarController?.selectedIndex = 0
        dismiss(animated: true, completion: nil)
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber)
    {
        self.navigationController?.popViewController(animated: true)
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let image = controller.userInfo as! UIImage
        
        let annotation = PhotoAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.photo = image
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        return annotationView
    }
    
    
}
