#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImmutableCoordinatorFactory : NSObject


- (void) disconnectStatefulAtTransformer: (NSMutableSet *)metadataTierTop;

@end

NS_ASSUME_NONNULL_END
        