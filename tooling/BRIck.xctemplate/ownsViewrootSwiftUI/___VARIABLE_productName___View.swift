//
// Copyright © 2021. Orynko Artem
//
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct ___VARIABLE_productName___View: View {
    // MARK: Public Properties

    public var body: some View {
        Text("Hello, I'm ___VARIABLE_productName___ BRIck.")
            .onAppear(perform: viewModel.listener?.onAppear)
            .onDisappear(perform: viewModel.listener?.onDisappear)
    }

    // MARK: Private Properties

    @ObservedObject private var viewModel: ___VARIABLE_productName___ViewModel

    // MARK: Inits

    init(_ viewModel: ___VARIABLE_productName___Presenter) {
        self.viewModel = viewModel
    }

    // MARK: Public Methods

    // MARK: Private Methods
}

#if DEBUG
    struct ___VARIABLE_productName___View_Preview: PreviewProvider {
        static var previews: some View {
            ___VARIABLE_productName___View(___VARIABLE_productName___ViewModel())
        }
    }
#endif
