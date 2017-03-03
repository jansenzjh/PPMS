//
//  ProjectTableViewCell.swift
//  PPMS
//
//  Created by Jansen on 3/2/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import SwipeCellKit

class ProjectTableViewCell: SwipeTableViewCell
{

    @IBOutlet weak var lblProjName: UILabel!
    @IBOutlet weak var lblProjDateRange: UILabel!
    @IBOutlet weak var lblCustName: UILabel!
    @IBOutlet weak var lblProjDesc: UILabel!
    
    var projectGID: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
