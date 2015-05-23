//
//  OMSignUpViewConroller.m
//  OfficeMate
//
//  Created by Ravindra Shetty on 23/05/15.
//  Copyright (c) 2015 Ravindra Shetty. All rights reserved.
//

#import "OMSignUpViewConroller.h"
#import <DigitsKit/DigitsKit.h>
#import "OMAppearance.h"
#import "AppDelegate.h"


@interface OMSignUpViewConroller () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) DGTAuthenticateButton *phoneNumberButton;
@end

@implementation OMSignUpViewConroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setupView {
    self.navigationController.navigationBar.barTintColor = [OMAppearance appThemeColorWithAlpha:1];
    self.navigationController.navigationBar.tintColor = [OMAppearance appBgColorWithAlpha:1];
    self.nameTextField.delegate = self;
    self.nameTextField.font = [OMAppearance appFontWithSize:16 shouldBold:NO];
    [self setUpDigitButton];
}

- (void)setUpDigitButton {
    DGTAuthenticateButton *authenticateButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        // play with Digits session
        NSLog(@"");
    }];
    
    DGTAppearance *apperance = [[DGTAppearance alloc] init];
    apperance.accentColor = [OMAppearance appThemeColorWithAlpha:1];
    authenticateButton.digitsAppearance = apperance;
    CGPoint btnPos = CGPointMake(self.view.center.x, CGRectGetHeight(self.view.frame)-300);
    authenticateButton.center = btnPos;
    [authenticateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.phoneNumberButton = authenticateButton;
    [self.view addSubview:authenticateButton];
    self.phoneNumberButton.enabled = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField)
    {
        if (self.phoneNumberButton.enabled) {
            
        } else {
            [textField resignFirstResponder];
        }
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    BOOL shouldChange = (newLength > 20) ? NO : YES;
    
    if (shouldChange) {
        [self enableNextButtonWithTextLength:newLength];
    }
    
    return shouldChange;
}


- (void)enableNextButtonWithTextLength:(NSInteger)textLength
{
    if (textLength == 0) {
        self.phoneNumberButton.enabled = NO;
    } else {
        self.phoneNumberButton.enabled = YES;
    }
}

-(void)tapAction:(UITapGestureRecognizer *)gestureRecognizer
{
    if([self.nameTextField isFirstResponder]) {
        [self.nameTextField resignFirstResponder];
    }
}

- (IBAction)didTapTest:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomeStoryBoard" bundle:nil];
    UITabBarController *homeTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"homeTabbar"];
    [self changeRootViewController:homeTabBarController];
}

// put this in your AppDelegate
- (void)changeRootViewController:(UIViewController*)viewController {
    UIWindow *window = [AppDelegate sharedAppDelegate].window;
    window.rootViewController = viewController;
    if (!window.rootViewController) {
        window.rootViewController = viewController;
        return;
    }
    UIView *snapShot = [window snapshotViewAfterScreenUpdates:YES];
    [viewController.view addSubview:snapShot];
    window.rootViewController = viewController;
    [UIView animateWithDuration:0.3 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}
@end
