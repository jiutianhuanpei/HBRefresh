//
//  HBNormalHeaderAnimator.swift
//  HBRefresh
//
//  Created by Bang on 2025/8/27.
//

import UIKit

@MainActor
public class HBNormalHeaderAnimator: UIView, RefreshAnimator {
    public var view: UIView { self }
    public var hb_height: CGFloat { 150 }
    public var trigger: CGFloat { 50 }
    private var titleLeftConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgView)
        bgView.addSubview(imgView)
        bgView.addSubview(refresh)
        bgView.addSubview(textLbl)
        titleLeftConstraint = textLbl.leftAnchor.constraint(equalTo: bgView.leftAnchor, constant: 30)
        
        NSLayoutConstraint.activate([
            bgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bgView.heightAnchor.constraint(equalToConstant: trigger),
            
            imgView.widthAnchor.constraint(equalToConstant: 20),
            imgView.heightAnchor.constraint(equalToConstant: 20),
            imgView.leftAnchor.constraint(equalTo: bgView.leftAnchor),
            imgView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            refresh.widthAnchor.constraint(equalToConstant: 20),
            refresh.heightAnchor.constraint(equalToConstant: 20),
            refresh.leftAnchor.constraint(equalTo: bgView.leftAnchor),
            refresh.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            
            titleLeftConstraint!,
            textLbl.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            textLbl.rightAnchor.constraint(equalTo: bgView.rightAnchor)
        ])
        refresh.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var titleMap: [RefreshState : String] = [:]
    
    public func setTitle(_ title: String, for state: RefreshState) {
        titleMap[state] = title
    }
    
    public func refreshPulling(_ scrollView: UIScrollView) {
        textLbl.text = titleMap[.Pulling] ?? "下拉刷新"
        refresh.isHidden = true
        imgView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            [self] in
            titleLeftConstraint?.constant = 30
            imgView.transform = .identity
        }
    }
    
    public func refreshWillRefresh(_ scrollView: UIScrollView) {
        textLbl.text = titleMap[.WillRefresh] ?? "松开刷新"
        refresh.isHidden = true
        imgView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            [self] in
            imgView.transform = .init(rotationAngle: Double.pi)
        }
    }
    
    public func refreshRefreshing(_ scrollView: UIScrollView) {
        textLbl.text = titleMap[.Refreshing] ?? "刷新中"
        refresh.isHidden = false
        imgView.isHidden = true
        imgView.transform = .identity
        refresh.startAnimating()
        titleLeftConstraint?.constant = 30
    }
    
    public func refreshIdle(_ scrollView: UIScrollView) {
        textLbl.text = titleMap[.Idle] ?? "^_^"
        refresh.isHidden = true
        refresh.stopAnimating()
        imgView.isHidden = true
        UIView.animate(withDuration: 0.2) {
            [self] in
            titleLeftConstraint?.constant = 0
            imgView.transform = .identity
        }
    }
    
    //MARK: - getter
    private lazy var refresh: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var bgView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private lazy var imgView: UIImageView = {
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
