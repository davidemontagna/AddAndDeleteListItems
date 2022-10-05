//
//  ListViewController.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 04/10/22.
//

import UIKit
import Foundation

class ListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var inputTextField: UITextField!
    
    // MARK: - Properties
    
    var transition = Transition()
    
    // MARK: - ViewModel
    
    lazy var viewModel = ListViewModel(delegate: self)
    
    // MARK: - Adapter
    
    lazy var adapter = ListAdapter(delegate: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell: ListCell.self)
        tableView.dataSource = adapter
        tableView.delegate = adapter
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        adapter.arrayTxt = viewModel.arrayTxt
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailListItem" {
            if let listDetailViewController = segue.destination as? ListDetailViewController, let index = viewModel.selectedItemId {
                listDetailViewController.transitioningDelegate = self
                listDetailViewController.viewModel.item = viewModel.arrayTxt[index]
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButton(_ sender: Any) {
        guard let text = self.inputTextField.text else { return }
        viewModel.newItem = text
        viewModel.addItem()
        adapter.arrayTxt = viewModel.arrayTxt
        let index = IndexPath.init(row: adapter.arrayTxt.count - 1, section: 0)
        self.tableView.insertRows(at: [index], with: .right)
        self.inputTextField.text = ""
    }
    
    @IBAction func onEditButtonTapped(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
}

// MARK: - Extensions

extension ListViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
      return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

extension ListViewController: ListAdapterDelegate {
    func didSelectItem(id: Int) {
        viewModel.selectedItemId = id
        self.performSegue(withIdentifier: "ShowDetailListItem", sender: self)
    }
    
    func deleteItem(indexPath: IndexPath) {
        viewModel.indexToRemove = indexPath.row
        viewModel.removeItem()
        adapter.arrayTxt = viewModel.arrayTxt
        tableView.deleteRows(at: [indexPath], with: .right)
    }
}

extension ListViewController: ListViewModelDelegate{
}

