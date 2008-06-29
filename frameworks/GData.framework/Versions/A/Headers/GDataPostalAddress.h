/* Copyright (c) 2007 Google Inc.
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
//  GDataPostalAddress.h
//

#import "GDataObject.h"

// postal address, as in
//  <gd:postalAddress>
//    500 West 45th Street
//    New York, NY 10036
//  </gd:postalAddress>
//
// http://code.google.com/apis/gdata/common-elements.html#gdPostalAddress

@interface GDataPostalAddress : GDataObject <NSCopying, GDataExtension> {
  NSString *label_;
  NSString *value_;
  NSString *rel_;
  BOOL isPrimary_;
}

+ (GDataPostalAddress *)postalAddressWithString:(NSString *)str;

- (id)initWithXMLElement:(NSXMLElement *)element
                  parent:(GDataObject *)parent;

- (NSXMLElement *)XMLElement;

- (NSString *)label;
- (void)setLabel:(NSString *)str;
- (NSString *)stringValue;
- (void)setStringValue:(NSString *)str;
- (NSString *)rel;
- (void)setRel:(NSString *)str;
- (BOOL)isPrimary;
- (void)setIsPrimary:(BOOL)flag;
@end
