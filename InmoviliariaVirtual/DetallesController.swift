//
//  DetallesController.swift
//  InmoviliariaVirtual
//
//  Created by Juan on 11/22/17.
//  Copyright © 2017 Juan. All rights reserved.
//

import UIKit
import GoogleMaps

class DetallesController: UIViewController {

    @IBOutlet weak var imgImagen: UIImageView!
    @IBOutlet weak var mapUbicacion: GMSMapView!
    @IBOutlet weak var txtTelefono: UILabel!
    @IBOutlet weak var txtPrecio: UILabel!
    @IBOutlet weak var txtDetalle: UILabel!
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtDireccion: UILabel!
    
    var aviso:Aviso?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAviso()
    }
    
    func loadAviso(){
        
        if let aviso = aviso {
            self.imgImagen.image = aviso.imagen
            //self.mapUbicacion.text = aviso.
            self.txtTelefono.text = aviso.telefono
            self.txtPrecio.text = String(aviso.precio!)
            self.txtDetalle.text = aviso.descripcion
            self.txtTitulo.text = aviso.titulo
            self.txtDireccion.text = aviso.direccion
            self.txtTelefono.text = aviso.telefono
            
            let camera = GMSCameraPosition.camera(withLatitude: aviso.latitud!, longitude: aviso.longitud!, zoom: 16)
            self.mapUbicacion.camera = camera
            
            let initialLocation = CLLocationCoordinate2DMake(aviso.latitud!, aviso.longitud!)
            let marker = GMSMarker(position: initialLocation)
            marker.title = aviso.direccion
            marker.snippet = aviso.titulo
            marker.map = mapUbicacion
            self.mapUbicacion.selectedMarker = marker
            
            print("LLEGA AL FINAL")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func done(_ sender: Any) {
        print("click!!dismiss")
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    @IBAction func clickCall(_ sender: Any) {
        if let aviso = aviso{
            let alertController = UIAlertController(title: "REALIZAR LLAMADA?", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "LLAMAR", style: .default, handler: {
                alert -> Void in
                
                print("LLAMANDO")
                let url = URL(string: "tel://\(aviso.telefono!)")!
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


}
