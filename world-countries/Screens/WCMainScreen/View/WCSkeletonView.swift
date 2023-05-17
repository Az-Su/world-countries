//
//  WCSkeletonView.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 17.05.2023.
//

import Skeleton
import UIKit

class WCSkeletonView: UIView {
    
    // MARK: - UI elements
    
    private lazy var blockView: GradientContainerView = {
        let view = GradientContainerView()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var holderView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Initiliazers
    
    init() {
        super.init(frame: .zero)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        gradientLayers.forEach { gradientLayer in
            let baseColor = UIColor(.gray)
            gradientLayer.colors = [baseColor.cgColor, UIColor(white: 0.8, alpha: 0.2).cgColor, baseColor.cgColor]
        }
        
        addSubview(holderView)
        holderView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        holderView.addSubview(blockView)
        blockView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}

extension WCSkeletonView: GradientsOwner {
    
    var gradientLayers: [CAGradientLayer] {
        return [blockView.gradientLayer]
    }
}
