//
//  DebugCollectionViewCell.swift
//  MarvelShop
//
//  Created by Charlie
//

#if DEBUG

import UIKit
import SnapKit


final class DebugCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = Design.font
        label.numberOfLines = 0

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

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {

    }

    private func setupLayout() {
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(Design.margin)
            make.center.equalToSuperview()
        }

    }

}

private enum Design {

    static let margin: CGFloat = 10
    static let font: UIFont = .systemFont(ofSize: 15)

}

#endif
