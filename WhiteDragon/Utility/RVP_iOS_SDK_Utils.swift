/* ###################################################################################################################################### */
/**
    © Copyright 2018, The Great Rift Valley Software Company.
    
    MIT License
    
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
    modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
    CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    
    The Great Rift Valley Software Company: https://riftvalleysoftware.com
*/

import UIKit
import AVKit
import PDFKit
import WhiteDragon

/* ###################################################################################################################################### */
// MARK: - Class Extensions -
/* ###################################################################################################################################### */
/**
 This adds some iOS-specific extensions to the payload handler.
 */
@available(iOS 11.0, *) // This requires iOS 11 or higher. No MacOS.
extension RVP_Cocoa_SDK_Payload {
    /* ################################################################## */
    /**
     - returns: the payload. If possible, as an object (images are UIImage, Video is AVAsset, PDF is PDFDocument, and text is String). Otherwise, nil (no payload) or as a Data object.
     */
    public var payloadResolved: Any? {
        var ret: Any?
        
        if  let myData = self.payloadData,
            let slash = self.payloadType.firstIndex(of: "/") {
            let start = self.payloadType.index(after: slash)
            let mediaType = String(self.payloadType.suffix(from: start))
            if self.payloadType.beginsWith("image/") {
                ret = UIImage(data: myData)
            } else if self.payloadType.beginsWith("video/") {
                do {
                    var suffix: String = ""
                    switch mediaType {
                    case "mp4", "m4v":
                        suffix = ".m4v"
                        
                    case "avi":
                        suffix = ".avi"
                        
                    case "mov":
                        suffix = ".mov"
                        
                    default:
                        ret = myData
                    }
                    
                    if !suffix.isEmpty {
                        // We create a path to a unique temporary file to grab the media.
                        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString + suffix)
                        // Store the media in the temp file.
                        try myData.write(to: url, options: .atomic)
                        let options = [AVURLAssetPreferPreciseDurationAndTimingKey: true]
                        let asset = AVURLAsset(url: url, options: options)
                        ret = asset
                    }
                } catch let error {
                    #if DEBUG
                    print("Error Encoding AV Media!: \(error)!")
                    #endif
                    NSLog("Error Encoding AV Media: %@", error._domain)
                }
            } else if self.payloadType.beginsWith("text/") {
                switch mediaType {
                case "plain":
                    ret = String(data: myData, encoding: .utf8)
                    
                default:
                    ret = myData
                }
            } else {
                switch mediaType {
                case "pdf":
                    ret = PDFDocument(data: myData)
                    
                default:
                    ret = myData
                }
            }
        }
        
        return ret
    }
}
