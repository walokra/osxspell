//
//  VoikkoSpellService.m
//  VoikkoSpellService
//
//  Copyright 2006 Harri Pitkanen. License: GPL
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
	size_t i;
	size_t strlen = [stringToCheck length];
	size_t word_start = 0;
	size_t word_length;
	for (i = 0; i < strlen; i++) {
		if ([stringToCheck characterAtIndex:i] == ' ') {
			if (word_start + 1 >= i) {
				word_start = i + 1;
				continue;
			}
			if ([stringToCheck characterAtIndex:(i-1)] == ',' ||
			    [stringToCheck characterAtIndex:(i-1)] == '?' ||
				[stringToCheck characterAtIndex:(i-1)] == '!' ||
				[stringToCheck characterAtIndex:(i-1)] == '"' ||
				[stringToCheck characterAtIndex:(i-1)] == '\'') word_length = i - word_start - 1;
			else word_length = i - word_start;
			// We have a real word to be checked
			if (!voikkoCheckWord([stringToCheck substringWithRange:NSMakeRange(word_start, word_length)]))
				return NSMakeRange(word_start, word_length);
			word_start = i + 1;
		}
	}
	if (word_start + 1 < strlen) {
		if ([stringToCheck characterAtIndex:(strlen-1)] == ','||
			    [stringToCheck characterAtIndex:(i-1)] == '?' ||
				[stringToCheck characterAtIndex:(i-1)] == '!' ||
				[stringToCheck characterAtIndex:(i-1)] == '"' ||
				[stringToCheck characterAtIndex:(i-1)] == '\'') word_length = strlen - word_start - 1;
		else word_length = i - word_start;
		if (!voikkoCheckWord([stringToCheck substringWithRange:NSMakeRange(word_start, word_length)]))
			return NSMakeRange(word_start, word_length);
	}
	return NSMakeRange(NSNotFound , 0);
}
@end

int main() {
	if (voikko_init(&voikko_handle, "fi_FI", 0)) {
		fprintf(stderr, "voikko_init failed\n");
		exit(1);
	}
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
}

