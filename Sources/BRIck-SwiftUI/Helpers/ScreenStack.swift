//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

struct ScreenStack {
    private var screens: [Screen] = []

    var rootScreen: Screen? {
        get { screens.first }
        set { screens = [newValue].compactMap { $0 } }
    }

    var topScreen: Screen? { screens.last }

    mutating func push(_ screen: Screen) {
        screens.append(screen)
    }

    mutating func pop() {
        _ = screens.popLast()
    }

    mutating func popToLast() {
        screens = screens.dropLast(screens.count - 1)
    }
}
