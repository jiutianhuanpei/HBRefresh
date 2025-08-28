//
//  HBNormalHeaderAnimator.swift
//  HBRefresh
//
//  Created by Bang on 2025/8/27.
//

import UIKit

class HBNormalHeaderAnimator: UIView, RefreshAnimator {
    var view: UIView { self }
    var hb_height: CGFloat { 150 }
    var trigger: CGFloat { 50 }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        
        addSubview(bgView)
        bgView.addSubview(imgView)
        bgView.addSubview(refresh)
        bgView.addSubview(textLbl)
        NSLayoutConstraint.activate([
            bgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            bgView.heightAnchor.constraint(equalToConstant: 26),
            
            imgView.widthAnchor.constraint(equalToConstant: 20),
            imgView.heightAnchor.constraint(equalToConstant: 20),
            imgView.leftAnchor.constraint(equalTo: bgView.leftAnchor),
            imgView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            refresh.widthAnchor.constraint(equalToConstant: 20),
            refresh.heightAnchor.constraint(equalToConstant: 20),
            refresh.leftAnchor.constraint(equalTo: bgView.leftAnchor),
            refresh.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            textLbl.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: 10),
            textLbl.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            textLbl.rightAnchor.constraint(equalTo: bgView.rightAnchor)
        ])
        refresh.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func refreshPulling(_ scrollView: UIScrollView) {
        textLbl.text = "下拉刷新"
        refresh.isHidden = true
        imgView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            [self] in
            imgView.transform = .identity
        }
    }
    
    func refreshWillRefresh(_ scrollView: UIScrollView) {
        textLbl.text = "松开刷新"
        refresh.isHidden = true
        imgView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            [self] in
            imgView.transform = .init(rotationAngle: Double.pi)
        }
    }
    
    func refreshRefreshing(_ scrollView: UIScrollView) {
        textLbl.text = "刷新中"
        refresh.isHidden = false
        imgView.isHidden = true
        imgView.transform = .identity
        refresh.startAnimating()
    }
    
    func refreshIdle(_ scrollView: UIScrollView) {
        textLbl.text = "^_^"
        refresh.isHidden = true
        refresh.stopAnimating()
        imgView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            [self] in
            imgView.transform = .identity
        }
    }
    
    //MARK: - getter
    lazy var refresh: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy var imgView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = .init(systemName: "arrow.down")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return v
    }()
    private lazy var textLbl: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .black
        v.textAlignment = .center
        return v
    }()
}
