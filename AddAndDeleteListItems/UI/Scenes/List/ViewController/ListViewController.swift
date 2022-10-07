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
    @IBOutlet var saveButton: MDCButton!
    @IBOutlet var inputTextField: MDCOutlinedTextField!
    
    // MARK: - Properties
    
    let notification = UINotificationFeedbackGenerator()
    var transition = Transition()
    var fadePush = FadePushAnimator()
    var fadePop = FadePopAnimator()
    let containerScheme = MDCContainerScheme()
    
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
        textFieldSetup(inputTextField, with: "Inserisci un testo")
        buttonSetup(saveButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        adapter.arrayTxt = viewModel.arrayTxt
        showEmptyView()
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if !viewModel.inputIsCorrect {
            errorTextFieldSetup(inputTextField, with: "Inserisci un testo", and: "Il testo non può iniziare con un punto!")
        } else {
            viewModel.addItem()
        }
    }
    
    @IBAction func onEditButtonTapped(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @IBAction func onInputTextFieldEditingChanged(_ sender: Any) {
        viewModel.newItem = inputTextField.text ?? ""
        handleSaveButton()
    }
    
    // MARK: - Private methods
    
    private func buttonSetup(_ button: MDCButton) {
        button.applyOutlinedTheme(withScheme: containerScheme)
        button.minimumSize = CGSize(width: 64, height: 48)
        button.setBackgroundColor(.gray, for: .disabled)
        button.setBackgroundColor(.systemBlue, for: .normal)
        button.setElevation(ShadowElevation(rawValue: 4), for: .normal)
        button.setElevation(ShadowElevation(rawValue: 6), for: .highlighted)
    }
    
    private func textFieldSetup(_ textField: MDCOutlinedTextField, with text: String) {
        textField.setOutlineColor(.lightGray, for: .normal)
        textField.setOutlineColor(.gray, for: .editing)
        textField.label.text = text
    }
    
    private func errorTextFieldSetup(_ textField: MDCOutlinedTextField, with text: String, and errorMessage: String) {
        textField.setOutlineColor(.red, for: .normal)
        textField.setOutlineColor(.red, for: .editing)
        textField.label.text = text
        textField.leadingAssistiveLabel.text = errorMessage
        textField.setLeadingAssistiveLabelColor(.red, for: .normal)
        textField.setLeadingAssistiveLabelColor(.red, for: .editing)
    }
    
    private func handleSaveButton() {
        saveButton.isEnabled = viewModel.userCanSave
    }
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    private func showEmptyView() {
        var backgroundView: UIView? = nil
        if viewModel.showEmptyView {
            if let emptyView: EmptyView = .fromNib() {
                emptyView.messageText = "Non sono presenti elementi"
                backgroundView = emptyView
            }
        }
        tableView.backgroundView = backgroundView
    }
}

// MARK: - Extensions

extension ListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        return fadePush
    }
    
    func animationController(forDismissed dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        return fadePop
    }
}

extension ListViewController: ListAdapterDelegate {
    func didSelectItem(id: Int) {
        viewModel.selectedItemId = id
        self.performSegue(withIdentifier: "ShowDetailListItem", sender: self)
    }
    
    func deleteItem(indexPath: IndexPath) {
        let alertController = MDCAlertController(title: "Attenzione!", message: "Sei sicuro di voler eliminare l'elemento dalla lista?")
        alertController.applyTheme(withScheme: containerScheme)
        alertController.addAction(MDCAlertAction(title: "Elimina",
                                                 emphasis: .high,
                                                 handler: { (action: MDCAlertAction!) in
            self.viewModel.indexToRemove = indexPath.row
            self.viewModel.removeItem()
            self.showEmptyView()
        }))
        
        alertController.addAction(MDCAlertAction(title: "Cancella",
                                                 emphasis: .medium,
                                                 handler: { (action: MDCAlertAction!) in
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ListViewController: ListViewModelDelegate{
    
    func onSuccess(_ useCase: ListViewModelDelegateUseCases) {
        
        switch useCase {
        case .deleteItem:
            adapter.arrayTxt = viewModel.arrayTxt
            if let index = viewModel.indexToRemove {
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
            }
            notification.notificationOccurred(.success)
            alert(title: "Elemento eliminato!", message: "L'elemento è stato eliminato dalla lista.")
            
        case .saveItem:
            adapter.arrayTxt = viewModel.arrayTxt
            
            let index = IndexPath.init(row: adapter.arrayTxt.count - 1, section: 0)
            self.tableView.insertRows(at: [index], with: .right)
            
            let indexPath = NSIndexPath(item: index.row, section: 0)
            tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
            
            textFieldSetup(inputTextField, with: "Inserisci un testo")
            self.inputTextField.leadingAssistiveLabel.text = ""
            self.inputTextField.text = ""
            self.inputTextField.endEditing(true)
            
            saveButton.isEnabled = false
            self.showEmptyView()
            alert(title: "Elemento aggiunto!", message: "Un nuovo elemento è stato aggiunto alla lista.")
        }
    }
}

