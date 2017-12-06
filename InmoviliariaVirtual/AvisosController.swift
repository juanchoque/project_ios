//
//  AvisosController.swift
//  InmoviliariaVirtual
//
//  Created by Juan on 11/22/17.
//  Copyright © 2017 Juan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AvisosController: UITableViewController, UITabBarControllerDelegate, UISearchBarDelegate,UISearchResultsUpdating{
    
    var avisos = [Aviso]()
    let urlListAvisos:String = "http://www.labolsita.esy.es/inmoviliariavirtual/api/controllers/aviso/lista.php"
    var activityInticator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        //cambio de colores de tab
        activityInticator.center = self.view.center
        activityInticator.hidesWhenStopped = true
        activityInticator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityInticator)
        
        self.loadAvisos(buscar: "")
        
    }
    //test
    
    @IBAction func searchClick(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    func updateSearchResults(for searchController: UISearchController) {
        print("esta esta est otra")
    }
    //fin test

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellaviso", for: indexPath) as! AvisosRowController
        
        // Configure the cell...
        // mycell es el identificador de la celda itera por la cantidad de filas definidas
        let aviso = avisos[indexPath.row]
        
        //cell.imageAviso.image = aviso.imagen
        cell.tituloAviso.text = aviso.titulo // aviso.titulo
        cell.descripcionAviso.text = aviso.descripcion // aviso.descripcion
        cell.imageAviso.image = aviso.imagen
        cell.fechaAviso.text = "Publicado: \(aviso.fecha!)"
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 120))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
            case "detalleaviso":
                guard let avisoDetallesController = segue.destination as? DetallesController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
             
                guard let selectedAvisoCell = sender as? AvisosRowController else {
                    fatalError("Unexpected sender: \(sender)")
                }
             
                guard let indexPath = tableView.indexPath(for: selectedAvisoCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
             
                let selectedAviso = avisos[indexPath.row]
             
                avisoDetallesController.aviso = selectedAviso
            default:
                break
            
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        print("TAB DESDE LISTA DE AVISOS>>\(tabBarIndex)")
        if tabBarIndex == 0 {
            print("RECARGANDO")
            loadAvisos(buscar: "")
        }
    }
    
    //funcion para registrar datos para mostrar
    func loadAvisos(buscar:String){
        //completion(0)
        activityInticator.startAnimating()
        
        self.avisos.removeAll()
        self.tableView.reloadData()
        
        let parameters:Parameters = [
            "descripcion": buscar
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

    @IBAction func refreshAvisos(_ sender: UIBarButtonItem) {
        self.loadAvisos(buscar: "")
    }
    @IBAction func searchAvisos(_ sender: UIBarButtonItem) {
        
    }
    
    //funcion para mostrar mensaje
    func showMessaje(mensaje:String){
        let ventana = UIAlertController(title:"INFORMACION",message:mensaje,preferredStyle:.alert)
        let botonOk = UIAlertAction(title:"OK",style:.default,handler:nil)
        ventana.addAction(botonOk)
        self.present(ventana,animated:true,completion:nil)
    
    }
    
    //para la busqueda de datos
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText:String){
        print("=>\(searchBar)")
        if(searchText.characters.count >= 5 || searchText.characters.count == 0){
            self.loadAvisos(buscar:searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("click en boton\(String(describing: searchBar.text))")
    }
}
