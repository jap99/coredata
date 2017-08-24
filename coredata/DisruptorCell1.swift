//
//  DisruptorCell1.swift
//  coredata
//
//  Created by Javid Poornasir on 8/22/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit

class DisruptorCell1: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityPriceLbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



class DisruptorCell2: UITableViewCell {
    
    @IBOutlet weak var dropdownMenuBtn: UIButton!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func dropdownMenuBtnPressed(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}




class DisruptorCell3: UITableViewCell {
    
    @IBOutlet weak var txtView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class DropDownTitle: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}

class DropDownValue: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
}

class DisruptorDetailsCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
}











