// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit
import XCTest

class StringResonatorTests: AKTestCase {

    override func setUp() {
        super.setUp()
        duration = 1.0
    }

    func testDefault() {
        output = AKOperationEffect(input) { input, _ in
            return input.stringResonator()
        }
        AKTestMD5("6b5cfb23bb8fa2e87a4636c1d18be1bb")
    }

}
