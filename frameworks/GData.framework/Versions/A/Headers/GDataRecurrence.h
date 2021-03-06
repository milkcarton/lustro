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
//  GDataRecurrence.h
//

#import "GDataObject.h"

// a gd:recurrence, as in
//
//  <gd:recurrence>
//  DTSTART;TZID=America/Los_Angeles:20060314T060000
//  DURATION:PT3600S ...
//  END:DAYLIGHT
//  END:VTIMEZONE
//  </gd:recurrence>
//
// http://code.google.com/apis/gdata/common-elements.html#gdRecurrence
//
// See RFC 2445: http://www.ietf.org/rfc/rfc2445.txt


@interface GDataRecurrence : GDataObject <NSCopying, GDataExtension> {
  NSString *value_;
}

+ (GDataRecurrence *)recurrenceWithString:(NSString *)str;

- (id)initWithXMLElement:(NSXMLElement *)element
                  parent:(GDataObject *)parent;
- (NSXMLElement *)XMLElement;

- (void)setStringValue:(NSString *)str;
- (NSString *)stringValue;
@end

