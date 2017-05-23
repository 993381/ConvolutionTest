//
//  ConvolutionUnitAudioUnit.m
//  ConvolutionUnit
//
//  Created by armen karamian on 5/21/17.
//  Copyright © 2017 armen karamian. All rights reserved.
//

#import "ConvolutionUnitAudioUnit.h"
#import "BufferedAudioBus.hpp"
#import <AVFoundation/AVFoundation.h>

// Define parameter addresses.
const AudioUnitParameterID myParam1 = 0;

@interface ConvolutionUnitAudioUnit ()

@property AUAudioUnitBus *outputBus;
@property AUAudioUnitBusArray *inputBusArray;
@property AUAudioUnitBusArray *outputBusArray;
@property (nonatomic, readwrite) AUParameterTree *parameterTree;

@end


@implementation ConvolutionUnitAudioUnit
{
	BufferedInputBus _inputBus;
}

@synthesize parameterTree = _parameterTree;

- (instancetype)initWithComponentDescription:(AudioComponentDescription)componentDescription
									 options:(AudioComponentInstantiationOptions)options
									   error:(NSError **)outError
{
    self = [super initWithComponentDescription:componentDescription
									   options:options
										 error:outError];
    if (self == nil) { return nil; }
	
	
	AVAudioFormat *defaultFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32  sampleRate:44100 channels:2 interleaved:false];
	
	_inputBus.init(defaultFormat, 8);
	_outputBus = [[AUAudioUnitBus alloc] initWithFormat:defaultFormat error:nil];
	
		// Create the input and output bus arrays.
	_inputBusArray  = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeInput busses: @[_inputBus.bus]];
	_outputBusArray = [[AUAudioUnitBusArray alloc] initWithAudioUnit:self busType:AUAudioUnitBusTypeOutput busses: @[_outputBus]];
	
	self.maximumFramesToRender = 512;
    
    return self;
}

#pragma mark - AUAudioUnit Overrides

// If an audio unit has input, an audio unit's audio input connection points.
// Subclassers must override this property getter and should return the same object every time.
// See sample code.
- (AUAudioUnitBusArray *)inputBusses
{
#warning implementation must return non-nil AUAudioUnitBusArray
    return _inputBusArray;
}

// An audio unit's audio output connection points.
// Subclassers must override this property getter and should return the same object every time.
// See sample code.
- (AUAudioUnitBusArray *)outputBusses
{
#warning implementation must return non-nil AUAudioUnitBusArray
    return _outputBusArray;
}

// Allocate resources required to render.
// Subclassers should call the superclass implementation.
- (BOOL)allocateRenderResourcesAndReturnError:(NSError **)outError
{
    if (![super allocateRenderResourcesAndReturnError:outError])
	{
        return NO;
    }
    
    // Validate that the bus formats are compatible.
    // Allocate your resources.
    
    return YES;
}

// Deallocate resources allocated in allocateRenderResourcesAndReturnError:
// Subclassers should call the superclass implementation.
- (void) deallocateRenderResources
{
    // Deallocate your resources.
    [super deallocateRenderResources];
}

-(bool) canPerformInput
{
	return true;
}

#pragma mark - AUAudioUnit (AUAudioUnitImplementation)

// Block which subclassers must provide to implement rendering.
- (AUInternalRenderBlock)internalRenderBlock
{
    // Capture in locals to avoid ObjC member lookups. If "self" is captured in render, we're doing it wrong. See sample code.
    
    return ^AUAudioUnitStatus(AudioUnitRenderActionFlags *actionFlags,
							  const AudioTimeStamp *timestamp,
							  AVAudioFrameCount frameCount,
							  NSInteger outputBusNumber,
							  AudioBufferList *outputData,
							  const AURenderEvent *realtimeEventListHead,
							  AURenderPullInputBlock pullInputBlock)
	{
        // Do event handling and signal processing here.
        
        return noErr;
    };
}

@end

