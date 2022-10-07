//
//  EmptyView.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 07/10/22.
//

import UIKit

class EmptyView: UIView {
    
    // MARK: - Outlets

    @IBOutlet var emptyMessageLabel: UILabel!
    
    // MARK: - Properties
    
    var messageText: String? {
        didSet {
            emptyMessageLabel.text = messageText
        }
    }
}
