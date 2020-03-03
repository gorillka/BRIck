//
// Copyright © 2020. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import UIKit

/// The base protocol for all `Presenter`'s.
public protocol Presentable: AnyObject {}

/// The base class of all `Presenter`'s. A `Presenter` translates business models into values the corresponding `ViewController` can consume and display.
/// It also maps UI events to business logic method, invoke to its listener.
open class Presenter<ViewControllerType>: Presentable {
	/// The `ViewController` of this `Presenter`.
	let viewController: ViewControllerType

	/// Initializer.
	///
	/// - Parameter viewController: The `ViewController` of this `Presenter`.
	public required init(viewController: ViewControllerType) {
		self.viewController = viewController
	}
}
