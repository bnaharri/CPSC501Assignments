//
//  pictureManipulatorViewController.h
//  assignmentOne
//
//  Created by Brian Harrison on 2012-09-20.
//  Copyright (c) 2012 Brian Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <math.h>

@interface pictureManipulatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *imageSelector;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UISwitch *_labelSwitch;
@property (weak, nonatomic) IBOutlet UITextField *alphaField;
- (IBAction)valueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *imageLabel;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
- (IBAction)dragImage:(id)sender forEvent:(UIEvent *)event;
- (IBAction)imageClicked:(id)sender forEvent:(UIEvent *)event;

- (IBAction)doneEditing:(id)sender;
- (IBAction)swapPhotos:(id)sender;
- (IBAction)labelsOff:(id)sender;

- (IBAction)_screenwasSwiped:(id)sender;

- (IBAction)_tappedImage:(id)sender;

- (IBAction)tappedTheBackGround:(id)sender;


@end
