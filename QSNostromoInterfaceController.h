//
//  QSNostromoInterfaceController.h
//  Nostromo
//
//  Created by Eric Doughty-Papassideris on 29/04/2011.
//

@interface QSNostromoInterfaceController : QSResizingInterfaceController {
    NSRect standardRect;
    NSRect standardIObjectRect;
    CGFloat heightDifference;
	IBOutlet NSTextField *menuButtonOverlay;
}

- (NSRect) rectForState:(BOOL)shouldExpand;
@end
