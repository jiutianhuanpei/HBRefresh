//
//  RootVC.swift
//  HBRefresh
//
//  Created by Bang on 2025/8/27.
//

import UIKit

class RootVC: UIViewController {
    var rowNum = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
//        table.contentInset = .init(top: 50, left: 0, bottom: 50, right: 0)
        
        let ar = [
            table.leftAnchor.constraint(equalTo: view.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.rightAnchor),
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(ar)
        
        table.hb.addHeader(HBNormalHeaderAnimator()) {
            print("下拉刷新")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                table.hb.header?.stop()
            }
        }
        table.hb.addFooter(HBNormalFooterAnimator()) {
            print("上拉加载")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                table.hb.endLoadMoreData()
            }
        }
        
    }
    
    //MARK: - getter
    lazy var table: UITableView = {
        let v = UITableView(frame: .zero, style: .plain)
        v.backgroundColor = .gray
        v.dataSource = self
        v.delegate = self
        v.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        return v
    }()
}


extension RootVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
    
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "刷新头"
        case 1, rowNum-1:
            cell.textLabel?.text = "刷新尾"
        case 2:
            cell.textLabel?.text = "添加"
        default:
            cell.textLabel?.text = "\(indexPath.section) -- \(indexPath.row)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        print("====  \(tableView.hb)")
        switch indexPath.row {
        case 0:
            tableView.hb.header?.start()
        case 1, rowNum-1:
            tableView.hb.footer?.start()
            let row = tableView.numberOfRows(inSection: 0)
            tableView.scrollToRow(at: .init(row: row-1, section: 0), at: .bottom, animated: true)
        case 2:
            rowNum += 1
            tableView.insertRows(at: [.init(row: rowNum-1, section: 0)], with: .bottom)
        default:
            break
        }
        
        
        
    }
}
