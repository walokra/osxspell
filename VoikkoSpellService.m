//
//  VoikkoSpellService.m
//  VoikkoSpellService
//
//  Copyright 2006 Harri Pitkanen. License: GPL
//

#import <objc/objc-runtime.h>
#import "VoikkoSpellService.h"


@implementation VoikkoSpellService

- (NSRange) spellServer:findMisspelledWordInString: (NSString*)stringToCheck language: (NSString*)language
                                                    wordCount: (int*)wordCount countOnly: (BOOL)countOnly {


}
@end

int main() {
	NSSpellServer *aServer = [[NSSpellServer alloc] init];
	if (!aServer) {
		fprintf(stderr, "Could not create NSSpellServer!\n");
		exit(1);
	}
	[aServer setDelegate:[[VoikkoSpellService alloc] init]];
	[aServer run];
	NSString * language = @"Finnish";
	NSString * vendor = @"Voikko";
	if ([aServer registerLanguage:language byVendor:vendor]) {
		
		[aServer run];
		fprintf(stderr, "Voikko spell server died!\n");
	}
	else {
		fprintf(stderr, "Voikko cannot be used for this language.\n");
	}
}

