//
//  WCDetailViewCell.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

import Foundation
import UIKit
import SnapKit

final class WCDetailViewCell: UITableViewCell {
    
    private lazy var dotLabel = world_countries.configure(UILabel()) {
        $0.text = "•"
        $0.textAlignment = .center
        $0.baselineAdjustment = .alignCenters
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    lazy var titleLabel = world_countries.configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .textGray
    }
    
    lazy var valueLabel = world_countries.configure(UILabel()) {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, with value: String){
        titleLabel.text = title
        valueLabel.text = value
    }

}
// MARK: - Configure views

private extension WCDetailViewCell {
    
    private func configureViews() {
        selectionStyle = .none

        makeConstraints()
    }
    
    private func makeConstraints() {
        
        contentView.addSubview(dotLabel)
        dotLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.left.equalToSuperview()
            $0.width.equalTo(24)
            $0.height.equalTo(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(dotLabel.snp.right).offset(8)
            $0.right.equalToSuperview()
        }
        
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(dotLabel.snp.right).offset(8)
            $0.right.equalToSuperview()
        }
        
    }
}


