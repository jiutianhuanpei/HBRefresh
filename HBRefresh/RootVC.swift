//
//  RootVC.swift
//  HBRefresh
//
//  Created by Bang on 2025/8/27.
//

import UIKit

class RootVC: UIViewController {
    var rowNum = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
//        table.contentInset = .init(top: 10, left: 0, bottom: 500, right: 0)
        
        let ar = [
            table.leftAnchor.constraint(equalTo: view.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.rightAnchor),
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(ar)
        
        let header = HBNormalHeaderAnimator()
        header.setTitle("~~~~ . ~~~~", for: .Idle)
        table.hb.addHeader(header) {
            print("下拉刷新")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                table.hb.endRefresh()
            }
        }
        
        let footer = HBNormalFooterAnimator()
        footer.setTitle("", for: .Pulling)
        table.hb.addFooter(footer) {
            print("上拉加载")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                table.hb.endLoadMoreData()
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Self.tapTable(_:)))
//        table.addGestureRecognizer(tap)
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let v = UIView()
        v.backgroundColor = .black.withAlphaComponent(0.2)
        v.frame = CGRect(x: 0, y: view.bounds.height - table.safeAreaInsets.bottom, width: view.bounds.width, height: table.safeAreaInsets.bottom)
        view.addSubview(v)
        
    }
    
    @objc func tapTable(_ ges: UITapGestureRecognizer) {
        
        let top = UIView()
        top.backgroundColor = .green.withAlphaComponent(0.2)
        top.frame = CGRect(x: 0, y: -table.contentInset.top, width: view.frame.width, height: table.contentInset.top)
        table.addSubview(top)
        
        
        let v = UIView(frame: .init(origin: .zero, size: table.contentSize))
        v.backgroundColor = .red.withAlphaComponent(0.2)
        table.addSubview(v)
        
        let bottom = UIView()
        bottom.backgroundColor = .green.withAlphaComponent(0.2)
        bottom.frame = CGRect(x: 0, y: table.contentSize.height, width: view.frame.width, height: table.contentInset.bottom)
        table.addSubview(bottom)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            top.removeFromSuperview()
            v.removeFromSuperview()
            bottom.removeFromSuperview()
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
            tableView.hb.beginRefresh()
        case 1, rowNum-1:
            tableView.hb.beginLoadMoreData()
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
