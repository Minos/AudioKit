// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#ifndef AKSoulDSPBase_hpp
#define AKSoulDSPBase_hpp

#import "AKDSPBase.hpp"

template<typename SoulPatchType>
class AKSoulDSPBase : public AKDSPBase {

public:
    SoulPatchType patch;
    
    std::vector<typename SoulPatchType::MIDIMessage> midiMessages;
    std::vector<typename SoulPatchType::ParameterProperties> properties;
    
    AKSoulDSPBase() {
        // Reserve space for MIDI messages so we don't have to allocate.
        midiMessages.reserve(1024);
        properties = patch.getParameterProperties();
    }
    
    void setParameter(AUParameterAddress address, AUValue value) {
        if(address < properties.size()) {
            properties[address].setValue(value);
        }
    }
    
    void init(int channelCount, double sampleRate) override {
        // I'm not sure what sessionID is for.
        patch.init(sampleRate, /*sessionID*/ 0);
    }
    
    void reset() override {
        patch.reset();
    }
    
    void handleMIDIEvent(AUMIDIEvent const& midiEvent) override {
        typename SoulPatchType::MIDIMessage message;
        message.frameIndex = 0;
        message.byte0 = midiEvent.data[0];
        message.byte1 = midiEvent.data[1];
        message.byte2 = midiEvent.data[2];
        midiMessages.push_back(message);
    }
    
    // Need to override this since it's pure virtual.
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override {
        
        // Zero output channels.
        for(int channel=0; channel<channelCount; ++channel) {
            float* outputChannel = ((float *)outputBufferList->mBuffers[channel].mData) + bufferOffset;
            std::fill(outputChannel, outputChannel+frameCount, 0.0f);
        }
        
        typename SoulPatchType::template RenderContext<float> context;
        
        context.numFrames = frameCount;
        context.inputChannels[0] = ((const float *)inputBufferLists[0]->mBuffers[0].mData) + bufferOffset;
        context.outputChannels[0] = ((float *)outputBufferList->mBuffers[0].mData) + bufferOffset;
        context.incomingMIDI.messages = midiMessages.data();
        context.incomingMIDI.numMessages = (uint32_t) midiMessages.size();
        
        patch.render(context);
        
        midiMessages.clear();
        
    }
    
};

#endif /* AKSoulDSPBase_hpp */
