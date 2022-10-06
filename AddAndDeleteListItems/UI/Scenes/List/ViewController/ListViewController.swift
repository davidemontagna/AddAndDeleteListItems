//
//  ListViewController.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 04/10/22.
//

import UIKit
import Foundation
import MaterialComponents

class ListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var inputTextField: UITextField!
    
    // MARK: - Properties
    
    let notification = UINotificationFeedbackGenerator()
    var transition = Transition()
    var fadePush = FadePushAnimator()
    var fadePop = FadePopAnimator()
    
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
        viewModel.newItem = inputTextField.text ?? ""
        viewModel.addItem()
    }
    
    @IBAction func onEditButtonTapped(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    // MARK: - Private methods
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
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
        return nil
    }
}

extension ListViewController: ListAdapterDelegate {
    func didSelectItem(id: Int) {
        viewModel.selectedItemId = id
        self.performSegue(withIdentifier: "ShowDetailListItem", sender: self)
    }
    
    func deleteItem(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Attenzione!",
                                      message: "Vuoi eliminare questo elemento dalla lista?",
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Elimina",
                                      style: .default,
                                      handler: { (action: UIAlertAction!) in
            self.viewModel.indexToRemove = indexPath.row
            self.viewModel.removeItem()
        }))

        alert.addAction(UIAlertAction(title: "Cancella",
                                      style: .cancel,
                                      handler: { (action: UIAlertAction!) in
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension ListViewController: ListViewModelDelegate{
    
    func onSuccess(_ useCase: ListViewModelDelegateUseCases) {
        
        switch useCase {
        case .deleteItem:
            adapter.arrayTxt = viewModel.arrayTxt
            if let index = viewModel.indexToRemove {
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
            }
            notification.notificationOccurred(.success)
            alert(title: "Elemento eliminato!", message: "L'elemento è stato eliminato dalla lista.")
            
        case .saveItem:
            adapter.arrayTxt = viewModel.arrayTxt
            
            let index = IndexPath.init(row: adapter.arrayTxt.count - 1, section: 0)
            self.tableView.insertRows(at: [index], with: .right)
            
            let indexPath = NSIndexPath(item: index.row, section: 0)
            tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
            
            self.inputTextField.text = ""
            self.inputTextField.endEditing(true)
            alert(title: "Elemento aggiunto!", message: "Un nuovo elemento è stato aggiunto alla lista.")
        }
    }
}

