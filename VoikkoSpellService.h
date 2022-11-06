/* VoikkoSpellService: Finnish spelling and grammar checker service for OS X.
 * Copyright (C) 2006 - 2010 Harri Pitkanen <hatapitk@iki.fi>
 * Copyright (C) 2010 - 2022 Marko Wallin <marko.wallin@iki.fi>
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

@interface VoikkoSpellService : NSObject<NSSpellServerDelegate> { }

- (id<NSSpellServerDelegate>)init;

- (void) dealloc;

- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString:(NSString *)stringToCheck language:(NSString *)language
                                                    wordCount:(int *)wordCount countOnly:(BOOL)countOnly;

- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word
                                                 inLanguage:(NSString *)language;

- (NSRange)spellServer:(NSSpellServer *)sender checkGrammarInString:(NSString *)string language:(NSString *)language
                                               details:(NSArray **)outDetails;

/* Doesn't work as intended, underlines partial words as incorrect.
- (NSArray *)spellServer:(NSSpellServer *)sender checkString:(NSString *)stringToCheck offset:(NSUInteger)offset
				   types:(NSTextCheckingTypes)checkingTypes options:(NSDictionary *)options 
			 orthography:(NSOrthography *)orthography wordCount:(NSInteger *)wordCount;
*/
/*
// Not yet implemented
- (NSArray *)spellServer:(NSSpellServer *)sender suggestCompletionsForPartialWordRange:(NSRange)range 
				inString:(NSString *)string language:(NSString *)language;
*/
 
@end
