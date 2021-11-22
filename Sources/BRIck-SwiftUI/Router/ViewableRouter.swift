//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import BRIck
import SwiftUI

/// The base protocol for all routers that own their own view.
public protocol ViewableRouting: Routing {
    func eraseToScreen() -> Screen
}

/// The base class of all routers that owns views, representing applications states.
///
/// A `Router` acts on inputs from its corresponding interactors, representing application states.
open class ViewableRouter<
    InteractorType,
    ViewControllableType: ViewControllable,
    Content: View
>: Router<InteractorType>,
    ViewableRouting
{
    /// The corresponding `View` owned by this `Router`.
    public let view: LazyView<Content>

    /// The base `ViewControllable` associated with this `Router`.
    public let viewControllable: ViewControllableType

    /// Initializer.
    ///
    /// - Parameters:
    ///   - interactor: The corresponding `Interactor` of this `Router`.
    ///   - viewControllable: The corresponding `ViewControllable` of this `Router`.
    public init(
        interactor: InteractorType,
        viewControllable: ViewControllableType,
        view: Content
    ) {
        self.viewControllable = viewControllable
        self.view = LazyView(view)

        super.init(interactor: interactor)
    }

    public func eraseToScreen() -> Screen { Screen { [unowned self] in view } }
}
