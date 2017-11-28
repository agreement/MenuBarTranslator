//
//  TranslateViewContollerActions.swift
//  MenuBarTranslator
//
//  Created by Artem Bobrov on 19.11.2017.
//  Copyright © 2017 Artem Bobrov. All rights reserved.
//

import Foundation
import Cocoa

extension TranslateViewController {

	func detect(completion: (() -> Void)? = nil) {
		guard !self.inputView.textView.isEmpty else {
			updatePronounceLanguages()
			return
		}
		detect(for: inputLanguageButton, with: inputView.textView.string, completion: completion)
	}

	fileprivate func detect(for sender: LanguageButton?, with text: String, completion: (() -> Void)? = nil) {
		Dictionary.shared.detectLanguage(by: text, completion: { (lang) in
			guard let lang = lang else {
				return
			}
			sender?.language = Languages.searchLanguage(by: lang)

			completion?()
			self.updatePronounceLanguages()
		})
	}

	fileprivate func translate(text: String, with direction: TranslateDirection) {
		Dictionary.shared.translate(text, with: direction) { (text) in
			guard let text = text else {
				self.updatePronounceLanguages()
				return
			}
			self.outputView.textView.string = text
			self.isTranslated = true
			self.updatePronounceLanguages()
		}
	}

	func translate() {
		if let language = inputLanguageButton.language, language.isAutoLanguage {
			detect(for: inputLanguageButton, with: inputView.textView.string, completion: {
				guard let language = self.inputLanguageButton.language else {
					self.inputLanguageButton.language = Languages.auto
					self.updatePronounceLanguages()
					return
				}

				let direction = TranslateDirection(from: language, to: self.outputLanguageButton.language!)
				self.translate(text: self.inputView.textView.string, with: direction)
			})
		} else {
			let direction = TranslateDirection(from: inputLanguageButton.language!, to: outputLanguageButton.language!)
			translate(text: inputView.textView.string, with: direction)
		}
	}
}
