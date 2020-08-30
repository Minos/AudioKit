// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit

class ReverberateWithCostelloTests: AKTestCase2 {

    override func setUp() {
        super.setUp()
        duration = 1.0
    }

    func testDefault() {
        output = AKOperationEffect(input) { $0.reverberateWithCostello() }
        AKTest()
    }

}
