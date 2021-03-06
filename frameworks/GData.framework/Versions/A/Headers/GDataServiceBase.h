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
//  GDataServiceBase.h
//

#import "GDataHTTPFetcher.h"
#import "GDataEntryBase.h"
#import "GDataFeedBase.h"
#import "GDataQuery.h"

#undef _EXTERN
#undef _INITIALIZE_AS
#ifdef GDATASERVICEBASE_DEFINE_GLOBALS
#define _EXTERN 
#define _INITIALIZE_AS(x) =x
#else
#define _EXTERN extern
#define _INITIALIZE_AS(x)
#endif

_EXTERN Class kGDataUseRegisteredClass _INITIALIZE_AS(nil);

_EXTERN NSString* kGDataServiceErrorDomain _INITIALIZE_AS(@"com.google.GDataServiceDomain");

enum {
 kGDataCouldNotConstructObjectError = -100 
};

@class GDataServiceBase;

//
// ticket base class
//
@interface GDataServiceTicketBase : NSObject {
  GDataServiceBase *service_;
  id userData_;
  NSDictionary *surrogates_;
  GDataHTTPFetcher *currentFetcher_; // object or auth fetcher if mid-fetch
  GDataHTTPFetcher *objectFetcher_;
  SEL uploadProgressSelector_;
  BOOL shouldFollowNextLinks_;
  BOOL isRetryEnabled_;
  SEL retrySEL_;
  NSTimeInterval maxRetryInterval_;
  
  GDataObject *postedObject_;
  GDataObject *fetchedObject_;
  GDataFeedBase *accumulatedFeed_;
  NSError *fetchError_;
  BOOL hasCalledCallback_;
}

+ (id)ticketForService:(GDataServiceBase *)service;

- (id)initWithService:(GDataServiceBase *)service;

// if cancelTicket is called, the fetch is stopped if it is in progress,
// the callbacks will not be called, and the ticket will no longer be useful
// (though the client must still release the ticket if it retained the ticket)
- (void)cancelTicket;

- (GDataServiceBase *)service;

- (id)userData;
- (void)setUserData:(id)obj;

- (NSDictionary *)surrogates;
- (void)setSurrogates:(NSDictionary *)dict;

- (GDataHTTPFetcher *)currentFetcher; // object or auth fetcher, if active
- (void)setCurrentFetcher:(GDataHTTPFetcher *)fetcher;

- (GDataHTTPFetcher *)objectFetcher;
- (void)setObjectFetcher:(GDataHTTPFetcher *)fetcher;

- (void)setUploadProgressSelector:(SEL)progressSelector;
- (SEL)uploadProgressSelector;

- (BOOL)shouldFollowNextLinks;
- (void)setShouldFollowNextLinks:(BOOL)flag;

- (BOOL)isRetryEnabled;
- (void)setIsRetryEnabled:(BOOL)flag;

- (SEL)retrySelector;
- (void)setRetrySelector:(SEL)theSel;

- (NSTimeInterval)maxRetryInterval;
- (void)setMaxRetryInterval:(NSTimeInterval)secs;

- (BOOL)hasCalledCallback;
- (void)setHasCalledCallback:(BOOL)flag;

- (void)setPostedObject:(GDataObject *)obj;
- (GDataObject *)postedObject;

- (void)setFetchedObject:(GDataObject *)obj;
- (GDataObject *)fetchedObject;

- (void)setFetchError:(NSError *)error;
- (NSError *)fetchError;

- (void)setAccumulatedFeed:(GDataFeedBase *)feed;
- (GDataFeedBase *)accumulatedFeed;

// accumulateFeed is used by the service to append an incomplete feed
// to the ticket when shouldFollowNextLinks is enabled
- (void)accumulateFeed:(GDataFeedBase *)newFeed;

- (int)statusCode;  // server status from object fetch
@end


//
// service base class
//

@interface GDataServiceBase : NSObject {
  NSString *userAgent_;
  NSMutableDictionary *fetchHistory_;
  NSArray *runLoopModes_;
  
  NSString *username_;
  NSMutableData *password_;
  
  NSString *serviceUserData_; // initial value for userData in future tickets
  NSDictionary *serviceSurrogates_; // initial value for surrogates in future tickets
  
  SEL serviceUploadProgressSelector_; // optional
  
