/* VoikkoSpellService: Finnish spelling and grammar checker service for OS X.
 * Copyright (C) 2006 - 2008 Harri Pitkanen <hatapitk@iki.fi>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *****************************************************************************/

#import <Cocoa/Cocoa.h>
#import <Foundation/NSSpellServer.h>

@interface VoikkoSpellService : NSObject { }

- (id)init;

- (void) dealloc;

- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language
                                                    wordCount:(int *)wordCount countOnly:(BOOL)countOnly;

- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word
                                                 inLanguage:(NSString *)language;

/* Grammar checking not available before Mac OS X 10.5. */
/* Current implementation not working
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4
- (NSRange)spellServer:(NSSpellServer *)sender checkGrammarInString:(NSString *)string language:(NSString *)language
                                               details:(NSArray **)outDetails;
#endif // MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4
*/

/* checkString not available before Mac OS X 10.6. */
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
- (NSArray *)spellServer:(NSSpellServer *)sender checkString:(NSString *)stringToCheck offset:(NSUInteger)offset 
				   types:(NSTextCheckingTypes)checkingTypes options:(NSDictionary *)options 
			 orthography:(NSOrthography *)orthography wordCount:(NSInteger *)wordCount;
#endif // MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5

/*
// Not yet implemented
- (NSArray *)spellServer:(NSSpellServer *)sender suggestCompletionsForPartialWordRange:(NSRange)range 
				inString:(NSString *)string language:(NSString *)language;
*/
 
@end
