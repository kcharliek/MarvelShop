//
//  DebugNetworkiDetailViewController.swift
//  MarvelShop
//
//  Created by Charlie
//

#if DEBUG

import UIKit


final class DebugNetworkiDetailViewController: UIViewController {

    // MARK: - Properties

    private let textView: UITextView = {
        let label = UITextView()

        label.font = Design.font

        return label
    }()

    private let history: NetworkHistory

    // MARK: - Initializer

    init(history: NetworkHistory) {
        self.history = history
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("DO NOT USE WITH INTERFACE BUILDER")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Methods

    private func bind() {

    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
        view.backgroundColor = .white

        let requestText = "🚀🚀 Request 🚀🚀\n\(history.request.url?.absoluteString ?? "")"
        let responseText = "⚡️⚡️ Response ⚡️⚡️\n\(history.responseJSONString) ⚡️⚡️"

        textView.text = requestText + "\n\n" + responseText
    }

    private func setupLayout() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

private enum Design {

    static let font: UIFont = .systemFont(ofSize: 15)

}

#endif
