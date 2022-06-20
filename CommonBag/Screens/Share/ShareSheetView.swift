//
//  ShareSheetView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 20.06.2022.
//

import SwiftUI
import UIKit

struct ShareSheetView: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
struct ShareSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetView(activityItems: [URL(string: "https://volante.io")!]) { activityType, completed, returnedItems, error in
            
        }
    }
}
