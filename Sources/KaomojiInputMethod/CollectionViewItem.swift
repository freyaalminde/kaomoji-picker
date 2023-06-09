import AppKit

class CollectionViewItem: NSCollectionViewItem {
  private(set) var titleTextField: NSTextField!

  var selectionColor = NSColor.controlAccentColor { didSet { updateBackgroundColor() } }
  
  override func loadView() {
    titleTextField = CollectionViewItemTextField(labelWithString: "")
    titleTextField.translatesAutoresizingMaskIntoConstraints = false
    titleTextField.alignment = .center
    titleTextField.lineBreakMode = .byTruncatingTail
    titleTextField.allowsExpansionToolTips = true
    textField = titleTextField

    view = NSView()
    view.wantsLayer = true
    view.layer?.cornerRadius = 5
    view.addSubview(titleTextField)

    NSLayoutConstraint.activate([
      titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
      titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
      titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 3),
      titleTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
    ])
  }

  override var representedObject: Any? {
    didSet {
      titleTextField.objectValue = representedObject
    }
  }

  override var isSelected: Bool {
    didSet {
      updateBackgroundColor()

      if selectionColor == .controlAccentColor {
        titleTextField.textColor = isSelected ? .alternateSelectedControlTextColor : nil
      }
    }
  }

  private func updateBackgroundColor() {
    view.layer?.backgroundColor = isSelected ? selectionColor.cgColor : nil
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    isSelected = false
  }

  /// Select items immediately on mouse down.
  override func mouseDown(with event: NSEvent) {
    super.mouseDown(with: event)

    guard
      let collectionView, !collectionView.allowsMultipleSelection, let indexPath = collectionView.indexPath(for: self),
      let itemsToSelect = collectionView.delegate?.collectionView?(collectionView, shouldSelectItemsAt: [indexPath])
    else { return }

    collectionView.selectionIndexPaths = itemsToSelect
    collectionView.delegate?.collectionView?(collectionView, didSelectItemsAt: collectionView.selectionIndexPaths)
  }

  override func mouseUp(with event: NSEvent) {
    super.mouseUp(with: event)

    // TODO: change to just `CollectionViewController.collectionViewItem(_:mouseUp:)`, passing along the event?
    switch event.clickCount {
    case 1:
      NSApp.sendAction(
        #selector(CollectionViewController.collectionViewItemWasClicked(_:)),
        to: collectionView?.delegate,
        from: self
      )
    case 2...:
      NSApp.sendAction(
        #selector(CollectionViewController.collectionViewItemWasDoubleClicked(_:)),
        to: collectionView?.delegate,
        from: self
      )
    default:
      break
    }
  }
}

class CollectionViewItemTextField: NSTextField {
  override var mouseDownCanMoveWindow: Bool { false }
}
