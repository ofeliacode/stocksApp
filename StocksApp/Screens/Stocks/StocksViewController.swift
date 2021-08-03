//
//  ViewController.swift
//  StocksApp
//
//  Created by Офелия on 25.06.2021.
//

import UIKit
import CoreData

class StocksViewController: UIViewController, UISearchBarDelegate {
    
    private var stocks: [Stock] = []
    private var timer: Timer!
    
    lazy private var tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let dataBase: DataBaseProtocol
    private let networkingService: NetworkingProtocol
    // MARK: - search
    
    private let searchBar = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.searchBar.text else { return false }
        return text.isEmpty
    }
    
    // MARK: - filter
    private var filteredStocks: [Stock]?
    
    lazy var myrefreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refresh
    }()
    
    private var isFiltering: Bool {
        searchBar.isActive && !searchBarIsEmpty
    }
    
    init(_ database: DataBaseProtocol, networkingService: NetworkingProtocol) {
        self.dataBase = database
        self.networkingService = networkingService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - refresh
    
    @objc func refresh(sender: UIRefreshControl){
        update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Stocks 📈"
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.placeholder = "Find company or ticker"
        searchBar.searchBar.tintColor = .black
        searchBar.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchBar.searchBar
        definesPresentationContext = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(update))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        configureTableView()
        loadDataFromJSON()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        loadDataFromJSON()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        timer.invalidate()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: StockTableViewCell.cellId)
        tableView.refreshControl = myrefreshControl
        tableView.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    // MARK: - загрузка данных из JSON
    func loadDataFromJSON() {
        networkingService.loadData { res in
            switch res {
            case .success(let res):
                DispatchQueue.main.async {
                    self.stocks = res
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            case .failure(let er):
                print(er)
            }
        }
        
    }
    
    // MARK: - action
    @objc func update() {
       // loadDataFromJSON()
    }

}

// MARK: - TableViewDataSource

extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredStocks!.count
        }
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.cellId, for: indexPath as IndexPath) as! StockTableViewCell
        
        var model: Stock
        
        // MARK: - 2) фильтрация
        if isFiltering {
            model = filteredStocks![indexPath.row]
        } else {
            model = stocks[indexPath.row]
        }
        
        // MARK: - если название акции существует в базе данных то мы оставляем ячейку как желтая звездочка на 1 экране
        if dataBase.filter(model.name) {
            model.isFavorite = true
        } else {
            model.isFavorite = false
        }
        
        // MARK: - 1) заполнение таблицы данными из модели на главном экране
        cell.configure(model, index: indexPath.row)
        
        // MARK: -  избранные
        cell.didFavoriteTapped = { [weak self] in
            
            // тут мы менем состояние кнопки при клике
            self?.stocks[indexPath.row].isFavorite = !(self?.stocks[indexPath.row].isFavorite ?? false)
            
            // тут мы получаем model
            guard let model = self?.stocks[indexPath.row] else { return }
            
            if self?.stocks[indexPath.row].isFavorite == true {
                self?.dataBase.create(model)
            } else {
                self?.dataBase.remove(model.name)
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = StockDetailViewController()
        destination.stock = stocks[indexPath.row]
        navigationController?.pushViewController(destination, animated: true)
    }
}

extension StocksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        filteredStocks = stocks.filter({ (stock: Stock) in
            return stock.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StockTableViewCell.cellHeight
    }
}
