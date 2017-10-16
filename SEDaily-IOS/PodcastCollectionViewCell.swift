//
//  PodcastCollectionViewCell.swift
//  SEDaily-IOS
//
//  Created by Craig Holliday on 6/27/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import Kingfisher
import KTResponsiveUI
import Skeleton

class PodcastCollectionViewCell: UICollectionViewCell {
    
    var podcastModel: PodcastModel!
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        
        self.contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 2.calculateWidth()
        
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOpacity = 0.75
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1.calculateHeight())
        contentView.layer.shadowRadius = 2.calculateWidth()
        
        let topBottomInset = 5.0.calculateHeight()
        let amountToSubtract = topBottomInset * 2
        
        let twoThirds: CGFloat = (2.0/3.0)
        
        imageView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().inset(topBottomInset)
            make.left.right.equalToSuperview().inset(10.calculateWidth())
            make.height.equalTo(((self.height * twoThirds) - amountToSubtract))
        }
        
        imageView.contentMode = .scaleAspectFit
        
        let oneThird: CGFloat = (1.0/3.0)
        
        titleLabel.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().inset(topBottomInset)
            make.left.right.equalToSuperview().inset(10.calculateWidth())
            make.height.equalTo(((self.height * oneThird) - amountToSubtract))
        }

        titleLabel.font = UIFont.systemFont(ofSize: 16.calculateWidth())
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.minimumScaleFactor = 0.25
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = Stylesheet.Colors.offBlack
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupCell(model: PodcastModel) {
        self.podcastModel = model
        guard let name = model.podcastName else { return }
        titleLabel.text = name
        
        guard let imageURLString = model.imageURLString else {
            self.imageView.image = #imageLiteral(resourceName: "SEDaily_Logo")
            return
        }
        if let url = URL(string: imageURLString) {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url)
        }
    }
}

class PodcastCell: UICollectionViewCell {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var timeDayLabel: UILabel!
    
    var viewModel: PodcastViewModel = PodcastViewModel() {
        didSet {
            self.titleLabel.text = viewModel.podcastTitle
            self.setupTimeDayLabel(timeLength: nil, date: viewModel.uploadDateAsDate)
            self.setupImageView(imageURL: viewModel.featuredImageURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let newContentView = UIView(width: 158, height: 250)
        self.contentView.frame = newContentView.frame
        
        imageView = UIImageView(leftInset: 0, topInset: 4, width: 158)
        self.contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius = UIView.getValueScaledByScreenHeightFor(baseValue: 6)
        
        titleLabel = UILabel(origin: imageView.bottomLeftPoint(), topInset: 15, width: 158, height: 50)
        self.contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 16))
        
        timeDayLabel = UILabel(origin: titleLabel.bottomLeftPoint(), topInset: 8, width: 158, height: 14)
        self.contentView.addSubview(timeDayLabel)
        timeDayLabel.font = UIFont.systemFont(ofSize: UIView.getValueScaledByScreenWidthFor(baseValue: 12))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func setupCell(imageURLString: String?, title: String?, timeLength: Int?, date: Date?) {
        titleLabel.text = title ?? ""
        self.setupTimeDayLabel(timeLength: timeLength, date: date)
        guard let imageURLString = imageURLString else {
            self.imageView.image = #imageLiteral(resourceName: "SEDaily_Logo")
            return
        }
        if let url = URL(string: imageURLString) {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: url)
        }
    }
    
    func setupImageView(imageURL: URL?) {
        guard let imageURL = imageURL else {
            self.imageView.image = #imageLiteral(resourceName: "SEDaily_Logo")
            return
        }
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: imageURL)
    }
    
    func setupTimeDayLabel(timeLength: Int?, date: Date?) {
//        let timeString = Helpers.createTimeString(time: (Float(timeLength ?? 0)))
        let dateString = date?.dateString() ?? ""
//        guard timeString != "00:00" else {
            timeDayLabel.text = dateString
//            return
//        }
//        timeDayLabel.text = timeString + " \u{2022} " + dateString
    }
    
    // MARK: Skeleton
    var skeletonImageView: GradientContainerView!
    var skeletonTitleLabel: GradientContainerView!
    var skeletontimeDayLabel: GradientContainerView!
    
    private func setupSkeletonView() {
        self.skeletonImageView = GradientContainerView(frame: self.imageView.frame)
        self.skeletonImageView.cornerRadius = self.imageView.cornerRadius
        self.skeletonImageView.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        self.contentView.addSubview(skeletonImageView)
        skeletonTitleLabel = GradientContainerView(origin: imageView.bottomLeftPoint(), topInset: 15, width: 158, height: 14)
        self.contentView.addSubview(skeletonTitleLabel)
        skeletontimeDayLabel = GradientContainerView(origin: skeletonTitleLabel.bottomLeftPoint(), topInset: 15, width: 158, height: 14)
        self.contentView.addSubview(skeletontimeDayLabel)
        
        let baseColor = self.skeletonImageView.backgroundColor!
        let gradients = baseColor.getGradientColors(brightenedBy: 1.07)
        self.skeletonImageView.gradientLayer.colors = gradients
        self.skeletonTitleLabel.gradientLayer.colors = gradients
        self.skeletontimeDayLabel.gradientLayer.colors = gradients
    }
    
    func setupSkeletonCell() {
        self.setupSkeletonView()
        self.slide(to: .right)
    }
}

extension PodcastCell: GradientsOwner {
    var gradientLayers: [CAGradientLayer] {
        return [skeletonImageView.gradientLayer,
                skeletonTitleLabel.gradientLayer,
                skeletontimeDayLabel.gradientLayer
        ]
    }
}

extension UIColor {
    func brightened(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
    
    func getGradientColors(brightenedBy: CGFloat) -> [Any] {
        return [self.cgColor,
                self.brightened(by: brightenedBy).cgColor,
                self.cgColor]
    }
}
