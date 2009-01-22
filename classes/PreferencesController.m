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
 
 Created by Simon Schoeters on 2009.01.10.
 */

// TODO Compare preferences with current groups and check if still valid

#import "PreferencesController.h"

@implementation PreferencesController

- (id)init
{
	self = [super init];
	addressBook = [ABAddressBook sharedAddressBook];
	[self loadSelectedGroups];
	return self;
}

- (void)awakeFromNib
{	
	exportGroupSelection = [[NSUserDefaults standardUserDefaults] integerForKey:@"ExportGroupsSelection"];
	if (exportGroupSelection == 1) {
		[groupList setEnabled: YES];
	} else {
		[groupList setEnabled: NO];
	}
}

- (void)loadSelectedGroups
{
	NSDictionary *prefGroups = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"selectedGroups"];
	if (prefGroups != nil) {
		selectedGroups = [prefGroups mutableCopy];
	} else { // Create a new dictionary for with all the Address Book groups, default value set to NO.
		selectedGroups = [[NSMutableDictionary alloc] init];
		NSEnumerator *enumerator = [[addressBook groups] objectEnumerator];
		ABPerson *group;
		while (group = [enumerator nextObject]) {
			[selectedGroups setObject:[NSNumber numberWithInt:NO] forKey:[group valueForProperty:kABGroupNameProperty]];
		}
		[[NSUserDefaults standardUserDefaults] setObject:selectedGroups forKey:@"selectedGroups"];
	}
}

- (IBAction)selectGroups:(id)sender
{
	NSButtonCell *selCell = [sender selectedCell];
	if ([selCell tag] == 1) {
		[groupList setEnabled: YES];
	} else {
		[groupList setEnabled: NO];
	}
}

- (IBAction)changeCellState:(id)sender
{
	NSString *groupName = [[sender selectedCell] title];
	if ([[selectedGroups objectForKey:groupName] intValue] == 1) {
		[selectedGroups setObject:[NSNumber numberWithInt:NO] forKey:groupName];
	} else {
		[selectedGroups setObject:[NSNumber numberWithInt:YES] forKey:groupName];
	}
	[[NSUserDefaults standardUserDefaults] setObject:selectedGroups forKey:@"selectedGroups"];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{	
	NSArray *groups = [addressBook groups];
    return [groups count];
}

// Useless function but needs to be implemented
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
	NSArray *groups = [addressBook groups];
	ABPerson *group = [groups objectAtIndex:row];
	return [group valueForProperty:kABGroupNameProperty];
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{		
	NSArray *groups = [addressBook groups];
	ABPerson *group = [groups objectAtIndex:row];
	NSString *groupName = [group valueForProperty:kABGroupNameProperty];
	[cell setTitle:groupName];
	NSInteger state = [[selectedGroups objectForKey:groupName] intValue];
	[cell setState:state];
}

@end