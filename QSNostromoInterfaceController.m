#import "QSNostromoInterfaceController.h"

@implementation QSNostromoInterfaceController
- (id)init {
    return [self initWithWindowNibName:NSStringFromClass([self class])];
}

- (void)windowDidLoad {
    standardRect = centerRectInRect([[self window] frame], [[NSScreen mainScreen] frame]);
    standardIObjectRect = [iSelector frame];
    heightDifference = NSMinY([aSelector frame]) - NSMinY(standardIObjectRect);
    [super windowDidLoad];
    QSWindow *window = (QSWindow *)[self window];
    [window setLevel:NSPopUpMenuWindowLevel];
    [window setBackgroundColor:[NSColor clearColor]];
    
    [window setHideOffset:NSMakePoint(0, 0)];
    [window setShowOffset:NSMakePoint(0, 0)];
    
    // Effect when showing the interface
    [window setShowEffect:[NSDictionary dictionaryWithObjectsAndKeys:@"QSSlightGrowEffect",@"transformFn",@"show",@"type",[NSNumber numberWithDouble:0.08], @"duration",nil]];
    // Effect when hiding the interface
    [window setHideEffect:[NSDictionary dictionaryWithObjectsAndKeys:@"QSSlightShrinkEffect",@"transformFn",@"hide",@"type",[NSNumber numberWithDouble:0.1], @"duration",nil]];
    // Effect when running a command
    [window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"QSExplodeEffect", @"transformFn", @"hide", @"type", [NSNumber numberWithDouble:0.2], @"duration", nil] forKey:kQSWindowExecEffect];
    // Effect when interface fades
    [window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"hide", @"type", [NSNumber numberWithDouble:0.1], @"duration", nil] forKey:kQSWindowFadeEffect];
    // Effect when user cancels
    [window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"QSVContractEffect", @"transformFn", @"hide", @"type", [NSNumber numberWithDouble:0.2], @"duration", nil, [NSNumber numberWithDouble:0.25] , @"brightnessB", @"QSStandardBrightBlending", @"brightnessFn", nil] forKey:kQSWindowCancelEffect];
    
    [(QSBezelBackgroundView *)[[self window] contentView] setRadius:4.0];
    /* Gloss Types
    QSGlossFlat = 0,            // Flat Highlight.
    QSGlossUpArc = 1,           // Upward Arc.
    QSGlossDownArc = 2,         // Downward Arc.
    QSGlossRisingArc = 3,       // Flat Highlight.
    QSGlossControl = 4,         // Glass Control style. */
    [(QSBezelBackgroundView *)[[self window] contentView] setGlassStyle:QSGlossControl];
    
    [[self window] setFrame:standardRect display:YES];
    
    NSUserDefaultsController *defcon = [NSUserDefaultsController sharedUserDefaultsController];
    NSDictionary *transformer = [NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"];
    [[[self window] contentView] bind:@"color" toObject:defcon withKeyPath:@"values.QSAppearance1B" options:transformer];
    [[self window] bind:@"hasShadow" toObject:defcon withKeyPath:@"values.QSBezelHasShadow" options:nil];
    [commandView bind:@"textColor" toObject:defcon withKeyPath:@"values.QSAppearance1T" options:transformer];
    [menuButtonOverlay bind:@"textColor" toObject:defcon withKeyPath:@"values.QSAppearance1T" options:transformer];
    
    [[self window] setMovableByWindowBackground:YES];
    
    NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
    for(QSSearchObjectView *theControl in theControls) {
        QSObjectCell *theCell = [theControl cell];
        [theCell setAlignment:NSLeftTextAlignment];
        [theCell setImagePosition:NSImageLeft];
        [theControl setPreferredEdge:NSMaxXEdge];
        [theControl setResultsPadding:NSMinX([dSelector frame])];
        [theControl setPreferredEdge:NSMinY([dSelector frame])];
        [(QSWindow *)[(theControl)->resultController window] setHideOffset:NSMakePoint(NSMaxX([iSelector frame]), 0)];
        [(QSWindow *)[(theControl)->resultController window] setShowOffset:NSMakePoint(NSMaxX([dSelector frame]), 0)];
        
        [theCell setShowDetails:YES];
        [theCell setTextColor:[NSColor whiteColor]];
        [theCell setCellRadiusFactor:32.0];
        [theCell setState:NSOnState];
        
        [theCell bind:@"highlightColor" toObject:defcon withKeyPath:@"values.QSAppearance1A" options:transformer];
        [theCell bind:@"textColor" toObject:defcon withKeyPath:@"values.QSAppearance1T" options:transformer];
    }
    [self setFonts];
    [self contractWindow:nil];
}

