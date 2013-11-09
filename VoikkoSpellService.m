/* VoikkoSpellService: Finnish spelling and grammar checker service for OS X.
 * Copyright (C) 2006 - 2010 Harri Pitkanen <hatapitk@iki.fi>
 * Copyright (C) 2010 - 2012 Marko Wallin <marko.wallin@iki.fi>
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

#import <objc/objc-runtime.h>
#import "VoikkoSpellService.h"
#import <libvoikko/voikko.h>

@implementation VoikkoSpellService

struct VoikkoHandle * voikkoHandle = 0;

- (id<NSSpellServerDelegate>)init
{
	self = [super init];
}

- (void) dealloc
{
	[super dealloc];
}

bool voikkoCheckWord(NSString * word) {
	if (voikkoSpellCstr(voikkoHandle, [word cStringUsingEncoding:NSUTF8StringEncoding])) return TRUE;
	else return FALSE;
}

- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString: (NSString*)stringToCheck language: (NSString*)language
                                                    wordCount: (int*)wordCount countOnly: (BOOL)countOnly {
	#ifdef DEBUG
		NSLog(@"findMisspelledWordInString called. stringToCheck: %@ \n",stringToCheck);
	#endif
	const char * cstr = [stringToCheck cStringUsingEncoding:NSUTF8StringEncoding];
	const size_t clen = strlen(cstr);
	size_t cstart = 0;
	size_t ustart = 0;
	size_t utokenlen;
	while (1) {
		enum voikko_token_type t = voikkoNextTokenCstr(voikkoHandle, cstr + cstart, clen - cstart, &utokenlen);
		NSString * token = [stringToCheck substringWithRange:NSMakeRange(ustart, utokenlen)];
		size_t ctokenlen = strlen([token UTF8String]);
		if (t == TOKEN_NONE) break;
		if (t == TOKEN_WORD) {
			// if word is in dictionary (voikkoCheckWord) or word is in user dictionary
			if (!voikkoCheckWord(token) && !([sender isWordInUserDictionaries:token caseSensitive:YES]))
				return NSMakeRange(ustart, utokenlen);
		}
		ustart += utokenlen;
		cstart += ctokenlen;
	}
	return NSMakeRange(NSNotFound , 0);
}

- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word
                                                 inLanguage:(NSString *)language {
	#ifdef DEBUG
		NSLog(@"suggestGuessesForWord called. word: %@ \n",word);
	#endif
	const char * cstr = [word cStringUsingEncoding:NSUTF8StringEncoding];
	char ** suggestions = voikkoSuggestCstr(voikkoHandle, cstr);
	if (!suggestions) return 0;
	NSMutableArray * arr = [NSMutableArray array];
	char ** s = suggestions;
	while (*s) {
		NSString * ns = [NSString stringWithUTF8String:*s];
		[arr addObject:ns];
		s++;
	}
	voikko_free_suggest_cstr(suggestions);
	return arr;
}

- (NSRange)spellServer:(NSSpellServer *)sender checkGrammarInString:(NSString *)string language:(NSString *)language
                                               details:(NSArray **)outDetails {
	#ifdef DEBUG
		NSLog(@"checkGrammarInString called. string: %@ \n",string);
	#endif
	const char * cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
	//if (!cstr) return NSMakeRange(NSNotFound, 0);
	
	const size_t clen = strlen(cstr);
	size_t startPos = 0;
	size_t errorLength = 0;
	int skiperrors = 0;
	int vErrorCount = 0; 
	while (clen < 1000000) { // sanity check
		#ifdef DEBUG
			NSLog(@"while loop\n");
		#endif
		struct VoikkoGrammarError * vError = voikkoNextGrammarErrorCstr(voikkoHandle, cstr, clen, 0, vErrorCount++);
		#ifdef DEBUG
			NSLog(@"struct VoikkoGrammarError\n");
		#endif		
		if (!vError) {
			#ifdef DEBUG
				NSLog(@"!vError\n");
			#endif
			break;
		}
		int errorCode = voikkoGetGrammarErrorCode(vError);
		startPos = voikkoGetGrammarErrorStartPos(vError);
		errorLength = voikkoGetGrammarErrorLength(vError);
		#ifdef DEBUG
			NSLog(@"[code=%d, level=0, ", errorCode);
		#endif
	
		if (errorCode == 0) return NSMakeRange(NSNotFound, 0);
	
		#ifdef DEBUG
			NSLog(@"[startpos=%zu, level=0, ", startPos);
			NSLog(@"[errorlen=%zu, level=0, ", errorLength);
		#endif
		
		skiperrors++;
	}
	
	return NSMakeRange(startPos, errorLength);
}

- (NSArray *)spellServer:(NSSpellServer *)sender checkString:(NSString *)stringToCheck offset:(NSUInteger)offset
												types:(NSTextCheckingTypes)checkingTypes options:(NSDictionary *)options 
												orthography:(NSOrthography *)orthography wordCount:(NSInteger *)wordCount {
	#ifdef DEBUG
		NSLog(@"checkString called. stringToCheck: %@\n",stringToCheck);
	#endif
	
	NSMutableArray *result = [NSMutableArray array];
	
	const char * cstr = [stringToCheck cStringUsingEncoding:NSUTF8StringEncoding];
	const size_t clen = strlen(cstr);
	size_t cstart = 0;
	size_t ustart = 0;
	size_t utokenlen;
	while (1) {
		enum voikko_token_type t = voikkoNextTokenCstr(voikkoHandle, cstr + cstart, clen - cstart, &utokenlen);
		NSString * token = [stringToCheck substringWithRange:NSMakeRange(ustart, utokenlen)];
		size_t ctokenlen = strlen([token UTF8String]);
		if (t == TOKEN_NONE) break;
		if (t == TOKEN_WORD) {
			// if word is in dictionary (voikkoCheckWord) or word is in user dictionary
			if (!voikkoCheckWord(token) && !([sender isWordInUserDictionaries:token caseSensitive:YES]))
				[result addObject:[NSTextCheckingResult spellCheckingResultWithRange:NSMakeRange(ustart, utokenlen)]];
		}
		ustart += utokenlen;
		cstart += ctokenlen;
	}
	return(result);
	
 }

/*
// Not yet implemented
- (NSArray *)spellServer:(NSSpellServer *)sender suggestCompletionsForPartialWordRange:(NSRange)range 
				inString:(NSString *)string language:(NSString *)language {
	#ifdef DEBUG
	NSLog(@"VoikkoSpellService. suggestCompletionsForPartialWordRange not yet implemented");
	#endif
	return([NSArray array]);
}
*/