  BOOL isServiceRetryEnabled_;      // user allows auto-retries
  SEL serviceRetrySEL_;             // optional; set with setServiceRetrySelector
  NSTimeInterval serviceMaxRetryInterval_; // default to 600. seconds

  BOOL shouldCacheDatedData_;
  BOOL serviceShouldFollowNextLinks_;
}

// Applications should call setUserAgent: with a string of the form
// CompanyName-AppName-AppVersion (without whitespace or punctuation
// other than dashes and periods)
- (NSString *)userAgent;
- (void)setUserAgent:(NSString *)userAgent;

// Run loop modes are used for scheduling NSURLConnections on 10.5 and later.
//
// The default value, nil, schedules connections using the current run
// loop mode.  To use the service during a modal dialog, be sure to specify
// NSModalPanelRunLoopMode as one of the modes.
- (NSArray *)runLoopModes;
- (void)setRunLoopModes:(NSArray *)modes;
	
// The request user agent includes the library and OS version appended to the
// base userAgent
- (NSString *)requestUserAgent;

// in request, pass nil (for default GET method), POST, PUT, DELETE (though
// PUT and DELETE may be blocked by firewalls.)
- (NSMutableURLRequest *)requestForURL:(NSURL *)url httpMethod:(NSString *)httpMethod;

// finishedSelector has signature like:
//   serviceTicket:(GDataServiceTicketBase *)ticket finishedWithObject:(GDataObject *)object;
// failedSelector has signature like:
//   serviceTicket:(GDataServiceTicketBase *)ticket failedWithError:(NSError *)error

- (GDataServiceTicketBase *)fetchFeedWithURL:(NSURL *)feedURL
                                   feedClass:(Class)feedClass
                                    delegate:(id)delegate
                           didFinishSelector:(SEL)finishedSelector
                             didFailSelector:(SEL)failedSelector;

- (GDataServiceTicketBase *)fetchEntryWithURL:(NSURL *)entryURL
                                   entryClass:(Class)entryClass
                                     delegate:(id)delegate
                            didFinishSelector:(SEL)finishedSelector
                              didFailSelector:(SEL)failedSelector;

- (GDataServiceTicketBase *)fetchEntryByInsertingEntry:(GDataEntryBase *)entryToInsert
                                            forFeedURL:(NSURL *)feedURL
                                              delegate:(id)delegate
                                     didFinishSelector:(SEL)finishedSelector
                                       didFailSelector:(SEL)failedSelector;

- (GDataServiceTicketBase *)fetchEntryByUpdatingEntry:(GDataEntryBase *)entryToUpdate
                                          forEntryURL:(NSURL *)entryURL
                                             delegate:(id)delegate
                                    didFinishSelector:(SEL)finishedSelector
                                      didFailSelector:(SEL)failedSelector;

- (GDataServiceTicketBase *)deleteResourceURL:(NSURL *)resourceEditURL
                                     delegate:(id)delegate
                            didFinishSelector:(SEL)finishedSelector // object parameter will be nil
                              didFailSelector:(SEL)failedSelector;

- (GDataServiceTicketBase *)fetchQuery:(GDataQuery *)query
                             feedClass:(Class)feedClass
                              delegate:(id)delegate
                     didFinishSelector:(SEL)finishedSelector
                       didFailSelector:(SEL)failedSelector;

- (GDataServiceTicketBase *)fetchFeedWithBatchFeed:(GDataFeedBase *)batchFeed
                                        forFeedURL:(NSURL *)feedURL
                                          delegate:(id)delegate
                                 didFinishSelector:(SEL)finishedSelector
                                   didFailSelector:(SEL)failedSelector;

// reset the last modified dates to avoid getting a Not Modified status
// based on prior queries
- (void)clearLastModifiedDates;
  
// Turn on data caching to receive a copy of previously-retrieved objects.
// Otherwise, fetches may return status 304 (No Change) rather than actual data
- (void)setShouldCacheDatedData:(BOOL)flag;
- (BOOL)shouldCacheDatedData;  

// For feed requests, where the feed requires following "next" links to retrieve
// all entries, the service can optionally do the additional fetches using the
// original ticket, calling the client's finish selector only when a complete 
// feed has been obtained.  During the fetch, the feed accumulated so far is
// available from the ticket.  
//
// Note that the final feed may be a combination of multiple partial feeds, 
// so is not exactly a genuine feed. In particular, it will not have a valid
// "self" link, as it does not represent an object with a distinct URL.
//
// Default value is NO.
- (BOOL)serviceShouldFollowNextLinks;
- (void)setServiceShouldFollowNextLinks:(BOOL)flag;

