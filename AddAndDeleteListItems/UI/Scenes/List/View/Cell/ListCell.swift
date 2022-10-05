//
//  ListCell.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 04/10/22.
//

import UIKit

class ListCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet var itemLabel: UILabel!

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Methods
    
    func config(data: String){
        self.itemLabel.text = data
    }
}
