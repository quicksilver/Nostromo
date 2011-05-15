//
//  QSNostromoCell.m
//  Nostromo
//
//  Created by Rob McBroom on 5/14/11.
//

#import "QSNostromoCell.h"


@implementation QSNostromoCell

+ (id)cellWithText {
    QSNostromoCell *cell = [[QSNostromoCell alloc] initTextCell:@"Nostromo"];
    [cell autorelease];
    return cell;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    BOOL isFirstResponder = [[controlView window] firstResponder] == controlView && ![controlView isKindOfClass:[NSTableView class]];
    // BOOL isKey = [[controlView window] isKeyWindow];
    
    
    NSColor *fillColor;
    NSColor *strokeColor;
    NSLog(@"drawWithFrame called");
    
    //logRect(drawingRect);
    BOOL dropTarget = ([self isHighlighted] && ([self highlightsBy] & NSChangeBackgroundCellMask) && ![self isBezeled]);
    
    if (isFirstResponder) {
        fillColor = [self highlightColor];
        //if (![self isHighlighted]) fillColor = [fillColor colorWithAlphaComponent:(isKey?1.0:0.5)];
    } else {
        fillColor = [[self textColor] colorWithAlphaComponent:0.075];
    }
    
    if (dropTarget) {
        
        fillColor = [fillColor blendedColorWithFraction:0.1 ofColor:[self textColor] ?[self textColor] :[NSColor textColor]];
    }
    strokeColor = [[self textColor] colorWithAlphaComponent:dropTarget?0.4:0.2];
    
    
    
    
    [fillColor setFill];
    [strokeColor setStroke];
    
    
    
    NSBezierPath *roundRect = [NSBezierPath bezierPath];
    if ([self isBezeled]) {
        //NSLog(@"%d", [self highlightsBy]);
        if ([self highlightsBy] || isFirstResponder) {
            QSObject *drawObject = [self representedObject];
            BOOL action = [drawObject respondsToSelector:@selector(argumentCount)];
            int argCount = (action ? [(QSAction *)drawObject argumentCount] : 0);
            //BOOL indentRight = (indentLeft && [drawObject argumentCount] >1);
            NSRect borderRect = NSInsetRect(cellFrame, 0.25, 0.25);
            [roundRect setLineWidth:1.5];
            [roundRect appendBezierPathWithRoundedRectangle:borderRect withRadius:NSHeight(borderRect) /2 indent:argCount];
            [roundRect fill];
            [roundRect stroke];
        }
    } else if ([self highlightsBy] && (isFirstResponder || [self state]) ) {
        [roundRect appendBezierPathWithRoundedRectangle:cellFrame withRadius:4.0];
        [roundRect fill];
        //[roundRect setFlatness:0.0];
        //[roundRect setLineWidth:3.25];
        //[roundRect stroke];
        
    }
    [self drawInteriorWithFrame:[self drawingRectForBounds:cellFrame] inView:controlView];
}

- (void)buildStylesForFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    //  BOOL wideDraw = NSWidth(cellFrame) /NSHeight(cellFrame) > 2;
    //  BOOL isFirstResponder = [[controlView window] firstResponder] == controlView && ![controlView isKindOfClass:[NSTableView class]];
    
    
    NSMutableParagraphStyle *style = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    [style setFirstLineHeadIndent:1.0];
    [style setHeadIndent:1.0];
    [style setAlignment:[self alignment]];
    //
    /// NSLog(@"%d %d", [self isHighlighted] , [self state]);
    
    //  NSView *controlView = [self controlView];
    BOOL useAlternateColor = [controlView isKindOfClass:[NSTableView class]] && [(NSTableView *)controlView isRowSelected:[(NSTableView *)controlView rowAtPoint:cellFrame.origin]];
    NSColor *mainColor = (textColor?textColor:(useAlternateColor?[NSColor alternateSelectedControlTextColor] :[NSColor controlTextColor]) );
    NSColor *fadedColor = [mainColor colorWithAlphaComponent:0.80];
    
    // name string
    [nameAttributes release];
    nameAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                        [NSFont fontWithName:[[self font] fontName] size:MIN([[self font] pointSize], NSHeight(cellFrame) *1.125*2/3) -1],
                        NSFontAttributeName,
                        mainColor,
                        NSForegroundColorAttributeName,
                        style,
                        NSParagraphStyleAttributeName,
                        nil];
    
    // details string
    [detailsAttributes release];
    detailsAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSFont fontWithName:[[self font] fontName] size:[[self font] pointSize] *0.5] , NSFontAttributeName,
                         fadedColor, NSForegroundColorAttributeName,
                         style, NSParagraphStyleAttributeName,
                         nil];
}

@end
