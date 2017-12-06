//
//  MisAvisosRowController.swift
//  InmoviliariaVirtual
//
//  Created by Juan on 11/25/17.
//  Copyright © 2017 Juan. All rights reserved.
//

import UIKit

class MisAvisosRowController: UITableViewCell {

    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtDescripcion: UILabel!
    @IBOutlet weak var imgImagen: UIImageView!
    @IBOutlet weak var txtFecha: UILabel!
    
    override func layoutSubviews() {
        imgImagen.layer.cornerRadius = imgImagen.bounds.height / 2
        imgImagen.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
