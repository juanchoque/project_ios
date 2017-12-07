//
//  PublicarMiAvisoController.swift
//  InmoviliariaVirtual
//
//  Created by Juan on 12/2/17.
//  Copyright © 2017 Juan. All rights reserved.
//

import UIKit
import GoogleMaps

class PublicarMiAvisoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,GMSMapViewDelegate{
    
    var aviso:Aviso?
    
    @IBOutlet weak var mapUbicacion: GMSMapView!
    @IBOutlet weak var txtPrecio: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
    @IBOutlet weak var txtDireccion: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var imgImagen: UIImageView!
    
    //variable auxiliares
    var latitud:Double = -17.372750
    var longitud:Double = -66.144996

    override func viewDidLoad() {
        super.viewDidLoad()

        mapUbicacion?.delegate = self
        loadAviso()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func loadAviso(){
        //-17.372750, -66.144996
        var latitud = -17.372750
        var longitud = -66.144996
        
        if let aviso = aviso {
            self.txtDescripcion.text = aviso.descripcion
            self.txtPrecio.text = String(aviso.precio!)
            self.txtTelefono.text = aviso.telefono
            self.txtDireccion.text = aviso.direccion
            self.imgImagen.image = aviso.imagen
            latitud = aviso.latitud!
            longitud = aviso.longitud!
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude: longitud, zoom: 16)
        self.mapUbicacion.camera = camera
        
        let initialLocation = CLLocationCoordinate2DMake(latitud, longitud)
        let marker = GMSMarker(position: initialLocation)
        marker.title = "Toque en Mapa para Ubicacion"
        marker.map = mapUbicacion
        self.mapUbicacion.selectedMarker = marker
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var descripcion:String = txtDescripcion.text!
        let sprecio = txtPrecio.text!
        let telefono = txtTelefono.text!
        
        if(descripcion.isEmpty || sprecio.isEmpty || telefono.isEmpty){
            showMessaje(mensaje: "Faltan Datos Necesarios para esta Operacion")
            return false;
        }
        else{
            
            if let precio = Float(sprecio){
                
            }
            else{
                showMessaje(mensaje: "El Precio es Invalido")
                return false
            }
            
            if let telefono = Int(telefono){
                
            }
            else{
                showMessaje(mensaje: "El Telefono es Invalido")
                return false
            }
            
            var titulo = descripcion
            if(descripcion.characters.count >= 20){
                titulo = descripcion.substring(to:descripcion.index(descripcion.startIndex, offsetBy: 20))
            }
            let precio = Float(sprecio)!
            var id = 0
            
            
            if(self.aviso != nil){
                id = (self.aviso?.id)!
            }
            
            self.aviso = Aviso(id:id,titulo:titulo,descripcion:descripcion,precio:precio,telefono:telefono,latitud:self.latitud,longitud: self.longitud,estado:"1",publicado:1, imagen:UIImage(named:"logo_aviso_1"))
            
            return true;
        }
        return false;
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        var descripcion:String = txtDescripcion.text!
        var titulo = descripcion
        if(descripcion.characters.count >= 20){
            titulo = descripcion.substring(to:descripcion.index(descripcion.startIndex, offsetBy: 20))
        }
        let precio = Float(txtPrecio.text!)!
        var id = 0
        let telefono = txtTelefono.text!
        let direccion = txtDireccion.text!
        let imagen = imgImagen.image!
        let fecha = Date()
        
        if(self.aviso != nil){
            id = (self.aviso?.id)!
        }
        
        self.aviso = Aviso(id:id,titulo:titulo,descripcion:descripcion,precio:precio,telefono:telefono,latitud:self.latitud,longitud: self.longitud,estado:"1",publicado:1, imagen:imagen,direccion:direccion, fecha:String(describing: fecha))
        
    }
    
    //funcion para validar los datos del formulario
    func showMessaje(mensaje:String){
        let ventana = UIAlertController(title:"INFORMACION",message:mensaje,preferredStyle:.alert)
        let botonOk = UIAlertAction(title:"OK",style:.default,handler:nil)
        ventana.addAction(botonOk)
        self.present(ventana,animated:true,completion:nil)
        
    }
    
    
    @IBAction func clickCancel(_ sender: Any) {
        print("click!!dismiss")
        
        dismiss(animated: true, completion: nil)
        
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

    //manejo del mapa
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
        self.latitud = coordinate.latitude
        self.longitud = coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16)
        self.mapUbicacion.camera = camera
        
        mapUbicacion.clear() // clearing Pin before adding new
        let marker = GMSMarker(position: coordinate)
        //marker.title = "aqui"
        //marker.snippet = "esta"
        marker.map = mapUbicacion
    }
    
    //manejo de fotos
    @IBAction func selectedImage(_ sender: UITapGestureRecognizer) {
        print("entra aqui")
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imgImagen.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    

}
