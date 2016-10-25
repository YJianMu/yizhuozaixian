

#import <UIKit/UIKit.h>

@interface MyViewCreateControl : UIView

+(UIView *)initViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor;

+(UIButton *)initTitleButtonWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andText:(NSString *)text andTextColor:(UIColor *)textColor andTextFont:(UIFont *)textFont andTarget:(id)target andSelector:(SEL)selector;

+(UIButton *)initImageButtonWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andImage:(UIImage *)image andBackgroundImage:(UIImage *)bgImage andTarget:(id)target andSelector:(SEL)selector;

+(UILabel *)initLabelWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andText:(NSString*)text  andTextFont:(double)font andTextAlignment:(NSTextAlignment)textAlignment;

+(UIImageView *)initImageVierWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andBackgroundNameOfImage:(NSString *)NameOfImage andUsInterfaceEnable:(BOOL)UsInterfaceEnable andContextMode:(UIViewContentMode)contentMode;
@end
