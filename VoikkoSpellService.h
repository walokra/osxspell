//
//  VoikkoSpellService.h
//  VoikkoSpellService
//
//  Copyright 2006 Harri Pitkanen. License: GPL
//

#import <Cocoa/Cocoa.h>
#import <Foundation/NSSpellServer.h>


@interface VoikkoSpellService : NSObject {

}

- (NSRange) spellServer:findMisspelledWordInString: (NSString*)stringToCheck language: (NSString*)language
                                                    wordCount: (int*)wordCount countOnly: (BOOL)countOnly;


@end
