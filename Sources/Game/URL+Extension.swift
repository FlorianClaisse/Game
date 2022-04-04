//
//  URL+Extension.swift
//  
//
//  Created by Florian Claisse on 04/04/2022.
//

import Foundation

// https://stackoverflow.com/questions/27721418/getting-list-of-files-in-documents-folder

internal extension URL {
    
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var isJSON: Bool { typeIdentifier == "public.json" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    
}
