//
//  ExtraThings.swift
//  MenuBarTranslator
//
//  Created by Artem Bobrov on 18.08.17.
//  Copyright © 2017 Artem Bobrov. All rights reserved.
//

import Foundation
import Cocoa

extension CGPoint {
	static func ~=(point: CGPoint, rect: CGRect) -> Bool {
		let magic: CGFloat = 30.0
		return magic + rect.origin.x...magic + rect.origin.x + rect.width ~= point.x && rect.origin.y...rect.origin.y + rect.height ~= point.y
	}
}

extension NSTextView {
	var isEmpty: Bool {
		get {
			return self.string.count == 0
		}
		set {
			if(newValue) {
				self.string = ""
			}
		}
	}

	var isPronouncable: Bool {
		return 1...1000 ~= self.string.count
	}
}
