//
//  ListViewModel.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 04/10/22.
//

import Foundation

protocol ListViewModelDelegate {
    
}

class ListViewModel: NSObject {
    
    // MARK: - Delegate
    
    var delegate: ListViewModelDelegate?
        
    // MARK: - Properties
    
    var selectedItemId: Int?
    var newItem: String?
    var indexToRemove: Int? 
    var arrayTxt: [String] = ["Testo 1", "Prova 2", "Testo 2", "Row 1", "Row 2", "Row 3", "Row 4", "Row 5"]
    
    // MARK: - Init
    
    init(delegate: ListViewModelDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    
    func addItem() {
        self.arrayTxt.append(newItem ?? "")
    }
    
    func removeItem() {
        if let index = indexToRemove {
            self.arrayTxt.remove(at: index)
        }
    }
}
