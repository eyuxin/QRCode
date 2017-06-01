#import <UIKit/UIKit.h>

#define MCRetain(...) do {void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing; } while (0)
#define MCRelease(...) do {void *retainedThing = (__bridge void *) __VA_ARGS__; id unretainedThing = (__bridge_transfer id)retainedThing; unretainedThing = nil; } while (0)

#ifdef __cplusplus
extern "C" {
#endif

    
// Null and nil
//
extern id MCNoNil(id object);

extern id MCNoNull(id object);

    
// System version check
//
extern BOOL MCSystemAfter(NSInteger version);

extern BOOL MCSystemBefore(NSInteger version);

    
// UIImage
//

@interface UIImage(Assets)

+ (UIImage *)launchImage;

+ (UIImage *)launchImageWithName: (NSString *)name;

+ (UIImage *)appIcon;

+ (UIImage *)appIconWithSize: (int)size;

@end

#ifdef __cplusplus
}
#endif
