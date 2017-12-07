//
//  ViewController.swift
//  InmoviliariaVirtual
//
//  Created by Juan on 11/22/17.
//  Copyright © 2017 Juan. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class MapController: UIViewController, GMSMapViewDelegate, UITabBarControllerDelegate, UISearchBarDelegate{
    let urlListAvisos:String = "http://www.labolsita.esy.es/inmobiliariavirtual/api/controllers/aviso/lista.php"
    var activityInticator:UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchView: UISearchBar!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        mapView?.delegate = self
        
        activityInticator.center = self.view.center
        activityInticator.hidesWhenStopped = true
        activityInticator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityInticator)
        
        loadMaps(buscar:"")
        
    }
    
    @IBAction func refreshAvisos(_ sender: Any) {
        loadMaps(buscar:"")
    }
    
    @IBAction func searchAvisos(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func loadMaps(buscar:String){
        activityInticator.startAnimating()
        
        let camera = GMSCameraPosition.camera(withLatitude: -17.388150, longitude: -66.168342, zoom: 13)
        
        self.mapView.camera = camera
               
        //cargando en el mapa
        self.mapView.clear()
        
        let parameters:Parameters = [
            "descripcion": buscar
        ]        
        
        Alamofire.request(urlListAvisos, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil)
            .responseJSON(completionHandler:{
                (resultado) in
                switch(resultado.result){
                case .success(let value):
                    if let data = resultado.data, let _ = String(data: data, encoding: .utf8){
                        let cloudData = try! JSON(data: data)
                        
                        //self.mapView.clear()
                        
                        for (key,subJson):(String, JSON) in cloudData{
                            let titulo = subJson["titulo"].stringValue
                            let descripcion = subJson["descripcion"].stringValue
                            let latitud = subJson["latitud"].stringValue
                            let longitud = subJson["longitud"].stringValue
                            let telefono = subJson["telefono"].stringValue
                            let precio = subJson["precio"].stringValue
                            print("key ---> \(key) value ---> \(subJson["latitud"])")
                            
                            /*var rdescripcion = descripcion
                             if(descripcion.characters.count >= 70){
                             rdescripcion = descripcion.substring(to:descripcion.index(descripcion.startIndex, offsetBy: 70)) + "..."
                             }*/
                            
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: Double(latitud)!, longitude: Double(longitud)!)
                            marker.title = titulo
                            marker.snippet = descripcion + "\nPrecio " + precio + "Bs." + "\nTelefono(toque p/llamar): " + telefono
                            marker.map = self.mapView
                            //self.mapView.selectedMarker = marker
                            
                        }
                        self.activityInticator.stopAnimating()
                    }
                    else{
                        self.activityInticator.stopAnimating()
                    }
                case .failure(let error):
                    print("error\(error)")
                    self.activityInticator.stopAnimating()
                    self.showMessaje(mensaje: "Error al intentar realizar la operacion con el servidor")
                }
            })
        
    }
    
    //funcion para mostrar mensaje
    func showMessaje(mensaje:String){
        let ventana = UIAlertController(title:"INFORMACION",message:mensaje,preferredStyle:.alert)
        let botonOk = UIAlertAction(title:"OK",style:.default,handler:nil)
        ventana.addAction(botonOk)
        self.present(ventana,animated:true,completion:nil)
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        print("TAB DESDE LISTA DE MAPA AVISOS>>\(tabBarIndex)")
        if tabBarIndex == 1 {
            loadMaps(buscar:"")
        }
    }
    
    //para buscar
    //para la busqueda de datos
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText:String){
        print("para la busqueda en mapa==>\(searchBar)")
        if(searchText.characters.count >= 5 || searchText.characters.count == 0){
            self.loadMaps(buscar:searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("click en boton\(String(describing: searchBar.text))")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let contenido = marker.snippet!
        let needle:Character = ":"
        if let idx = contenido.characters.index(of:needle){
            let pos:Int = contenido.characters.distance(from: contenido.endIndex, to: idx) + 2
            let telefono = contenido.substring(from:contenido.index(contenido.endIndex, offsetBy: pos))
            print("Pos++>\(telefono)")
            call(telefono: telefono)
        }
        
    }
    
    //funcion para llamar
    func call(telefono:String){
        let alertController = UIAlertController(title: "REALIZAR LLAMADA?", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "LLAMAR", style: .default, handler: {
            alert -> Void in
            
            print("LLAMANDO")
            let url = URL(string: "tel://\(telefono)")!
            UIApplication.shared.open(url)
        })
        
        let cancelAction = UIAlertAction(title: "CANCELAR", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