// The service userData becomes the initial value for each future ticket's
// userData.
//
// Since the network transactions may begin before the client has been 
// returned the ticket by the fetch call, it's preferable to call 
// setServiceUserData before the ticket is created rather than call the
// ticket's setUserData:.  Either way, the ticket's userData:
// method will return the value.
- (void)setServiceUserData:(id)userData;
- (id)serviceUserData;

// Set the surrogates to be used for future tickets.  Surrogates are subclasses
// to be used instead of standard classes when creating objects from the XML.
// For example, this code will make the framework generate objects
// using MyCalendarEntrySubclass instead of GDataEntryCalendar and
// MyCalendarEventSubclass instead of GDataEntryCalendarEvent.
//
//  NSDictionary *surrogates = [NSDictionary dictionaryWithObjectsAndKeys:
//    [MyCalendarEntrySubclass class], [GDataEntryCalendar class],
//    [MyCalendarEventSubclass class], [GDataEntryCalendarEvent class],
//    nil];
//  [calendarService setServiceSurrogates:surrogates];
//
- (NSDictionary *)serviceSurrogates;
- (void)setServiceSurrogates:(NSDictionary *)dict;

// The service uploadProgressSelector becomes the initial value for each future
// ticket's uploadProgressSelector.
//
// The optional uploadProgressSelector will be called in the delegate as bytes
// are uploaded to the server.  It should have a signature matching
//
// - (void)inputStream:(GDataProgressMonitorInputStream *)stream 
//   hasDeliveredByteCount:(unsigned long long)numberOfBytesRead 
//        ofTotalByteCount:(unsigned long long)dataLength;
//
// The progress method can obtain the ticket by calling [stream monitorSource];
- (void)setServiceUploadProgressSelector:(SEL)progressSelector;
- (SEL)serviceUploadProgressSelector;


// retrying; see comments on retry support at the top of GDataHTTPFetcher.
- (BOOL)isServiceRetryEnabled;
- (void)setIsServiceRetryEnabled:(BOOL)flag;

// retry selector is optional for retries. 
//
// If present, it should have the signature:
//   -(BOOL)ticket:(GDataServiceTicketBase *)ticket willRetry:(BOOL)suggestedWillRetry forError:(NSError *)error
// and return YES to cause a retry.  Note that unlike the GDataHTTPFetcher retry
// selector, this selector's first argument is a ticket, not a fetcher.
// The current fetcher can be retrived with [ticket currentFetcher]

- (SEL)serviceRetrySelector;
- (void)setServiceRetrySelector:(SEL)theSel;

- (NSTimeInterval)serviceMaxRetryInterval;
- (void)setServiceMaxRetryInterval:(NSTimeInterval)secs;

// credentials
- (void)setUserCredentialsWithUsername:(NSString *)username
                              password:(NSString *)password;
- (NSString *)username;
- (NSString *)password;

// Wait synchronously for fetch to complete (strongly discouraged)
// 
// This just runs the current event loop until the fetch completes
// or the timout limit is reached.  This may discard unexpected events
// that occur while spinning, so it's really not appropriate for use
// in serious applications.
//
// Returns true if an object was successfully fetched.  If the wait
// timed out, returns false and the returned error is nil.
//
// The returned object or error, if any, will be already autoreleased
//
// This routine will likely be removed in some future releases of the library.
- (BOOL)waitForTicket:(GDataServiceTicketBase *)ticket
              timeout:(NSTimeInterval)timeoutInSeconds
        fetchedObject:(GDataObject **)outObjectOrNil
                error:(NSError **)outErrorOrNil;  

// internal utilities
- (NSString *)stringByURLEncoding:(NSString *)param;

- (void)addAuthenticationToFetcher:(GDataHTTPFetcher *)fetcher;

- (void)objectFetcher:(GDataHTTPFetcher *)fetcher failedWithStatus:(int)status data:(NSData *)data;

- (NSString *)defaultApplicationIdentifier;

- (NSString *)systemVersionString;

- (BOOL)invokeRetrySelector:(SEL)retrySelector delegate:(id)delegate ticket:(GDataServiceTicketBase *)ticket willRetry:(BOOL)willRetry error:(NSError *)error;

@end

