//
//  QSNostromoPrefPane.m
//  Nostromo
//
//  Created by Rob McBroom on 2012/02/27.
//

#import "QSNostromoPrefPane.h"

@implementation QSNostromoPrefPane

- (void)awakeFromNib
{
	themes = [[NSDictionary alloc] initWithObjectsAndKeys:@"QSNostromoColors.plist", @"Nostromo Default", @"Shiny.plist", @"Shiny", @"SolarizedLight.plist", @"Solarized Light", @"TheHulk.plist", @"The Hulk", nil];
	[themePicker removeAllItems];
	[themePicker addItemsWithTitles:[themes allKeys]];
}

- (void)dealloc
{
    [themes release];
    [super dealloc];
}

- (IBAction)setNostromoTheme:(id)sender {
    // load colors from a file and set them in Quicksilver's preferences
	NSString *themeKey = [[themePicker selectedItem] title];
	NSString *themePath = [NSString stringWithFormat:@"Contents/Resources/%@", [themes objectForKey:themeKey]];
	//NSLog(@"setting theme using plist: %@", [themes objectForKey:themeKey]);
    NSDictionary *nostromoColors = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle bundleWithIdentifier:@"com.qsapp.Quicksilver.NostromoInterface"] bundlePath] stringByAppendingPathComponent:themePath]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *colorKey in [nostromoColors allKeys]) {
        [defaults setObject:[nostromoColors objectForKey:colorKey] forKey:colorKey];
    }
    [defaults synchronize];
}
@end
