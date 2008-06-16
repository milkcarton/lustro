/*
 Copyright (c) 2008 Jelle Vandebeeck, Simon Schoeters
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 Created by Jelle Vandebeeck on 2008.05.21.
*/

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>

// Returned when exporting.
typedef enum {
	kExportSuccess = 0,
	kExportWarning = 1,
	kExportError   = 2
} kExportStatus;

@interface AddressBookExport : NSObject {
	id delegate;					// The delegate object.
	
	@protected ABAddressBook *addressBook;		// The addressbook that contains the contacts to export.
	@protected int numberExported;				// The number of contacts exported.
	@protected BOOL company;					// Is the exported contact a company?
}

+ (NSString *)cleanLabel:(NSString *)label;						// Cleans mail labels like work, private, etc. as Address Book adds strange symbols before and after the labels.

- (int)export;													// Export the contacts.

// Delegate methods.
- (void)addSuccessMessage:(NSString *)message;					// Notifies the delegate that a success message was received.
- (void)addWarningMessage:(NSString *)message;					// Notifies the delegate that a warning message was received.
- (void)addErrorMessage:(NSString *)message;					// Notifies the delegate that an error message was received.

@property (retain) id delegate;
@property (retain) ABAddressBook *addressBook;
@property int numberExported;
@property BOOL company;
@end

#pragma mark -

@interface AddressBookExport (AbstractMethods)
- (BOOL)initialize;													// Set everything ready to import. (returns false when error occurs)
- (BOOL)finalize;													// Set everything when importing is done. (returns false when error occurs)
- (BOOL)exportFirstName:(NSString *)firstName;						// Export first name. (returns false when warning or error occurs)
- (BOOL)exportLastName:(NSString *)lastName;						// Export last name. (returns false when warning or error occurs)
- (BOOL)exportFirstNamePhonetic:(NSString *)firstNamePhonetic;		// Export first name phonetic. (returns false when warning or error occurs)
- (BOOL)exportLastNamePhonetic:(NSString *)lastNamePhonetic;		// Export last name phonetic. (returns false when warning or error occurs)
- (BOOL)exportBirthDay:(NSCalendarDate *)birthDay;					// Export birthdate. (returns false when warning or error occurs)
- (BOOL)exportOrganization:(NSString *)organization;				// Export organization. (returns false when warning or error occurs)
- (BOOL)exportDepartment:(NSString *)department;					// Export department. (returns false when warning or error occurs)
- (BOOL)exportJobTitle:(NSString *)jobTitle;						// Export jobtitle. (returns false when warning or error occurs)
- (BOOL)exportURLs:(ABMultiValue *)URLs;							// Export URL's. (returns false when warning or error occurs)
- (BOOL)exportCalendarURLs:(ABMultiValue *)calendarURLs;			// Export calendar URI's. (returns false when warning or error occurs)
- (BOOL)exportEmails:(ABMultiValue *)emails;						// Export emails. (returns false when warning or error occurs)
- (BOOL)exportAddresses:(ABMultiValue *)addresses;					// Export addresses. (returns false when warning or error occurs)
- (BOOL)exportPhones:(ABMultiValue *)phones;						// Export phones. (returns false when warning or error occurs)
- (BOOL)exportAIMAddresses:(ABMultiValue *)AIMAddresses;			// Export AIM addresses. (returns false when warning or error occurs)
- (BOOL)exportJabberAddresses:(ABMultiValue *)jabberAddresses;		// Export jabber addresses. (returns false when warning or error occurs)
- (BOOL)exportMSNAddresses:(ABMultiValue *)MSNAddresses;			// Export MSN addresses. (returns false when warning or error occurs)
- (BOOL)exportYahooAddresses:(ABMultiValue *)yahooAddresses;		// Export Yahoo addresses. (returns false when warning or error occurs)
- (BOOL)exportICQAddresses:(ABMultiValue *)ICQAddresses;			// Export ICQ addresses. (returns false when warning or error occurs)
- (BOOL)exportNote:(NSString *)note;								// Export note. (returns false when warning or error occurs)
- (BOOL)exportMiddleName:(NSString *)middleName;					// Export middle name. (returns false when warning or error occurs)
- (BOOL)exportMiddleNamePhonetic:(NSString *)middleNamePhonetic;	// Export middle name phonetic. (returns false when warning or error occurs)
- (BOOL)exportTitle:(NSString *)title;								// Export title. (returns false when warning or error occurs)
- (BOOL)exportSuffix:(NSString *)suffix;							// Export suffix. (returns false when warning or error occurs)
- (BOOL)exportNickName:(NSString *)nickName;						// Export nickname. (returns false when warning or error occurs)
- (BOOL)exportMaidenName:(NSString *)maidenName;					// Export maiden name. (returns false when warning or error occurs)
- (BOOL)exportOtherDates:(ABMultiValue *)otherDates;				// Export other dates. (returns false when warning or error occurs)
- (BOOL)exportRelatedNames:(ABMultiValue *)relatedNames;			// Export related names. (returns false when warning or error occurs)
- (BOOL)finalizePerson;												// Executed at the end of a ABPerson.
@end