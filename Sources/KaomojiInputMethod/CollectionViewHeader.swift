import AppKit

class CollectionViewHeader: NSView {
  private(set) var searchField: NSSearchField!
  private(set) var settingsButton: NSButton!

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)

    searchField = NSSearchField()

    settingsButton = NSButton()
    settingsButton.image = .settingsIcon
    settingsButton.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 13.5, weight: .regular)
    settingsButton.target = NSApp.delegate
    settingsButton.action = #selector(AppDelegate.showSettingsWindow(_:))
    settingsButton.isBordered = false
    settingsButton.refusesFirstResponder = true

    let stackView = NSStackView(views: [searchField, settingsButton])
    stackView.edgeInsets = NSEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
    stackView.spacing = 6
    addSubview(stackView)

    NSLayoutConstraint.activate([
      settingsButton.widthAnchor.constraint(equalToConstant: 29),
      settingsButton.heightAnchor.constraint(equalToConstant: 15),

      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 11),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class CollectionViewHeaderSpacer: NSView, NSCollectionViewElement {
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)

    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: CollectionViewController.searchBarHeight),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
