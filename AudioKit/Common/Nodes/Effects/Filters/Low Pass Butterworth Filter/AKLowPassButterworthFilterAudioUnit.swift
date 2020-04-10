// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation

public class AKLowPassButterworthFilterAudioUnit: AKAudioUnitBase {

    func setParameter(_ address: AKLowPassButterworthFilterParameter, value: Double) {
        setParameterWithAddress(address.rawValue, value: Float(value))
    }

    func setParameterImmediately(_ address: AKLowPassButterworthFilterParameter, value: Double) {
        setParameterImmediatelyWithAddress(address.rawValue, value: Float(value))
    }

    var cutoffFrequency: Double = AKLowPassButterworthFilter.defaultCutoffFrequency {
        didSet { setParameter(.cutoffFrequency, value: cutoffFrequency) }
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    public override func createDSP() -> AKDSPRef {
        return createLowPassButterworthFilterDSP()
    }

    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let cutoffFrequency = AUParameter(
            identifier: "cutoffFrequency",
            name: "Cutoff Frequency (Hz)",
            address: AKLowPassButterworthFilterParameter.cutoffFrequency.rawValue,
            range: AKLowPassButterworthFilter.cutoffFrequencyRange,
            unit: .hertz,
            flags: .default)

        setParameterTree(AUParameterTree(children: [cutoffFrequency]))
        cutoffFrequency.value = Float(AKLowPassButterworthFilter.defaultCutoffFrequency)
    }

    public override var canProcessInPlace: Bool { return true }

}
