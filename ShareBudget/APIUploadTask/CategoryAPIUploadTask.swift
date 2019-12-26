//
//  CategoryAPIUploadTask.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 26/12/2019.
//  Copyright © 2019 Denys Meloshyn. All rights reserved.
//

import UIKit

class CategoryAPIUploadTask: APIUploadTask, APIUploadTaskProtocol {
    var endpointURLBuilder: URL.Builder {
        restApiURLBuilder.appendPath("category")
    }
}
