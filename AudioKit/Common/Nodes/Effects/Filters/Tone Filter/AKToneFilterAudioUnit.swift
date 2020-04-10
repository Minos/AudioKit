// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation

public class AKToneFilterAudioUnit: AKAudioUnitBase {

    func setParameter(_ address: AKToneFilterParameter, value: Double) {
        setParameterWithAddress(address.rawValue, value: Float(value))
    }

    func setParameterImmediately(_ address: AKToneFilterParameter, value: Double) {
        setParameterImmediatelyWithAddress(address.rawValue, value: Float(value))
    }

    var halfPowerPoint: Double = AKToneFilter.defaultHalfPowerPoint {
        didSet { setParameter(.halfPowerPoint, value: halfPowerPoint) }
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    public override func createDSP() -> AKDSPRef {
        return createToneFilterDSP()
    }

    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let halfPowerPoint = AUParameter(
            identifier: "halfPowerPoint",
            name: "Half-Power Point (Hz)",
            address: AKToneFilterParameter.halfPowerPoint.rawValue,
            range: AKToneFilter.halfPowerPointRange,
            unit: .hertz,
            flags: .default)

        setParameterTree(AUParameterTree(children: [halfPowerPoint]))
        halfPowerPoint.value = Float(AKToneFilter.defaultHalfPowerPoint)
    }

    public override var canProcessInPlace: Bool { return true }

}
