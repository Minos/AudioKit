// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation

public class AKBrownianNoiseAudioUnit: AKGeneratorAudioUnitBase {

    func setParameter(_ address: AKBrownianNoiseParameter, value: Double) {
        setParameterWithAddress(address.rawValue, value: Float(value))
    }

    func setParameterImmediately(_ address: AKBrownianNoiseParameter, value: Double) {
        setParameterImmediatelyWithAddress(address.rawValue, value: Float(value))
    }

    var amplitude: Double = AKBrownianNoise.defaultAmplitude {
        didSet { setParameter(.amplitude, value: amplitude) }
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    public override func createDSP() -> AKDSPRef {
        return createBrownianNoiseDSP()
    }

    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let amplitude = AUParameter(
            identifier: "amplitude",
            name: "Amplitude",
            address: AKBrownianNoiseParameter.amplitude.rawValue,
            range: AKBrownianNoise.amplitudeRange,
            unit: .generic,
            flags: .default)

        setParameterTree(AUParameterTree(children: [amplitude]))
        amplitude.value = Float(AKBrownianNoise.defaultAmplitude)
    }

    public override var canProcessInPlace: Bool { return true }

}
