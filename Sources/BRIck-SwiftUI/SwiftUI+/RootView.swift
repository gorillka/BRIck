//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var router: ViewRouter

    var body: some View { router.currentScreen }

    init<Content: View>(_ router: ViewRouter, @ViewBuilder content: @escaping () -> Content) {
        self.router = router
        router.rootScreen = Screen(content: content)
    }
}
