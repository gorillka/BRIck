
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

public typealias ViewController = UIViewController
public typealias Window = UIWindow

#else
import AppKit

public typealias ViewController = NSViewController
public typealias Window = NSWindow

public extension Window {
    var rootViewController: ViewController? {
        get { contentViewController }
        set { contentViewController = newValue }
    }
    
    func makeKeyAndVisible() {
        makeKeyAndOrderFront(nil)
    }
}

#endif
