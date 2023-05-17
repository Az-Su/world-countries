//
//  WCDetailsHeaderView.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

import UIKit

final class WCDetailsHeaderView: UIView {
 
    lazy var flagImageView = configure(UIImageView()) {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.image = UIImage(named: "flag1")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


// MARK: - Configure views

private extension WCDetailsHeaderView {
    
    private func configureViews() {
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        addSubview(flagImageView)
        flagImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
//            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.equalTo(343)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
        }
    
    }
}
