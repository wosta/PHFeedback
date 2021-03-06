//
//  SZTextView.m
//  SZTextView
//
//  Created by glaszig on 14.03.13.
//  Copyright (c) 2013 glaszig. All rights reserved.
//

#import "PHPlaceholderTextView.h"

@interface PHPlaceholderTextView ()
@property (strong, nonatomic) UILabel *placeholderLabel;
@end

static NSString *kPlaceholderKey = @"placeholder";
static NSString *kFontKey = @"font";
static NSString *kTextKey = @"text";
static float kUITextViewPadding = 8.0;

@implementation PHPlaceholderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    // the label which displays the placeholder
    // needs to inherit some properties from its parent text view

    // account for standard UITextViewPadding
    CGRect frame = CGRectMake(kUITextViewPadding, kUITextViewPadding, 0, 0);
    self.placeholderLabel = [[UILabel alloc] initWithFrame:frame];
    self.placeholderLabel.opaque = NO;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.textColor = [UIColor grayColor];
    self.placeholderLabel.textAlignment = self.textAlignment;
    self.placeholderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.placeholderLabel.font = self.font;
    [self.placeholderLabel sizeToFit];
    [self addSubview:self.placeholderLabel];

    // some observations
    NSNotificationCenter *defaultCenter;
    defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(textDidChange:)
                          name:UITextViewTextDidChangeNotification object:self];

    [self addObserver:self forKeyPath:kPlaceholderKey
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:kFontKey
              options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:kTextKey
              options:NSKeyValueObservingOptionNew context:nil];
    
    self.layer.cornerRadius = 1.0;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0].CGColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIEdgeInsets inset = self.contentInset;
    CGRect frame = self.placeholderLabel.frame;
    // the width needs to be limited to the text view's width
    // to prevent the label text from bleeding off
    frame.size.width = self.bounds.size.width;
    frame.size.width-= kUITextViewPadding + inset.right + inset.left;
    self.placeholderLabel.frame = frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kPlaceholderKey]) {
        self.placeholderLabel.text = [change valueForKey:NSKeyValueChangeNewKey];
        [self.placeholderLabel sizeToFit];
    }
    else if ([keyPath isEqualToString:kFontKey]) {
        self.placeholderLabel.font = [change valueForKey:NSKeyValueChangeNewKey];
        [self.placeholderLabel sizeToFit];
    }
    else if ([keyPath isEqualToString:kTextKey]) {
        NSString *newText = [change valueForKey:NSKeyValueChangeNewKey];
        if (newText.length > 0) {
            [self.placeholderLabel removeFromSuperview];
        } else {
            [self addSubview:self.placeholderLabel];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    self.placeholderLabel.textColor = placeholderTextColor;
}

- (UIColor *)placeholderTextColor
{
    return self.placeholderLabel.textColor;
}

- (void)textDidChange:(NSNotification *)aNotification
{
    if (self.text.length < 1) {
        [self addSubview:self.placeholderLabel];
        [self sendSubviewToBack:self.placeholderLabel];
    } else {
        [self.placeholderLabel removeFromSuperview];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:kPlaceholderKey];
    [self removeObserver:self forKeyPath:kFontKey];
    [self removeObserver:self forKeyPath:kTextKey];
}

@end
