//
//  ImageUploader.swift
//  Master
//
//  Created by Carlos Mejía on 14/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import Firebase

typealias OnCompleteUploadBlock = (_ isSuccess: Bool, _ result: String?, _ error: String?) -> Void

// This was literally migrated from Kotlin, so DON'T JUDGE! ;)
class ImageUploader {
    var onCompleteBlock: OnCompleteUploadBlock?
    private var mStorageRef = Storage.storage().reference()
    
    func upload(image: UIImageView, name: String, path: String) {
        
        guard let downsizedImageData = getDownsizedImageBytes(image: image, compressionQuality: 0.5) else {
            onCompleteBlock?(false, nil, "Unable to compress image or create storage reference.")
            
            return
        }
        
        let picturesReference = mStorageRef.child("\(path)/\(name).jpeg")
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        BackgroundThread { [weak self] in
            
            picturesReference.putData(downsizedImageData, metadata: metaDataConfig) { [weak self] (metaData: StorageMetadata?, error: Error?) in
                
                guard metaData != nil, error == nil else {
                    MainThread {
                        self?.onCompleteBlock?(false, nil, "Unable to get Metadata from uploadtask.")
                    }
                    
                    return
                }
                
                self?.fetchDownloadUrlWith(reference: picturesReference)
            }
        }
    }
    
    private func fetchDownloadUrlWith(reference: StorageReference) {
        reference.downloadURL { [weak self] (url: URL?, error: Error?) in
            MainThread {
                guard let url = url, error == nil else {
                    self?.onCompleteBlock?(false, nil, "Unable to get Metadata from uploadtask.")
                    
                    return
                }
                
                self?.onCompleteBlock?(true, url.absoluteString, nil)
            }
        }
    }
    
    private func getDownsizedImageBytes(image: UIImageView, compressionQuality: CGFloat) -> Data? {
        let scaledBitmap = image.image?.jpegData(compressionQuality: compressionQuality)
        
        return scaledBitmap
    }
}
