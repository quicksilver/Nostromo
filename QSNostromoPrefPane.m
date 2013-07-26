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
	themes = [[NSArray alloc] initWithObjects:@"Nostromo Default", @"Shiny", @"Solarized Light", @"The Hulk", nil];
	[themePicker removeAllItems];
	[themePicker addItemsWithTitles:themes];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *fontData = [defaults objectForKey:@"NostromoInterfaceFont"];
    if (fontData) {
        interfaceFont = [NSUnarchiver unarchiveObjectWithData:fontData];
    }
    if (!interfaceFont) {
        interfaceFont = [NSFont systemFontOfSize:34];
    }
    [interfaceFont retain];
    [self updateFontSelection];
}

- (void)dealloc
{
    [themes release];
    [super dealloc];
}

- (IBAction)setNostromoTheme:(id)sender {
    // load colors from a file and set them in Quicksilver's preferences
	NSString *themeKey = [[[themePicker selectedItem] title] stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *themePath = [NSString stringWithFormat:@"Contents/Resources/%@.plist", themeKey];
	//NSLog(@"setting theme using plist: %@", [themes objectForKey:themeKey]);
    NSDictionary *nostromoColors = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle bundleWithIdentifier:@"com.qsapp.Quicksilver.NostromoInterface"] bundlePath] stringByAppendingPathComponent:themePath]];
	if (nostromoColors) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		for (NSString *colorKey in [nostromoColors allKeys]) {
			[defaults setObject:[nostromoColors objectForKey:colorKey] forKey:colorKey];
		}
		[defaults synchronize];
	} else {
		NSBeep();
	}
}

- (void)updateFontSelection
{
    [fontDisplay setStringValue:[NSString stringWithFormat:@"%@ %.1f", [interfaceFont fontName], [interfaceFont pointSize]]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSArchiver archivedDataWithRootObject:interfaceFont] forKey:@"NostromoInterfaceFont"];
    [[[NSApp delegate] interfaceController] setFonts];
}


- (void)setInterfaceFont:(NSFont *)font
{
    NSFont *newFont = [font retain];
    [interfaceFont release];
    interfaceFont = newFont;
}

- (IBAction)selectInterfaceFont:(id)sender {
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setSelectedFont:interfaceFont isMultiple:NO];
    [fontManager orderFrontFontPanel:self];
}

- (void)changeFont:(id)sender
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [self setInterfaceFont:[fontManager convertFont:[fontManager selectedFont]]];
    [self updateFontSelection];
}

@end
