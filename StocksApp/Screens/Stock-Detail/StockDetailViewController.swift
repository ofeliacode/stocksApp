//
//  StockDetailViewController.swift
//  StocksApp
//
//  Created by Офелия on 27.06.2021.
//

import UIKit
import Foundation


class StockDetailViewController: UIViewController {
    
    var stock: Stock?
    
    var tableView : UITableView = {
        let table = UITableView()
        table.register(StockDetailTableViewCell.self, forCellReuseIdentifier: StockDetailTableViewCell.detailCell)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = stock?.name
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
}

//MARK: - TableViewDataSource
extension StockDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockDetailTableViewCell.detailCell, for: indexPath as IndexPath) as! StockDetailTableViewCell
        cell.configure(stock!, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        headerView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "blurImg")!)
        imageView.frame = headerView.bounds
        headerView.addSubview(imageView)
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = headerView.bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        headerView.insertSubview(blurEffectView, at: 1)
        let urlStr = URL(string: "https://storage.googleapis.com/iex/api/logos/\(stock?.symbol ?? "").png")!
        let imageBg: UIImageView = UIImageView()
        imageBg.contentMode = .center
        imageBg.frame = CGRect(x: headerView.bounds.height + 30, y: headerView.bounds.height, width: 120, height: 120)
        headerView.center = imageBg.center
        imageBg.contentMode = .scaleAspectFit
        imageBg.loadImageWithURL(urlStr, completion: { image in
            imageBg.image = image
        })
        headerView.addSubview(imageBg)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
}

//MARK: - TableViewDelegate
extension StockDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StockDetailTableViewCell.cellHeight
    }
}

extension UIImageView {
    func loadImageWithURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let imageCache = NSCache<AnyObject, AnyObject>()
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage as! UIImage)
        } else {
           
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            
            let downloadTask = URLSession.shared.downloadTask(with: request, completionHandler: { [weak self] data, response, error in
                guard error == nil,
                      data != nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let `self` = self else {return}
                let testImage = NSData (contentsOf: data! as URL)
                guard let image = UIImage(data: testImage as! Data) else {return}
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            })
            downloadTask.resume()
        }}
}

