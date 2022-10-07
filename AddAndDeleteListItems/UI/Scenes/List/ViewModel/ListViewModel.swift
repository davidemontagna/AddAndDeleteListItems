//
//  ListViewModel.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 04/10/22.
//

import Foundation

protocol ListViewModelDelegate {
    func onSuccess(_ useCase: ListViewModelDelegateUseCases)
}

class ListViewModel: NSObject {
    
    // MARK: - Delegate
    
    var delegate: ListViewModelDelegate?
        
    // MARK: - Properties
    
    var selectedItemId: Int?
    var newItem = ""
    var indexToRemove: Int? 
    var arrayTxt: [String] = ["Testo 1", "Prova 2", "Testo 2", "Row 1", "Row 2", "Row 3", "Row 4", "Row 5",
                              "Testo 3", "Prova 3", "Testo 4", "Row 6", "Row 7", "Row 8", "Row 9", "Row 10"]
    
    var userCanSave: Bool {
        return !newItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var inputIsCorrect: Bool {
        if newItem.first == "." {
            return false
        }
        return true
    }
    
    var showEmptyView: Bool {
        if arrayTxt.count == 0 {
            return arrayTxt.isEmpty
        }
        return false
    }
    
    // MARK: - Init
    
    init(delegate: ListViewModelDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    
    func addItem() {
        self.arrayTxt.append(newItem)
        self.delegate?.onSuccess(.saveItem)
    }
    
    func removeItem() {
        if let index = indexToRemove {
            self.arrayTxt.remove(at: index)
        }
        self.delegate?.onSuccess(.deleteItem)
    }
}
