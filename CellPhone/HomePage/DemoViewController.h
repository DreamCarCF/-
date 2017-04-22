#import <UIKit/UIKit.h>
#import "RotarySelector.h"
#define KEY_USER_NAME       @"UserName"
#define KEY_USER_IMAGE      @"UserImage"
#define USER_MAX            8   //the max user in rotary selector view ,I suggest  under 9


@interface DemoViewController : UIViewController<RotaryDelegate>{
    RotarySelector      *rotary;
    NSMutableArray      *data_source_ary;
}

@end
