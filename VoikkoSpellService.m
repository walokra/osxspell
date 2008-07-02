//
//  VoikkoSpellService.m
//  VoikkoSpellService
//
//  Copyright 2006 - 2008 Harri Pitkanen. License: GPL
//

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
	NSMutableArray * arr = [[NSMutableArray alloc] init];
	char ** s = suggestions;
	while (*s) {
		NSString * ns = [NSString stringWithUTF8String:*s];
		[arr addObject:ns];
		s++;
	}
	voikko_free_suggest_cstr(suggestions);
	return arr;
}

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

