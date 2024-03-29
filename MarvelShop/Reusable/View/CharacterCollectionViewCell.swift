//
//  CharacterCollectionViewCell.swift
//  MarvelShop
//
//  Created by Charlie
//

import UIKit
import SnapKit


protocol CharacterCollectionViewCellModel {

    var title: String { get }
    var subtitle: String { get }
    var imageURLString: String { get }

}

final class CharacterCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray

        return imageView
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = Design.infoStackViewSpacing
        stackView.alignment = .leading

        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = Design.titleFont
        label.textColor = Design.titleTextColor
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .vertical)

        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()

        label.font = Design.contentFont
        label.textColor = Design.contentTextColor
        label.numberOfLines = 0
        label.textAlignment = .left

        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Methods

    override func prepareForReuse() {
        super.prepareForReuse()

        thumbnailImageView.cancelDownload()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
    }

    func setModel(_ model: CharacterCollectionViewCellModel, isFavorite: Bool) {
        thumbnailImageView.setImage(model.imageURLString)
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        contentView.backgroundColor = isFavorite ? Design.favoriteBackgroundColor : .white
    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
        self.layer.cornerRadius = Design.cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderColor = Design.borderColor.cgColor
        self.layer.borderWidth = 1.0

        contentView.backgroundColor = .white
    }

    private func setupLayout() {
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(Design.imageMargin)
            make.centerX.equalToSuperview()
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(Design.imageRatio)
        }

        contentView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(Design.infoStackViewTopMargin)
            make.leading.equalToSuperview().offset(Design.infoStackViewHorizontalMargin)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)
    }

}

private enum Design {

    static let cornerRadius: CGFloat = 10

    static let borderColor: UIColor = .lightGray

    static let imageMargin: CGFloat = 10
    static let imageRatio: CGFloat = 4/5

    static let infoStackViewSpacing: CGFloat = 3
    static let infoStackViewTopMargin: CGFloat = 15
    static let infoStackViewHorizontalMargin: CGFloat = 10

    static let titleFont: UIFont = .systemFont(ofSize: 17, weight: .bold)
    static let titleTextColor: UIColor = .black

    static let contentFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
    static let contentTextColor: UIColor = .darkGray

    static let favoriteBackgroundColor: UIColor = .lightGray

}
