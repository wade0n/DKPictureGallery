//
//  DKPictureScroll.h
//  Pods
//
//  Created by Дмитрий Калашников on 07/07/14.
//
//

#import <UIKit/UIKit.h>

@interface DKPictureScroll : UIScrollView

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *widthConstr;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstr;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *leftOffsetConstr;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *topOffsestConstr;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *actRightOffsetConstr;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *actBottomtOffsetConstr;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *actLeftOffsetConstr;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *actTopOffsetConstr;

@property(nonatomic) BOOL imageLoaded;

@end
