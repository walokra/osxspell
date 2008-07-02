//
//  VoikkoSpellService.h
//  VoikkoSpellService
//
//  Copyright 2006 - 2008 Harri Pitkanen. License: GPL
//

#import <Cocoa/Cocoa.h>
#import <Foundation/NSSpellServer.h>


@interface VoikkoSpellService : NSObject {

}
- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language
                                                    wordCount:(int *)wordCount countOnly:(BOOL)countOnly;

- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word
                                                 inLanguage:(NSString *)language;
@end
