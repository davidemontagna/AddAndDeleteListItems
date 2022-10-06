//
//  ListAdapter.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 04/10/22.
//

import Foundation
import UIKit

protocol ListAdapterDelegate {
    func deleteItem(indexPath: IndexPath)
    func didSelectItem(id: Int)
}

class ListAdapter: NSObject {
    
    // MARK: - Delegate
    
    var delegate: ListAdapterDelegate?
    
    // MARK: - Properties
    
    var arrayTxt: [String] = []
    
    // MARK: - Init
    
    init(delegate: ListAdapterDelegate) {
        super.init()
        self.delegate = delegate
    }
}

// MARK: - Extensions

extension ListAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTxt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListCell = tableView.dequeueReusableCell(for: ListCell.self, for: indexPath)
        cell.config(data: arrayTxt[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.makeFadeAnimation(duration: 0.2, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectItem(id: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (deleteAction, index, handled)  in
            self.delegate?.deleteItem(indexPath: indexPath)
            handled(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.arrayTxt.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}

extension ListAdapter: UITableViewDelegate {
    
}

