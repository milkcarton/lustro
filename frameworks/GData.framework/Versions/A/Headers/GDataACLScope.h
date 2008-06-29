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
//  GDataScope.h
//

#import "GDataObject.h"

#undef _EXTERN
#undef _INITIALIZE_AS
#ifdef GDATAACLSCOPE_DEFINE_GLOBALS
#define _EXTERN 
#define _INITIALIZE_AS(x) =x
#else
#define _EXTERN extern
#define _INITIALIZE_AS(x)
#endif

_EXTERN NSString* kGDataScopeTypeUser    _INITIALIZE_AS(@"user");
_EXTERN NSString* kGDataScopeTypeDomain  _INITIALIZE_AS(@"domain");
_EXTERN NSString* kGDataScopeTypeDefault _INITIALIZE_AS(@"default");


// an element with type and value attributes, as in
//  <gAcl:scope type='user' value='user@gmail.com'></gAcl:scope>
@interface GDataACLScope : GDataObject <NSCopying, GDataExtension> {
  NSString *value_;
  NSString *type_;
}

+ (GDataACLScope *)scopeWithType:(NSString *)type value:(NSString *)value;

- (id)initWithXMLElement:(NSXMLElement *)element
                  parent:(GDataObject *)parent;

- (NSXMLElement *)XMLElement;

- (NSString *)value;
- (void)setValue:(NSString *)str;

- (NSString *)type;
- (void)setType:(NSString *)str;
@end

