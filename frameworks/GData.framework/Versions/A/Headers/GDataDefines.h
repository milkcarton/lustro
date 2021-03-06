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
// GDataDefines.h
//

//
// The developer may choose to define these in the project:
//   #define GDATA_FOUNDATION_ONLY 1     // builds without AppKit or Carbon  
//   #define STRIP_GDATA_FETCH_LOGGING 1 // omit http logging code
//

#if TARGET_OS_ASPEN // iPhone SDK

  #define GDATA_IPHONE 1

#endif

#if GDATA_IPHONE

  #define GDATA_FOUNDATION_ONLY 1

#endif
