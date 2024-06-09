//
//  OptionTableViewController.swift
//  YGGG
//
//  Created by Song Kim on 6/9/24.
//

import UIKit

// MARK: main

class OptionTableViewController: UITableViewController {
    let viewModel: ModalViewModel
    weak var delegate: ModalDelegate?
    
    init(viewModel: ModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - tableviews

extension OptionTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.options[indexPath.row]
        cell.contentConfiguration = content
        
        cell.accessoryType = viewModel.selectedIndex == indexPath.row ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath.row
        tableView.reloadData()
        delegate?.onDismissReload(selection: viewModel.selectedOption)
        self.dismiss(animated: true)
    }
}
