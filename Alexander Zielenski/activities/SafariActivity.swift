// Swift port of TUSafariActivity
// Copyright (c) 2012 ThinkUltimate (http://thinkultimate.com).
//    http://github.com/davbeck/TUSafariActivity
//    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//    •	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    •	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import UIKit

class SafariActivity: UIActivity {
    var url: NSURL?
    override func activityType() -> String? {
        return "com.alexzielenski.activity.open_in_safari";
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "Safari")
    }
    
    override func activityTitle() -> String? {
        return "Open in Safari"
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for obj in activityItems {
            if obj is NSURL {
                return true
            }
        }
        
        return false;
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for obj in activityItems {
            if obj is NSURL {
                url = obj as? NSURL
                return
            }
        }
    }
    
    override func performActivity() {
        var done = false
        if let url = url {
            done = UIApplication.sharedApplication().openURL(url)
        }
        
        activityDidFinish(done)
    }
}
