//
//  MOOCGImageWrapper.m
//  MOOMaskedIconView
//
//  Created by Peyton Randolph on 2/27/12.
//

#import "MOOCGImageWrapper.h"

#import "AHHelper.h"

@implementation MOOCGImageWrapper {
    NSUInteger accessCounter;
}

@dynamic CGImage;
@dynamic cost;

- (id)initWithCGImage:(CGImageRef)image;
{
    if (!(self = [super init]))
        return nil;
    
    accessCounter = 1;
    self.CGImage = image;

    return self;
}

+ (MOOCGImageWrapper *)wrapperWithCGImage:(CGImageRef)image;
{
    return AH_AUTORELEASE([[self alloc] initWithCGImage:image]);
}

- (void)dealloc;
{
    self.CGImage = NULL;
    
    AH_SUPER_DEALLOC;
}

#pragma mark - Getters and setters

- (CGImageRef)CGImage;
{
    @synchronized(self)
    {
        return _CGImage;
    }
}

- (void)setCGImage:(CGImageRef)CGImage;
{
    @synchronized(self)
    {
        if (CGImage == _CGImage)
            return;
        
        if (_CGImage != NULL) {
            CGImageRelease(_CGImage);
        }
        _CGImage = CGImageRetain(CGImage);
    }    
}

- (NSUInteger)cost;
{
    return CGImageGetBytesPerRow(self.CGImage) * CGImageGetHeight(self.CGImage);
}

- (BOOL)beginContentAccess {
    accessCounter++;
}
- (void)endContentAccess {
    if (accessCounter > 0)
        accessCounter--;
}
- (BOOL)isContentDiscarded {
    return _CGImage == NULL;
}
- (void)discardContentIfPossible {
    if (accessCounter == 0) {
        CGImageRelease(_CGImage);
        _CGImage = NULL;
    }
}

@end
