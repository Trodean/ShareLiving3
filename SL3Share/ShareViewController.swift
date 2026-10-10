//
//  ShareViewController.swift
//  SL3Share
//
//  Created by Yang Peng on 9/10/2026.
//

import UIKit
import Social

final class ShareViewController: SLComposeServiceViewController {

    private var sharedText: String?
    private var sharedURL: URL?
    private var selectedCategory: BoardCategory = .notice
    private lazy var categoryItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()!

        item.title = "Category"
        item.value = selectedCategory.displayName
        item.tapHandler = { [weak self] in
            self?.showCategoryPicker()
        }
        return item
    }()

    override func isContentValid() -> Bool{
        true
    }
    override func didSelectPost() {

        let inputItems =
            extensionContext?.inputItems as? [NSExtensionItem] ?? []
        let group = DispatchGroup()

        for inputItem in inputItems {
            guard let attachments = inputItem.attachments else {
                continue
            }
            for provider in attachments {
                if provider.canLoadObject(ofClass: NSURL.self) {
                    group.enter()
                    provider.loadObject(
                        ofClass: NSURL.self
                    ) { [weak self] object, _ in

                        if let url = object as? URL {
                            self?.sharedURL = url
                        }

                        group.leave()
                    }
                }
                if provider.canLoadObject(ofClass: NSString.self) {
                    group.enter()
                    provider.loadObject(
                        ofClass: NSString.self
                    ) { [weak self] object, _ in
                        if let text = object as? String {
                            self?.sharedText = text
                        }
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: .main) { [weak self] in

            guard let self else {
                return
            }

            let typedNote = self.contentText
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            let post = BoardPost(
                note: typedNote.isEmpty ? nil : typedNote,
                sourceText: self.sharedText,
                urlString: self.sharedURL?.absoluteString,
                category: self.selectedCategory
            )
            BoardPostStore.addPost(post)
            self.extensionContext?
                .completeRequest(
                    returningItems: nil,
                    completionHandler: nil
                )
        }
    }

    override func configurationItems() -> [Any]! {
        [
            categoryItem
        ]
    }

    private func showCategoryPicker() {
        let alert = UIAlertController(
            title: "Choose Category",
            message: nil,
            preferredStyle: .actionSheet
        )

        for category in BoardCategory.allCases{

            alert.addAction(
                UIAlertAction(
                    title: category.displayName,
                    style: .default
                ) { [weak self] _ in

                    self?.selectedCategory = category
                    self?.categoryItem.value =
                        category.displayName
                }
            )
        }
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )
        present(
            alert,
            animated: true
        )
    }
}
