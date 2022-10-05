//
//  ListDetailViewController.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 05/10/22.
//

import UIKit

class ListDetailViewController: UIViewController {
    
    @IBOutlet var detailTextLabel: UILabel!
    
    // MARK: - ViewModel
    
    lazy var viewModel = ListDetailViewModel()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        detailTextLabel.text = viewModel.item
    }
    
    // MARK: - Actions
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
