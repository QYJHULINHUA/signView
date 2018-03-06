
#import "SignView.h"


@interface SignView ()


@property(nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, strong) UILabel *placeHoalderLabel;
@property(nonatomic, assign) CGPoint lastPoint;
@property(nonatomic, assign) BOOL isSwiping;
@property(nonatomic, strong) NSMutableArray *pointXs;
@property(nonatomic, strong) NSMutableArray *pointYs;

@property (nonatomic, copy) SignResult result;


@end

@implementation SignView

-(NSMutableArray*)pointXs {
    if (!_pointXs) {
        _pointXs=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _pointXs;
}
-(NSMutableArray*)pointYs {
    if (!_pointYs) {
        _pointYs=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _pointYs;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1];
        self.layer.cornerRadius = 10;
    
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.signImageView = imageView;
        [self addSubview:imageView];
        
        CGRect placeFrame = imageView.frame;
        placeFrame.size.height = 100;
        UILabel *placeHoalderLabel = [[UILabel alloc] initWithFrame:placeFrame];
        placeHoalderLabel.center = imageView.center;
        placeHoalderLabel.textAlignment = NSTextAlignmentCenter;
        if (self.signPlaceHoalder) {
            placeHoalderLabel.text = self.signPlaceHoalder;
        } else {
            placeHoalderLabel.text = @"签名区域";
        }
        placeHoalderLabel.font = [UIFont systemFontOfSize:35];
        placeHoalderLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        self.placeHoalderLabel = placeHoalderLabel;
        [self addSubview:placeHoalderLabel];
        
    }
    
    return self;
}

- (void)setSignViewColor:(UIColor *)signViewColor{
    self.backgroundColor = signViewColor;
}

- (void)setSignPlaceHoalder:(NSString *)signPlaceHoalder{
    if (signPlaceHoalder) {
        _signPlaceHoalder = signPlaceHoalder;
        self.placeHoalderLabel.text = _signPlaceHoalder;
    }
}

- (NSDictionary *)RGBDictionaryByColor:(UIColor *)color {
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *compoments = CGColorGetComponents(color.CGColor);
        red = compoments[0];
        green = compoments[1];
        blue = compoments[2];
        alpha = compoments[3];
    }
    return @{@"red":@(red), @"green":@(green), @"blue":@(blue), @"alpha":@(alpha)};
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isSwiping = NO;
    UITouch * touch = touches.anyObject;
    self.lastPoint = [touch locationInView:self.signImageView];
    if (self.lastPoint.x > 0) {
        self.placeHoalderLabel.text = nil;
    }
    [self.pointXs addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.pointYs addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping = YES;
    UITouch * touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self.signImageView];
    UIGraphicsBeginImageContext(self.signImageView.frame.size);
    [self.signImageView.image drawInRect:(CGRectMake(0, 0, self.signImageView.frame.size.width, self.signImageView.frame.size.height))];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound);
    CGFloat lineWidth = 3.3;
    if (self.signLineWidth) {
        lineWidth = self.signLineWidth;
    }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    if (self.signLineColor) {
        NSDictionary *rgbDic = [self RGBDictionaryByColor:self.signLineColor];
        red = [rgbDic[@"red"] floatValue];
        green = [rgbDic[@"green"] floatValue];
        blue = [rgbDic[@"blue"] floatValue];
    }
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, 1.0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.signImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
    [self.pointXs addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.pointYs addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.isSwiping) {
        UIGraphicsBeginImageContext(self.signImageView.frame.size);
        [self.signImageView.image drawInRect:(CGRectMake(0, 0, self.signImageView.frame.size.width, self.signImageView.frame.size.height))];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.signImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
}

- (void)signResultWithBlock:(SignResult)result{
    self.result = result;
}

// 签名完成
- (void)signDone
{
    if (self.result) {
        self.result(self.signImageView.image);
    }
}

// 清除签名
- (void)clearSignAction
{
    self.signImageView.image = nil;
    self.placeHoalderLabel.hidden = NO;
    if (self.signPlaceHoalder) {
        self.placeHoalderLabel.text = self.signPlaceHoalder;
    } else {
        self.placeHoalderLabel.text = @"签名区域";
    }
}


@end
