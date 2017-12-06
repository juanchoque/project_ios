//
//  AvisosRowController.swift
//  InmoviliariaVirtual
//
//  Created by Juan on 11/22/17.
//  Copyright © 2017 Juan. All rights reserved.
//

import UIKit

class AvisosRowController: UITableViewCell {

    @IBOutlet weak var imageAviso: UIImageView!
    @IBOutlet weak var tituloAviso: UILabel!
    @IBOutlet weak var descripcionAviso: UILabel!
    @IBOutlet weak var fechaAviso: UILabel!
    
    override func layoutSubviews() {
        imageAviso.layer.cornerRadius = imageAviso.bounds.height / 2
        imageAviso.clipsToBounds = true
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
