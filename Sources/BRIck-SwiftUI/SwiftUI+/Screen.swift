//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct Screen: View {
    private let anyView: AnyView

    public var body: some View { anyView }

    public init<Content: View>(@ViewBuilder content: () -> Content) {
        self.anyView = content().eraseToAnyView()
    }

    public init<Content: View>(_ content: @autoclosure () -> Content) {
        self.init { content() }
    }
}

public extension Screen {
    static var empty: Screen { Screen(EmptyView()) }
}
