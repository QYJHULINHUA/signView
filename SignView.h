
#import <UIKit/UIKit.h>

typedef void(^SignResult)(UIImage *signImage);

@interface SignView : UIView


/**
 签名区域的背景颜色
 */
@property (nonatomic, strong) UIColor *signViewColor;

/**
 签名笔划颜色
 */
@property (nonatomic, strong) UIColor *signLineColor;

/**
 签名笔划宽度
 */
@property (nonatomic, assign) CGFloat signLineWidth;

/**
 无签名时占位文字
 */
@property (nonatomic, copy) NSString *signPlaceHoalder;


/**
 签名完成后的回调Block,里面有完成的签名图片
 
 @param result block
 */
- (void)signResultWithBlock:(SignResult)result;

// 签名完成
- (void)signDone;

// 清除签名
- (void)clearSignAction;

@end
