//
//  ViewController.swift
//  Pokemon
//
//  Created by user on 7/14/17.
//  Copyright © 2017 Vazquez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    
    var manager = CLLocationManager()
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pokemons = getAllPokemon()
            
        manager.delegate = self
        
        
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            setUp()
            
        } else {
        
        manager.requestWhenInUseAuthorization()
    }
    
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            setUp()
            
        }
    }
    
    func setUp() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            // Spawn a pokemon
            
            if let coord = self.manager.location?.coordinate {
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let anno =  PokeAnnotation(coord: coord, pokemon: pokemon)
                let randoLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randoLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLon
                
                
                self.mapView.addAnnotation(anno)
                
            }
        })

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player")
            var frame  = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
            
            return annoView
            
        }
        
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        annoView.image = UIImage(named: pokemon.imageName!)
        
        var frame  = annoView.frame
        
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        
        return annoView
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            
        
        let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
        mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
    
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon

                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()

                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats", message: "You cuaght \(pokemon.name!). You are a pokemon master", preferredStyle: .alert)
                    let Pokedexaction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in self.performSegue(withIdentifier: "pokedexsegue", sender: nil) })
                    alertVC.addAction(Pokedexaction)
                    
                    let OKaction = UIAlertAction(title: "ok", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    let alertVC = UIAlertController(title: "UH-UH", message: "You are too far way to catch the \(pokemon.name!). Move closer to it!", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "ok", style: .default, handler: nil)
                    
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }

        })
        
        
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        
        if let coord = manager.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        mapView.setRegion(region, animated: true)
        }

    }
    
    
}
