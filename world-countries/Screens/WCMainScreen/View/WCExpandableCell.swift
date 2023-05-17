//
//  ExpandableCell.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 13.05.2023.
//

import UIKit
import SnapKit
import Kingfisher


final class WCExpandableCell: BaseCollectionViewCell {
    
    // MARK: - Redefining isSelected to call updateAppearance() for each change
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Public Properties
    
    var learnMoreButtonTapped: (() -> ())?
    
    // MARK: - Constrain for extended state
    private var expandedConstraint: Constraint!
    
    // MARK: Constrain for the compressed state
    private var collapsedConstraint: Constraint!
    
    private let skeletonView: WCSkeletonView = .init()
    
    // MARK: - UI Components
    
    private lazy var mainContainer = UIView()
    private lazy var topContainer = UIView()
    private lazy var bottomContainer = UIView()
    
    
    
    private lazy var flagImageView = world_countries.configure(UIImageView()) {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private lazy var countryLabel = world_countries.configure(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    private lazy var capitalLabel = world_countries.configure(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = UIColor.textGray
    }
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow_down")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var countryDescriptionView = UIView()
    
    private lazy var populationLabel = world_countries.configure(UILabel()) {
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.black
    }
    
    private lazy var areaLabel = world_countries.configure(UILabel()) {
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.textGray
    }
    
    private lazy var currenciesLabel = world_countries.configure(UILabel()) {
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = UIColor.textGray
    }
    
    lazy var learnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Learn more", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(learnMoreTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// When the cell selection state changes, we switch constants and animate the rotation of the arrow
    private func updateAppearance() {
        collapsedConstraint.isActive = !isSelected
        expandedConstraint.isActive = isSelected
        
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999 )
            self.arrowImageView.transform = self.isSelected ? upsideDown : .identity
        }
    }
    
    // MARK: - Configure Model
    
    func configure(with country: Country){
        
        if country.name?.common == "hide" {
            set(loading: true)
        } else {
            set(loading: false)
        }
        
        guard let url = URL(string: country.flags?.png ?? "") else {
            return
        }
        
        flagImageView.kf.setImage(with: url)
        
        countryLabel.text = country.name?.common
        capitalLabel.text = country.capital?[0]
        
        UIHelper.changeTextColor(title: "Population: ", value: String(FormatHelper.formatPopulation(country.population ?? 0)), for: populationLabel)
        UIHelper.changeTextColor(title: "Area: ", value: String(FormatHelper.formatArea(country.area ?? 0)), for: areaLabel)
        UIHelper.changeTextColor(title: "Currency: ", value: FormatHelper.formatCurrency(country), for: currenciesLabel)
        
    }
    
    // MARK: - Make UI
    
    override func makeUI() {
        
        mainContainer.clipsToBounds = true
        topContainer.backgroundColor = UIColor.backgroundGray
        bottomContainer.backgroundColor = UIColor.backgroundGray
        
        /// Redirecting to a tap
        let tapGesture = UITapGestureRecognizer()
        bottomContainer.addGestureRecognizer(tapGesture)
        
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        setupSkeletonView()
        skeletonView.isHidden = true
        
        makeConstraints()
        updateAppearance()
    }
    
    func set(loading: Bool) {
        loading ? skeletonView.slide(to: .right) : skeletonView.stopSliding()
        mainContainer.isHidden = loading
        skeletonView.isHidden = !loading
        skeletonView.alpha = loading ? 1 : 0
    }
    
    private func setupSkeletonView() {
        contentView.addSubview(skeletonView)
        skeletonView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
            
        }
    }
    
}

// MARK: - Configure views

private extension WCExpandableCell {
    
    private func makeConstraints() {
        
        contentView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainContainer.addSubview(topContainer)
        topContainer.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(72)
        }
        
        //MARK: - TopContainer
        topContainer.addSubview(flagImageView)
        flagImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.equalTo(82)
            $0.height.equalTo(48)
        }
        
        topContainer.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints {
            $0.height.equalTo(7)
            $0.width.equalTo(13)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-17)
        }
        
        topContainer.addSubview(countryLabel)
        countryLabel.snp.makeConstraints {
            $0.left.equalTo(flagImageView.snp.right).offset(12)
            $0.right.equalTo(arrowImageView.snp.left).offset(-16)
            $0.top.equalToSuperview().offset(16)
        }
        
        topContainer.addSubview(capitalLabel)
        capitalLabel.snp.makeConstraints {
            $0.left.equalTo(flagImageView.snp.right).offset(12)
            $0.top.equalTo(countryLabel.snp.bottom).offset(4)
        }
        
        /// Constrain for the compressed state
        topContainer.snp.prepareConstraints {
            collapsedConstraint = $0.bottom.equalToSuperview().constraint
            collapsedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
        
        //MARK: - BottomContainer
        mainContainer.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints {
            $0.top.equalTo(topContainer.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(144)
        }
        
        bottomContainer.addSubview(countryDescriptionView)
        countryDescriptionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        countryDescriptionView.addSubview(populationLabel)
        populationLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().offset(12)
            $0.top.equalToSuperview()
        }
        
        countryDescriptionView.addSubview(areaLabel)
        areaLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().offset(12)
            $0.top.equalTo(populationLabel.snp.bottom).offset(8)
        }
        
        countryDescriptionView.addSubview(currenciesLabel)
        currenciesLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().offset(12)
            $0.top.equalTo(areaLabel.snp.bottom).offset(8)
        }
        
        bottomContainer.addSubview(learnMoreButton)
        learnMoreButton.snp.makeConstraints {
            $0.top.equalTo(currenciesLabel.snp.bottom).offset(26)
            $0.centerX.equalToSuperview()
        }
        
        /// Constrain for extended state
        bottomContainer.snp.prepareConstraints {
            expandedConstraint = $0.bottom.equalToSuperview().constraint
            expandedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
    }
}

//MARK: - Button actions

extension WCExpandableCell {
    @objc func learnMoreTapped() {
        learnMoreButtonTapped?()
    }
}
