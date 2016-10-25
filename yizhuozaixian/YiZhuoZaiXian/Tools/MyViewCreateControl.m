

#import "MyViewCreateControl.h"

@implementation MyViewCreateControl

//在创建UIView工场方法中手动创建一个UIView并赋值
+(UIView *)initViewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    view.backgroundColor = bgColor;
    
    return view;
    
}

//快速创建文字按钮
+(UIButton *)initTitleButtonWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andText:(NSString *)text andTextColor:(UIColor *)textColor andTextFont:(UIFont *)textFont andTarget:(id)target andSelector:(SEL)selector{
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    button.backgroundColor = bgColor;
    
    [button setTitle:text forState:UIControlStateNormal];
    
    [button setTitleColor:textColor forState:UIControlStateNormal];
    
    [button addTarget:target action:selector    forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.font = textFont;
    
    return button;
    
}

//快速创建图片按钮
+(UIButton *)initImageButtonWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andImage:(UIImage *)image andBackgroundImage:(UIImage *)bgImage andTarget:(id)target andSelector:(SEL)selector{
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    button.backgroundColor = bgColor;
    
    [button setImage:image forState:UIControlStateNormal];
    
    [button addTarget:target action:selector    forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    return button;
    
}

//快速创建标签
+(UILabel *)initLabelWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andText:(NSString*)text  andTextFont:(double)font andTextAlignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.backgroundColor = bgColor;
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = textAlignment;
    
    return label;
}

//快速创建imageVier
+(UIImageView *)initImageVierWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)bgColor andBackgroundNameOfImage:(NSString *)NameOfImage andUsInterfaceEnable:(BOOL)UsInterfaceEnable andContextMode:(UIViewContentMode)contentMode{
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = frame;
    imageView.backgroundColor = bgColor;
    imageView.image = [UIImage imageNamed:NameOfImage];
    imageView.userInteractionEnabled = UsInterfaceEnable;
    imageView.contentMode = contentMode;
    
    return imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
