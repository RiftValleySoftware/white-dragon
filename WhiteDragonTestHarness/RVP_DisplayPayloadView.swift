/***************************************************************************************************************************/
/**
    © Copyright 2018, Little Green Viper Software Development LLC.
    
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
    
    Little Green Viper Software Development: https://littlegreenviper.com
*/

import UIKit
import AVKit
import PDFKit
import WhiteDragon

class RVP_DisplayPayloadView: UIView, AVAudioPlayerDelegate {
    private var _observer = false
    var myController: RVP_DisplayResultsBaseScreenViewController!
    var myVideoPlayer: AVPlayer?
    var myAudioPlayer: AVAudioPlayer?
    var myPlayPauseButton: UIButton?
    let buttonStrings = ["PLAY", "PAUSE"]

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /* ################################################################## */
    /**
     */
    func applyConstraints(thisElement inThisElement: UIView, height inHeight: CGFloat) {
        var previousView: UIView!
        
        if !self.subviews.isEmpty {
            previousView = self.subviews.last
        }
        
        self.addSubview(inThisElement)
        inThisElement.translatesAutoresizingMaskIntoConstraints = false
        
        if nil != previousView {
            self.addConstraints([
                NSLayoutConstraint(item: inThisElement,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: previousView,
                                   attribute: .bottom,
                                   multiplier: 1.0,
                                   constant: 4)])
        } else {
            self.addConstraints([
                NSLayoutConstraint(item: inThisElement,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .top,
                                   multiplier: 1.0,
                                   constant: 0)])
        }
        
        self.addConstraints([
            NSLayoutConstraint(item: inThisElement,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: inThisElement,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0)])
        
        if 0 < inHeight {
            self.addConstraints([
                NSLayoutConstraint(item: inThisElement,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1.0,
                                   constant: inHeight)])
        }
    }

    /* ################################################################## */
    /**
     */
    func setPlayButtonText() {
        if let playPauseButton = self.myPlayPauseButton {
            if let player = self.myVideoPlayer {
                playPauseButton.setTitle(((player.rate > 0) ? self.buttonStrings[1] : self.buttonStrings[0]), for: .normal)
            } else if let player = self.myAudioPlayer {
                playPauseButton.setTitle((player.isPlaying ? self.buttonStrings[1] : self.buttonStrings[0]), for: .normal)
            }
        }
    }

    /* ################################################################## */
    /**
     */
    func addPayloadHandler(_ inPayload: RVP_Cocoa_SDK_Payload) {
        self.myVideoPlayer = nil
        self.myAudioPlayer = nil
        
        if let payload = inPayload.payloadResolved {
            var displayItem: UIView!
            var aspect: CGFloat = 0
            var height: CGFloat = 0
            
            if let payloadAsImage = payload as? UIImage {
                displayItem = UIImageView(image: payloadAsImage)
                aspect = payloadAsImage.size.height / payloadAsImage.size.width
            } else if let payloadAsString = payload as? String {
                let textView = UITextView()
                textView.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0, alpha: 0.15)
                textView.text = payloadAsString
                displayItem = textView
                aspect = 1.0
            } else if let payloadAsPDF = payload as? PDFDocument {
                let pdfView = PDFView()
                pdfView.document = payloadAsPDF
                pdfView.contentMode = .scaleAspectFit
                pdfView.autoScales = true
                displayItem = pdfView
                aspect = 1.0
            } else if let payloadAsMedia = payload as? AVAsset {
                let playerItem = AVPlayerItem(asset: payloadAsMedia)
                let videoTracks = payloadAsMedia.tracks(withMediaType: AVMediaType.video)
                if let track = videoTracks.first {
                    self.myVideoPlayer = AVPlayer(playerItem: playerItem)
                    self._observer = true
                    NotificationCenter.default.addObserver(self, selector: #selector(RVP_DisplayElementView.finished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                    let size = track.naturalSize.applying(track.preferredTransform)
                    aspect = size.height / size.width
                    let myPlayerView = RVP_VideoPlayerView()
                    myPlayerView.player = self.myVideoPlayer
                    displayItem = myPlayerView
                }
            } else if let payloadData = payload as? Data {
                do {
                    try self.myAudioPlayer = AVAudioPlayer(data: payloadData)
                    self.myAudioPlayer?.delegate = self
                } catch {
                    self.myController.setEPUBDocumentFromData(payloadData)
                    let payloadButton = RVP_PayloadButton(payloadData)
                    if inPayload.payloadType == "application/epub+zip" {
                        payloadButton.addTarget(self.myController, action: #selector(RVP_DisplayResultsScreenViewController.displayEPUBButtonHit(_:)), for: .touchUpInside)
                    } else {
                        payloadButton.addTarget(self.myController, action: #selector(RVP_DisplayResultsScreenViewController.displayGenericButtonHit(_:)), for: .touchUpInside)
                    }
                    displayItem = payloadButton
                    height = 30
                }
            }
            
            if nil != displayItem {
                self.applyConstraints(thisElement: displayItem, height: height)
                if 0 < aspect {
                    self.addConstraints([
                        NSLayoutConstraint(item: displayItem,
                                           attribute: .height,
                                           relatedBy: .equal,
                                           toItem: displayItem,
                                           attribute: .width,
                                           multiplier: aspect,
                                           constant: 0.0)])
                }
            }
            
            if nil != self.myVideoPlayer || nil != self.myAudioPlayer {
                self.myPlayPauseButton = UIButton(type: .roundedRect)
                if let playPauseButton = self.myPlayPauseButton {
                    playPauseButton.addTarget(self, action: #selector(RVP_DisplayElementView.playPauseButtonHit(_:)), for: .touchUpInside)
                    self.applyConstraints(thisElement: playPauseButton, height: 30)
                    self.setPlayButtonText()
                }
            }
        }
    }
}
