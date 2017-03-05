//
//  AdHelper.swift
//  PPMS
//
//  Created by Jansen on 3/4/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import Foundation

class AdHelper {
    let completionBlockFullScreen: () -> Void = {
        RevMobAds.session().showFullscreen()
    }
    let errorBlock: (Error?) -> Void = {error in
        // check the error
        print(error ?? "error in ad")
    }
    
    let AppId = ""
    
    
    
    
    
}
