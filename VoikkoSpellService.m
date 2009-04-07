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

#import <objc/objc-runtime.h>
#import "VoikkoSpellService.h"
#import <libvoikko/voikko.h>

int voikko_handle;

@implementation VoikkoSpellService

bool voikkoCheckWord(NSString * word) {
	if (voikko_spell_cstr(voikko_handle, [word cStringUsingEncoding:NSUTF8StringEncoding])) return TRUE;
	else return FALSE;
}

- (NSRange)spellServer:(NSSpellServer *)sender findMisspelledWordInString: (NSString*)stringToCheck language: (NSString*)language
                                                    wordCount: (int*)wordCount countOnly: (BOOL)countOnly {
	const char * cstr = [stringToCheck cStringUsingEncoding:NSUTF8StringEncoding];
	const size_t clen = strlen(cstr);
	size_t cstart = 0;
	size_t ustart = 0;
	size_t utokenlen;
	while (1) {
		enum voikko_token_type t = voikko_next_token_cstr(voikko_handle, cstr + cstart, clen - cstart, &utokenlen);
		NSString * token = [stringToCheck substringWithRange:NSMakeRange(ustart, utokenlen)];
		size_t ctokenlen = strlen([token UTF8String]);
		if (t == TOKEN_NONE) break;
		if (t == TOKEN_WORD) {
			if (!voikkoCheckWord(token))
				return NSMakeRange(ustart, utokenlen);
		}
		ustart += utokenlen;
		cstart += ctokenlen;
	}
	return NSMakeRange(NSNotFound , 0);
}

- (NSArray *)spellServer:(NSSpellServer *)sender suggestGuessesForWord:(NSString *)word
                                                 inLanguage:(NSString *)language {
	const char * cstr = [word cStringUsingEncoding:NSUTF8StringEncoding];
	char ** suggestions = voikko_suggest_cstr(voikko_handle, cstr);
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

/* Grammar checking not available before Mac OS X 10.5. */
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4
- (NSRange)spellServer:(NSSpellServer *)sender checkGrammarInString:(NSString *)string language:(NSString *)language
                                               details:(NSArray **)outDetails {
	const char * cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
	if (!cstr) return NSMakeRange(NSNotFound, 0);
	const size_t length = strlen(cstr);
	voikko_grammar_error ge = voikko_next_grammar_error_cstr(voikko_handle, cstr, length, 0);
	if (ge.error_code == 0) return NSMakeRange(NSNotFound, 0);
	NSArray * keys = [NSArray arrayWithObjects:NSGrammarRange, NSGrammarUserDescription, NSGrammarCorrections, nil];
	NSString * ra = NSStringFromRange(NSMakeRange(ge.startpos, ge.errorlen));
	NSString * descr = [NSString stringWithUTF8String:voikko_error_message_cstr(ge.error_code, "fi_FI")];
	NSArray * objects = [NSArray arrayWithObjects:ra, descr, [NSArray arrayWithObjects:nil], nil];
	NSDictionary * dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	*outDetails = [NSArray arrayWithObjects:dictionary];
	return NSMakeRange(ge.startpos, ge.errorlen);
}
#endif // MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4

@end

int main() {
	if (voikko_init(&voikko_handle, "fi_FI", 0)) {
		fprintf(stderr, "voikko_init failed\n");
		exit(1);
	}
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	voikko_set_bool_option(voikko_handle, VOIKKO_OPT_IGNORE_DOT, 1);
	voikko_set_bool_option(voikko_handle, VOIKKO_OPT_IGNORE_NUMBERS, 1);
	NSSpellServer *aServer = [[NSSpellServer alloc] init];
	if (!aServer) {
		fprintf(stderr, "Could not create NSSpellServer!\n");
		exit(1);
	}
	VoikkoSpellService *voikkoService = [[VoikkoSpellService alloc] init];
	if ([aServer registerLanguage:@"fi_FI" byVendor:@"Voikko"]) {
		[aServer setDelegate:voikkoService];
		[aServer run];
		fprintf(stderr, "Voikko spell server died!\n");
	}
	else {
		fprintf(stderr, "Voikko cannot be used for this language.\n");
	}
	[pool release];
}