@end

int main(int argc, char **argv) {
		char dictpath[1024], *p;
		strcpy(dictpath, argv[0]);
		if((p = strrchr(dictpath, '/'))) {
				*p = '\0';
		}
	strcat(dictpath, "/../Resources/voikko");
	const char * voikko_error;
	voikkoHandle = voikkoInit(&voikko_error, "fi_FI", dictpath);
	if (voikko_error) {
		fprintf(stderr, "voikko_init_with_path failed (path = %s)\n", dictpath);
		exit(1);
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	voikkoSetBooleanOption(voikkoHandle, VOIKKO_OPT_IGNORE_DOT, 1);
	voikkoSetBooleanOption(voikkoHandle, VOIKKO_OPT_IGNORE_NUMBERS, 1);
	NSSpellServer *aServer = [[[NSSpellServer alloc] init] autorelease];
	NSLog(@"New NSSpellServer instance starting.\n");
	if (!aServer) {
		fprintf(stderr, "Could not create NSSpellServer!\n");
		exit(1);
	}
	VoikkoSpellService *voikkoService = [[[VoikkoSpellService alloc] init] autorelease];
	if ([aServer registerLanguage:@"Finnish" byVendor:@"Voikko"]) {
		NSLog(@"Finnish language registered.\n");
		[aServer setDelegate:voikkoService];
		NSLog(@"Spell server delegate voikkoService allocated.\n");
		[aServer run];
		fprintf(stderr, "Voikko spell server died!\n");
	}
	else {
		fprintf(stderr, "Voikko cannot be used for this language.\n");
	}
	voikkoTerminate(voikkoHandle);
	[pool release];
	
	return 0;
}

