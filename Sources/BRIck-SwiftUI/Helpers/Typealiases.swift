//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)
    public typealias HostingController = UIHostingController
#else
    public typealias HostingController = NSHostingController
#endif
