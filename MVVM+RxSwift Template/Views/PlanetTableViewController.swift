//
//  PlanetTableViewController.swift
//  TemplateProject
//
//  Created by Benoit PASQUIER on 12/01/2018.
//  Copyright © 2018 Benoit PASQUIER. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlanetTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Planets"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.backgroundEffect = UIBlurEffect.init(style: .regular)
        navBarAppearance.shadowColor = .none
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationController?.navigationBar.tintColor = .label
        
        self.bindViews()
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            // let cell = self?.tableView.cellForRow(at: indexPath) as? PlanetCell
            // let planet = cell?.planet
            
            // Action on a tap here
            
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindViews() {
        // bind data to tableview
        self.viewModel.output.planets.drive(
            self.tableView.rx.items(cellIdentifier: "PlanetCell",
                                    cellType: PlanetCell.self)) { (row, planet, cell) in
                                        
                                        cell.planet = planet
                                        
        }.disposed(by: disposeBag)
        
        self.viewModel.output.errorMessage.drive(onNext: { [weak self] errorMessage in
            guard let self = self else { return }
            self.showError(errorMessage)
        }).disposed(by: disposeBag)
        
        // Reloads viewModel with void event as it is the initial load
        self.viewModel.input.reload.accept(())
    }
    
    private func showError(_ errorMessage: String) {
        let controller = UIAlertController(title: "An error occured", message: errorMessage, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}
