/* Copyright (c) 2008 Google Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

//
//  GDataEntryContact.h
//

#import "GDataEntryBase.h"
#import "GDataOrganization.h"
#import "GDataEmail.h"
#import "GDataIM.h"
#import "GDataPhoneNumber.h"
#import "GDataPostalAddress.h"
#import "GDataCategory.h"

#undef _EXTERN
#undef _INITIALIZE_AS
#ifdef GDATAENTRYCONTACT_DEFINE_GLOBALS
#define _EXTERN 
#define _INITIALIZE_AS(x) =x
#else
#define _EXTERN extern
#define _INITIALIZE_AS(x)
#endif

_EXTERN NSString* kGDataNamespaceContact _INITIALIZE_AS(@"http://schemas.google.com/contact/2008");
_EXTERN NSString* kGDataNamespaceContactPrefix _INITIALIZE_AS(@"gContact");

_EXTERN NSString* kGDataCategoryContact _INITIALIZE_AS(@"http://schemas.google.com/contact/2008#contact");

// rel values
_EXTERN NSString* kGDataContactHome    _INITIALIZE_AS(@"http://schemas.google.com/g/2005#home");
_EXTERN NSString* kGDataContactWork    _INITIALIZE_AS(@"http://schemas.google.com/g/2005#work");
_EXTERN NSString* kGDataContactOther   _INITIALIZE_AS(@"http://schemas.google.com/g/2005#other");

@interface GDataEntryContact : GDataEntryBase {
}

+ (NSDictionary *)contactNamespaces;

+ (GDataEntryContact *)contactEntryWithTitle:(NSString *)title;

// each type of contact data includes convenience methods for getting or
// setting a primary element. 

- (NSArray *)organizations;
- (void)setOrganizations:(NSArray *)array;
- (void)addOrganization:(GDataOrganization *)obj;

- (GDataOrganization *)primaryOrganization;
- (void)setPrimaryOrganization:(GDataOrganization *)obj;

- (NSArray *)emailAddresses;
- (void)setEmailAddresses:(NSArray *)array;
- (void)addEmailAddress:(GDataEmail *)obj;

- (GDataEmail *)primaryEmailAddress;
- (void)setPrimaryEmailAddress:(GDataEmail *)obj;

- (NSArray *)IMAddresses;
- (void)setIMAddresses:(NSArray *)array;
- (void)addIMAddress:(GDataIM *)obj;

- (GDataIM *)primaryIMAddress;
- (void)setPrimaryIMAddress:(GDataIM *)obj;

- (NSArray *)phoneNumbers;
- (void)setPhoneNumbers:(NSArray *)array;
- (void)addPhoneNumber:(GDataPhoneNumber *)obj;

- (GDataPhoneNumber *)primaryPhoneNumber;
- (void)setPrimaryPhoneNumber:(GDataPhoneNumber *)obj;

- (NSArray *)postalAddresses;
- (void)setPostalAddresses:(NSArray *)array;
- (void)addPostalAddress:(GDataPostalAddress *)obj;

- (GDataPostalAddress *)primaryPostalAddress;
- (void)setPrimaryPostalAddress:(GDataPostalAddress *)obj;
@end
