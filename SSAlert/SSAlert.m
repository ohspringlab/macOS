//****** SSAlert.m ************************

#import "SSAlert.h"


@implementation SSAlert

@synthesize helpButton = _helpButton;
//@synthesize helpButtonAnchor,checkBox,panel;
//@synthesize
/*
- (void)setHelpButton:(NSButton*)helpButton {
    [helpButton retain] ;
    [_helpButton release] ;
    _helpButton = helpButton ;
}

- (NSButton*)helpButton {
    return _helpButton ;
}

- (void)setHelpButtonAnchor:(NSString*)helpButtonAnchor {
    [helpButtonAnchor retain] ;
    [_helpButtonAnchor release] ;
    _helpButtonAnchor = helpButtonAnchor ;
}

- (NSString*)helpButtonAnchor {
    return _helpButtonAnchor ;
}

- (void)setCheckbox:(NSButton*)checkbox {
    [checkbox retain] ;
    [_checkbox release] ;
    _checkbox = checkbox ;
}

- (NSButton*)checkbox {
    return _checkbox ;
}

- (void)setPanel:(NSPanel*)panel {
    [panel retain] ;
    [_panel release] ;
    _panel = panel ;
}

- (NSPanel*)panel {
    return _panel ;
} */

- (void)addCheckboxWithTitle:(NSString*)title {
    // Most of this method was written by Tristan O'Tierney and was
    // ripped from http://www.cocoadev.com/index.pl?NSAlertCheckbox
    float checkboxPadding = 14.0f; // according to the apple HIG

    NSWindow *window = [self panel];
    NSView *content = [window contentView];

    // Find the position of the lower (small-fonted) text field
    NSArray *subviews = [content subviews];
    NSEnumerator *en = [subviews objectEnumerator];
    NSView *subview = nil;
    NSTextField *messageText = nil;
    int count = 0;

    while (subview = [en nextObject]) {
        if ([subview isKindOfClass:[NSTextField class]]) {
            count++;

            if (count == 2) {
                messageText = (NSTextField *)subview;
            }
        }
    }

    NSButton* checkbox = [[NSButton alloc] initWithFrame:NSZeroRect] ;
    [self setCheckbox:checkbox] ;
    //[checkbox release] ;

    [checkbox setButtonType:NSSwitchButton] ;
    [checkbox setTitle:title] ;

    if (messageText) {
        // Make the checkbox font match the text area above it
        [checkbox setFont:[messageText font]];
        [checkbox sizeToFit];

        // Expand the window
        NSRect windowFrame = [window frame];
        NSRect checkboxFrame = [checkbox frame];
        windowFrame.size.height += checkboxFrame.size.height +
checkboxPadding;
        [window setFrame:windowFrame display:YES];

        checkboxFrame.origin.y = [messageText frame].origin.y -
checkboxFrame.size.height - checkboxPadding;
        checkboxFrame.origin.x = [messageText frame].origin.x;

        [checkbox setFrame:checkboxFrame];
    }

    [content addSubview:checkbox] ;
}

