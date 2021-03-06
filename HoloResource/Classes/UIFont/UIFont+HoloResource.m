//
//  UIFont+HoloResource.m
//  HoloResource
//
//  Created by 与佳期 on 2020/4/30.
//

#import "UIFont+HoloResource.h"
#import <CoreText/CTFontManager.h>
#import "NSBundle+HoloResource.h"

@implementation UIFont (HoloResource)

/// If the pod currently has multiple bundles, please check the target resource or use 'holo_registerFont:withExtension:inBundle:'
+ (void)holo_registerFont:(NSString *)fontName withExtension:(NSString *)extension bundleName:(NSString *)bundleName {
    NSBundle *bunlde = [NSBundle holo_bundleNamed:bundleName];
    [self holo_registerFont:fontName withExtension:extension inBundle:bunlde];
}

+ (void)holo_registerFont:(NSString *)fontName withExtension:(NSString *)extension inBundle:(NSBundle *)bundle {
    NSURL *fontURL = [bundle URLForResource:fontName withExtension:extension];
    NSData *inData = [NSData dataWithContentsOfURL:fontURL];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
    // Try to fix: CGFontCreateWithDataProvider crash on iOS 10
    // https://stackoverflow.com/questions/24900979/cgfontcreatewithdataprovider-hangs-in-airplane-mode
    [UIFont familyNames];
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        // Failed to load font
        CFRelease(errorDescription);
    }
    if (font != NULL) CFRelease(font);
    if (provider != NULL) CFRelease(provider);
}

@end