- (void)setFonts {
    NSFont *interfaceFont = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"NostromoInterfaceFont"]];
    NSString *interfaceFontName = [interfaceFont fontName];
    float baseFontSize = [interfaceFont pointSize];

    [commandView setFont:[NSFont fontWithName:interfaceFontName size:12.0]];

    for(QSSearchObjectView *theControl in @[dSelector, aSelector, iSelector]) {
        QSObjectCell *theCell = [theControl cell];
        [theControl setTextCellFont:[NSFont fontWithName:interfaceFontName size:baseFontSize/1.8]];
        [theCell setFont:[NSFont fontWithName:interfaceFontName size:12.0]];
        [theCell setNameFont:[NSFont fontWithName:interfaceFontName size:baseFontSize]];
        [theCell setDetailsFont:[NSFont fontWithName:interfaceFontName size:baseFontSize/1.8]];
		[theCell setAlignment:NSTextAlignmentLeft];
    }

}
- (void)dealloc {
    if ([self isWindowLoaded]) {
        [[[self window] contentView] unbind:@"color"];
        [[self window] unbind:@"hasShadow"];
        [commandView unbind:@"textColor"];
		[menuButtonOverlay unbind:@"textColor"];
        NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
        for(NSControl * theControl in theControls) {
            NSCell *theCell = [theControl cell];
            [theCell unbind:@"highlightColor"];
            [theCell unbind:@"textColor"];
            [(QSObjectCell *)theCell setTextColor:nil];
            [(QSObjectCell *)theCell setHighlightColor:nil];
        }
    }
    [super dealloc];
}

- (NSSize)maxIconSize
{
    return QSSize256;
}

- (void)showMainWindow:(id)sender {
    [[self window] setFrame:[self rectForState:[self expanded]]  display:YES];
    if ([[self window] isVisible]) [[self window] pulse:self];
    [super showMainWindow:sender];
    [[[self window] contentView] setNeedsDisplay:YES];
}

- (void)expandWindow:(id)sender {
    if (![self expanded]) {
        [[self window] setFrame:[self rectForState:YES] display:YES animate:YES];
		[iSelector setFrame:standardIObjectRect];
    }
    [super expandWindow:sender];
}

- (void)contractWindow:(id)sender {
    if ([self expanded]) {
        [[self window] setFrame:[self rectForState:NO] display:YES animate:YES];
        NSRect iNewRect = standardIObjectRect;
        iNewRect.size.height = iNewRect.size.height - heightDifference;
        [iSelector setFrame:iNewRect];
    }
    [super contractWindow:sender];
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
    return NSOffsetRect(NSInsetRect(rect, 8, 0), 0, -21);
}

- (NSRect) rectForState:(BOOL)shouldExpand {
    NSRect newRect = standardRect;
    NSRect screenRect = [[NSScreen mainScreen] frame];
    if (!shouldExpand) {
        newRect.size.height -= heightDifference;
        newRect = centerRectInRect(newRect, [[NSScreen mainScreen] frame]);
    }
    return NSOffsetRect(centerRectInRect(newRect, screenRect), 0, NSHeight(screenRect) /8);
}

- (void)searchObjectChanged:(NSNotification*)notif {
    [super searchObjectChanged:notif];
    NSString *commandName = [[self currentCommand] name];
    if (!commandName) commandName = @"";
    [commandView setStringValue:([dSelector objectValue] ? commandName : @"Quicksilver")];
}

- (IBAction)customize:(id)sender{
    [[NSClassFromString(@"QSPreferencesController") sharedInstance] showPaneWithIdentifier:@"QSNostromoPrefPane"];
}
@end