- (void)addHelpButton {

    NSWindow *window = [self panel];
    NSView *content = [window contentView];

    // Find the position of other buttons
    NSArray *subviews = [content subviews];
    NSEnumerator *en = [subviews objectEnumerator];
    NSView *subview = nil;

    // Find the image which is on the left (we'll use its frame.origin.x,
    // and find any of the other buttons (we'll use its frame.origin.y)
    NSImageView* imageView = nil;
    NSButton* otherButton = nil;
    while (subview = [en nextObject]) {
        if ([subview isKindOfClass:[NSImageView class]]) {
            imageView = (NSImageView*)subview ;
        }
        else if ([subview isKindOfClass:[NSButton class]]) {
            otherButton = (NSButton*)subview ;
        }
    }

    // Create an initial frame of correct size but position zero
    NSRect frame ;
    frame.origin = NSZeroPoint ;
    // This is the size of a Help button in Interface Builder:
    frame.size.width = 21.0 ;
    frame.size.height = 23.0 ;

    // Create and set the button
    NSButton* helpButton = [[NSButton alloc] initWithFrame:frame] ;
    [self setHelpButton:helpButton] ;
    //[helpButton release] ;

    // Calculate x position
    float x = 0.0 ;
    if (imageView) {
        x = [imageView frame].origin.x + [imageView frame].size.width/2 ;
    }
    frame.origin.x = x - frame.size.width/2 ;

    // Calculate y position
    float y = 0.0 ;
    if (otherButton) {
        y = [otherButton frame].origin.y + [otherButton frame].size.height/2
;
    }
    frame.origin.y = y - frame.size.height/2 ;

    [helpButton setFrame:frame] ;
    [helpButton setBezelStyle:NSHelpButtonBezelStyle] ;
    [helpButton setTarget:self] ;
    [helpButton setAction:@selector(help:)] ;
    [helpButton setTitle:@""] ;

    [content addSubview:helpButton];
}

- (IBAction)help:(id)sender {
    NSString *locBookName = [[NSBundle mainBundle]
objectForInfoDictionaryKey: @"CFBundleHelpBookName"];
    [[NSHelpManager sharedHelpManager] openHelpAnchor:[self
helpButtonAnchor]  inBook:locBookName]; }

- (void) dealloc {
    [self setHelpButton:nil] ;
    [self setHelpButtonAnchor:nil] ;
    [self setCheckbox:nil] ;
    NSReleaseAlertPanel([self panel]) ;
    [self setPanel:nil] ;

    [super dealloc];
}

+ (void)runModalBadgeCritical:(BOOL)critical
                   bigTopText:(NSString*)bigTopText
              smallBottomText:(NSString*)smallBottomText
           defaultButtonTitle:(NSString*)defaultButtonTitle
              leftButtonTitle:(NSString*)leftButtonTitle
            middleButtonTitle:(NSString*)middleButtonTitle
             helpButtonAnchor:(NSString*)helpButtonAnchor
                checkboxTitle:(NSString*)checkboxTitle
                checkboxState:(NSCellStateValue*)pCheckboxState
                  alertReturn:(int*)pAlertReturn {

    SSAlert* instance = [[super alloc] init] ;

    NSPanel* panel ;

    if (!defaultButtonTitle) {
        defaultButtonTitle = @"OK" ;
    }

    if (!smallBottomText) {
        // Golly, thanks, Apple!!  It's so thoughtful of you to
        // raise an exception when I try and create an alert with no
        // "informative text" by passing nil as the second argument.
        // Maybe this is what I really wanted, though....
        smallBottomText = @"" ;
    }

    if (critical) {
        panel = NSGetCriticalAlertPanel(bigTopText,
                                smallBottomText,
                                defaultButtonTitle,
                                leftButtonTitle,
                                middleButtonTitle) ;
    }
    else {
        panel = NSGetAlertPanel(bigTopText,
                                smallBottomText,
                                defaultButtonTitle,
                                leftButtonTitle,
                                middleButtonTitle) ;
    }

    [instance setPanel:panel] ;

    if (helpButtonAnchor) {
        [instance setHelpButtonAnchor:helpButtonAnchor] ;
        [instance addHelpButton] ;
    }

    int checkboxState ;
    if (pCheckboxState) {
        checkboxState = *pCheckboxState ;
    }

    if (checkboxTitle) {
        [instance addCheckboxWithTitle:checkboxTitle] ;
        // Set initial state of checkbox
        [[instance checkbox] setState:checkboxState] ;
    }

    // Run the sucker
    int alertReturn = [NSApp runModalForWindow:panel];

    // Clean up and self-destruct
    [panel orderOut:self] ;
    if (pCheckboxState) {
        *pCheckboxState = [[instance checkbox] state] ;
    }
    if (pAlertReturn) {
        *pAlertReturn = alertReturn ;
    }
    [instance release] ;
    [NSApp stopModal] ;
}

@end