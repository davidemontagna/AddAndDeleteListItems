//
//  UITableView+Extensions.swift
//  AddAndDeleteListItems
//
//  Created by Davide Montagna on 04/10/22.
//

import Foundation
import UIKit

extension UITableView {
    private func reuseIndentifier<T>(for type: T.Type) -> String {
        return String(describing: type)
    }
    
    public func register<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: reuseIndentifier(for: cell), bundle: nil), forCellReuseIdentifier: reuseIndentifier(for: cell))
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIndentifier(for: type), for: indexPath) as? T else {
            fatalError("Failed to dequeue cell.")
        }
        return cell
    }
}
