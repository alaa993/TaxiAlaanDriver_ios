//
//  LocalizeHelper.h
//  Prestashop
//
//  Created by Thiruvadisamy on 20/06/15.
//  Copyright (c) 2015 eGrove System Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LocalizedString(key) [[LocalizeHelper sharedLocalSystem] localizedStringForKey:(key)]

// "language" can be (for american english): "en", "en-US", "english". Analogous for other languages.
#define LocalizationSetLanguage(language) [[LocalizeHelper sharedLocalSystem] setLanguage:(language)]

@interface LocalizeHelper : NSObject
// a singleton:
+ (LocalizeHelper*) sharedLocalSystem;

// this gets the string localized:
- (NSString*) localizedStringForKey:(NSString*) key;

//set a new language:
- (void) setLanguage:(NSString*) lang;




@end
