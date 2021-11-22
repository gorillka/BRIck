//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import SwiftUI

public final class ViewRouter: ObservableObject {
    // MARK: Public Properties

    @Published public private(set) var currentScreen: Screen?

    public var rootScreen: Screen? {
        get { stack.rootScreen }
        set { stack.rootScreen = newValue }
    }

    // MARK: Private Properties

    private var stack = ScreenStack() {
        didSet {
            DispatchQueue.main.async {
                self.currentScreen = self.stack.topScreen
            }
        }
    }

    // MARK: Inits

    public init() {
        self.currentScreen = nil
    }

    public func push<Content: View>(_ content: Content) {
        stack.push(Screen(content))
    }

    public func pop() {
        stack.pop()
    }

    public func popToRoot() {
        stack.popToLast()
    }
}
