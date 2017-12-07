//
//  MisAvisosController.swift
//  InmoviliariaVirtual
//
//  Created by Juan on 11/22/17.
//  Copyright © 2017 Juan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MisAvisosController: UITableViewController, UITabBarControllerDelegate{
    
    var avisos = [Aviso]()
    let urlListAvisos:String = "http://www.labolsita.esy.es/inmoviliariavirtual/api/controllers/aviso/listam.php"
    let urlInsertAvisos:String = "http://www.labolsita.esy.es/inmoviliariavirtual/api/controllers/aviso/insertar.php"
    let urlEditAvisos:String = "http://www.labolsita.esy.es/inmoviliariavirtual/api/controllers/aviso/editar.php"
    let urlDeleteAvisos:String = "http://www.labolsita.esy.es/inmoviliariavirtual/api/controllers/aviso/eliminar.php"
    let urlObtenerCuenta:String = "http://www.labolsita.esy.es/inmoviliariavirtual/api/controllers/cuenta/obtener.php"
    let urlInsertarCuenta:String = "http://www.labolsita.esy.es/inmoviliariavirtual/api/controllers/cuenta/insertar.php"
    
    var idcuenta:String = "1" //por defecto
    
    var activityInticator:UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        //self.imagePickerController.delegate = self
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        activityInticator.center = self.view.center
        activityInticator.hidesWhenStopped = true
        activityInticator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityInticator)
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.verifyAcount()
        //self.loadAvisos()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //la seccion debe ser uno por (grupos en tabla)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return avisos.count //cantidad de datos
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellmavisos", for: indexPath) as! MisAvisosRowController
        
        // Configure the cell...
        // mycell es el identificador de la celda itera por la cantidad de filas definidas
        let aviso = avisos[indexPath.row]
        
        //cell.imageAviso.image = aviso.imagen
        cell.txtTitulo.text = aviso.titulo // aviso.titulo
        cell.txtDescripcion.text = aviso.descripcion // aviso.descripcion
        cell.imgImagen.image = aviso.imagen
        cell.txtFecha.text = "Publicado: \(aviso.fecha!)"
        
        //cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 120))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        return cell
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        print("TAB DESDE LISTA DE MIS AVISOS>>\(tabBarIndex)")
        if tabBarIndex == 2 {
            self.verifyAcount()
        }
    }
    
    //verificar datos de la cuentas
    func verifyAcount(){
        let ncelular = "79245655" //esta numero debe recuperarse del sim actual del celular
        if(!ncelular.isEmpty){
            //recuperar datos del servidor
            activityInticator.startAnimating()
            
            let parameters:Parameters = [
                "celular":ncelular
            ]
            
            Alamofire.request(urlObtenerCuenta, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil)
                .responseJSON(completionHandler:{
                    (resultado) in
                    switch(resultado.result){
                    case .success(let value):
                        let response = value as! NSDictionary
                        
                        //example if there is an id
                        var ruserId = ""
                        if let userId = response.object(forKey: "id"){
                            ruserId = userId as! String
                            self.idcuenta = ruserId
                            self.activityInticator.stopAnimating()
                            
                            //activando botones
                            self.navigationItem.leftBarButtonItem?.isEnabled = true
                            self.navigationItem.rightBarButtonItem?.isEnabled = true
                            
                            self.loadAvisos()
                        }
                        else{
                            self.activityInticator.stopAnimating()
                            self.registerAcount()
                        }
                    case .failure(let error):
                        print("error>>\(error)")
                        self.activityInticator.stopAnimating()
                        self.showMessaje(mensaje: "ERROR AL RECUPERAR DATOS DEL SERVIDOR")
                    }
                })
        }
    }
    
    //funcion para registrar datos para mostrar
    func loadAvisos(){
        activityInticator.startAnimating()
        
        self.avisos.removeAll()
        self.tableView.reloadData()
        
        let parameters:Parameters = [
            "descripcion": "",
            "cuenta":self.idcuenta
        ]
        
        
        Alamofire.request(urlListAvisos, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil)
            .responseJSON(completionHandler:{
                (resultado) in
                switch(resultado.result){
                case .success(let value):
                    print("correcto registro de cuneta>>\(value)")
                    if let data = resultado.data, let _ = String(data: data, encoding: .utf8){
                        let cloudData = try! JSON(data: data)
                        
                        self.avisos.removeAll()
                        self.tableView.reloadData()
                        
                        for (key,subJson):(String, JSON) in cloudData{
                            let id = subJson["id"].stringValue
                            let titulo = subJson["titulo"].stringValue
                            let descripcion = subJson["descripcion"].stringValue
                            let latitud = subJson["latitud"].stringValue
                            let longitud = subJson["longitud"].stringValue
                            let telefono = subJson["telefono"].stringValue
                            let publicado = subJson["publicado"].stringValue
                            let precio = subJson["precio"].stringValue
                            let estado = subJson["estado"].stringValue
                            let imagen:String = subJson["imagen"].stringValue
                            let direccion:String = subJson["direccion"].stringValue
                            let fecPublicacion:String = subJson["fec_publicacion"].stringValue
                            
                            print("key ---> \(key) value ---> \(imagen)")
                            
                            let rimagen: UIImage
                            if let photo:NSData = NSData(base64Encoded:imagen, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!{
                                rimagen = UIImage(data:photo as Data)!
                            }else{
                                rimagen = UIImage(named:"logo_aviso_1")!
                            }
                            
                            let aviso:Aviso = Aviso(id:Int(id)!,titulo:titulo,descripcion:descripcion,precio:Float(precio)!,telefono:telefono,latitud:Double(latitud)!,longitud: Double(longitud)!,estado:estado,publicado:Int(publicado)!,imagen:rimagen,direccion:direccion,fecha:fecPublicacion)
                            self.avisos.append(aviso)
                            
                            let newIndexPath = IndexPath(row: (self.avisos.count - 1), section: 0)
                            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
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
    
    @IBAction func unwindToMisAvisosList(send: UIStoryboardSegue){
        print("llegan aqui los datos");
        if let publicarViewController = send.source as? PublicarMiAvisoController, let aviso = publicarViewController.aviso{
            activityInticator.startAnimating()
            
            print("RETORNO>>\(aviso.descripcion!)")
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //para editar
                let auxImagen = UIImagePNGRepresentation(aviso.imagen!) as! NSData
                let base64Data = auxImagen.base64EncodedString(options: .lineLength76Characters)
                print("++++>>" + base64Data)
                let parameters:Parameters = [
                    "id":aviso.id,
                    "titulo": aviso.titulo!,
                    "descripcion": aviso.descripcion!,
                    "precio":aviso.precio!,
                    "transaccionaviso":"1",
                    "cuenta":self.idcuenta,
                    "subcategoria":"6",
                    "tipoaviso":"1",
                    "latitud":aviso.latitud,
                    "longitud":aviso.longitud,
                    "telefono":aviso.telefono,
                    "direccion":aviso.descripcion!,
                    "imagen":base64Data
                ]
                
                
                Alamofire.request(urlEditAvisos, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil)
                    .responseJSON(completionHandler:{
                        (resultado) in
                        switch(resultado.result){
                        case .success(let value):
                            print("correcto>>\(value)")
                            
                            self.avisos[selectedIndexPath.row] = aviso
                            self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                            self.tableView.reloadData()
                            
                            self.activityInticator.stopAnimating()
                            self.showMessaje(mensaje: "Datos actualizados correctamente")
                        case .failure(let error):
                            print("error>>\(error)")
                            
                            self.activityInticator.stopAnimating()
                            self.showMessaje(mensaje: "Error al intentar realizar la operacion con el servidor")
                        }
                    })
            }
            else{
                //para publicar como nuevo
                let auxImagen = UIImagePNGRepresentation(aviso.imagen!)! as NSData
                let base64Data = auxImagen.base64EncodedString(options: .lineLength76Characters)
                print("++++>>" + base64Data)
                let parameters:Parameters = [
                    "titulo": aviso.titulo!,
                    "descripcion": aviso.descripcion!,
                    "precio":aviso.precio!,
                    "transaccionaviso":"1",
                    "cuenta":self.idcuenta,
                    "subcategoria":"6",
                    "tipoaviso":"1",
                    "latitud":aviso.latitud,
                    "longitud":aviso.longitud,
                    "direccion":aviso.descripcion!,
                    "telefono":aviso.telefono,
                    "imagen":base64Data
                    
                ]
                
                
                Alamofire.request(urlInsertAvisos, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil)
                    .responseJSON(completionHandler:{
                        (resultado) in
                        switch(resultado.result){
                        case .success(let value):
                            print("correcto>>\(value)")
                            
                            //insertando en la lista
                            let newIndexPath = IndexPath(row: self.avisos.count, section: 0)
                            self.avisos.append(aviso)
                            
                            //tableView.reloadData()
                            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                            
                            self.activityInticator.stopAnimating()
                            self.showMessaje(mensaje: "Datos actualizados correctamente")
                        case .failure(let error):
                            print("error>>\(error)")
                            
                            self.activityInticator.stopAnimating()
                            self.showMessaje(mensaje: "Error al intentar realizar la operacion con el servidor")
                        }
                    })
            }
            
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("PARA ELIMINAR ITEM")
            
            let aviso = avisos[indexPath.row]
            
            let parameters:Parameters = [
                "id": aviso.id!
            ]
            
            activityInticator.startAnimating()
            Alamofire.request(urlDeleteAvisos, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil)
                .responseJSON(completionHandler:{
                    (resultado) in
                    switch(resultado.result){
                    case .success(let value):
                        print("correcto eliminado>>\(value)")
                        
                        // Delete the row from the data source
                        self.avisos.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.activityInticator.stopAnimating()
                        
                        self.showMessaje(mensaje: "Datos eliminados correctamente")
                    case .failure(let error):
                        print("error eliminado>>\(error)")
                        self.activityInticator.stopAnimating()
                        self.showMessaje(mensaje: "Error al intentar realizar la operacion con el servidor")
                    }
                })
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //funcion para mostrar mensaje
    func showMessaje(mensaje:String){
        let ventana = UIAlertController(title:"INFORMACION",message:mensaje,preferredStyle:.alert)
        let botonOk = UIAlertAction(title:"OK",style:.default,handler:nil)
        ventana.addAction(botonOk)
        self.present(ventana,animated:true,completion:nil)
        
    }
    
    //registrar datos de la nueva cuenta
    func registerAcount(){
        let alertController = UIAlertController(title: "Crear Cuenta", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Crear", style: .default, handler: {
            alert -> Void in
            
            let nombreTextField = alertController.textFields![0] as UITextField
            let apellidoTextField = alertController.textFields![1] as UITextField
            let telefonoTextField = alertController.textFields![2] as UITextField
            
            let nombre = nombreTextField.text!
            let apellido = apellidoTextField.text!
            let telefono = telefonoTextField.text!
            
            if(!nombre.isEmpty && !apellido.isEmpty && !telefono.isEmpty){
                self.insertAcount(nombre:nombre,apellido:apellido,telefono:telefono)
            }
            else{
                self.showMessaje(mensaje: "FALTAN DATOS PARA REGISTRAR CUENTA")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Ingresa tu Nombre"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Ingresa tu Apellido"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Ingrese su Telefono"
            textField.text = "79245655"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    //funcion para registrar datos en la nube
    func insertAcount(nombre:String, apellido:String, telefono:String){
        //registro de de cuenta por primera vez
        print("para el registro en la cuenta")
        activityInticator.startAnimating()
        let parameters:Parameters = [
            "nombres": nombre,
            "ci":"0",
            "apaterno":apellido,
            "celular":telefono,
            "tipocuenta":"10",
            "ciudad":"1"
        ]
        
        Alamofire.request(urlInsertarCuenta, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:nil)
            .responseJSON(completionHandler:{
                (resultado) in
                switch(resultado.result){
                case .success(let value):
                    print("correcto registro de cuneta>>\(value)")
                    self.activityInticator.stopAnimating()
                    
                    //cargar datos id cuenta
                    let response = value as! NSDictionary
                    
                    //example if there is an id
                    var ruserId = ""
                    if let userId = response.object(forKey: "id"){
                        print("==>\(userId)")
                        ruserId = userId as! String
                        self.idcuenta = ruserId
                        self.activityInticator.stopAnimating()
                        
                        self.showMessaje(mensaje: "CUENTA REGISTRADA CORRECTAMENTE")
                        
                        //activando botones
                        self.navigationItem.leftBarButtonItem?.isEnabled = true
                        self.navigationItem.rightBarButtonItem?.isEnabled = true
                        
                        self.loadAvisos()
                    }
                    else{
                        self.activityInticator.stopAnimating()
                        self.showMessaje(mensaje: "Error al intentar realizar la operacion con el servidor")
                    }
                case .failure(let error):
                    print("error registro de cuenta>>\(error)")
                    self.activityInticator.stopAnimating()
                    self.showMessaje(mensaje: "Error al intentar realizar la operacion con el servidor")
                }
            })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "publicaraviso":
            print("Publicar")
            //os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "modificaraviso":
            print("Modificar")
            
            guard let publicarMiAvisoController = segue.destination as? PublicarMiAvisoController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedAvisoCell = sender as? MisAvisosRowController else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedAvisoCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedAviso = avisos[indexPath.row]
            publicarMiAvisoController.aviso = selectedAviso
            
        default:
            print("Default")
            //fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    

    @IBAction func refreshAvisos(_ sender: UIBarButtonItem) {
        self.loadAvisos()
    }
}
