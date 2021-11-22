//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct LazyView<Content: View>: View {
    // MARK: Private Properties

    private let content: () -> Content

    // MARK: Public Properties

    public var body: some View { content() }

    // MARK: Inits

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public init(_ content: @escaping @autoclosure () -> Content) {
        self.content = content
    }
}
