//
//  ApplicationScheme.swift
//  DumbChess
//
//  Created by Malachi Holden on 9/13/21.
//

import Foundation
import MaterialComponents

class ApplicationScheme: NSObject {
    let containerScheme = { () -> MDCContainerScheming in
        let scheme = MDCContainerScheme()
        scheme.colorScheme.primaryColor =
          UIColor(red: 0.0/255.0, green: 92.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        scheme.colorScheme.primaryColorVariant =
          UIColor(red: 106.0/255.0, green: 183.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        scheme.colorScheme.onPrimaryColor =
            .white
        scheme.colorScheme.secondaryColor =
            UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 1.0)
        scheme.colorScheme.onSecondaryColor =
          UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        scheme.colorScheme.surfaceColor =
            UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        scheme.colorScheme.onSurfaceColor =
            UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        scheme.colorScheme.backgroundColor =
            .white
        scheme.colorScheme.onBackgroundColor =
            .black
        scheme.colorScheme.errorColor =
            .red
        scheme.typographyScheme.body1 = UIFont.preferredFont(forTextStyle: .body)
        scheme.typographyScheme.button = UIFont.preferredFont(forTextStyle: .body)
        return scheme
    }()
    

  private static var singleton = ApplicationScheme()

  static var shared: ApplicationScheme {
    return singleton
  }
}
