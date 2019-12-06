//
//  CustomTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Anna Koulaeva on 28.11.2019.
//  Copyright © 2019 Anna Koulaeva. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var paramName: UILabel!
    @IBOutlet weak var paramIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
