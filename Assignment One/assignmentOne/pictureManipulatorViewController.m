//
//  pictureManipulatorViewController.m
//  assignmentOne
//
//  Created by Brian Harrison on 2012-09-20.
//  Copyright (c) 2012 Brian Harrison. All rights reserved.
//

#import "pictureManipulatorViewController.h"

@interface pictureManipulatorViewController ()

@end
CGPoint _clickDown;
@implementation pictureManipulatorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _imageButton.alpha = .5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//calculate new location to move button to
- (IBAction)dragImage:(id)sender forEvent:(UIEvent *)event {
    
    //get our button
    UIControl *imageButton = sender;

    //find where the finger is
    CGPoint currentDrag = [[[event allTouches] anyObject] locationInView:self.view];
    
    //get the center of our image
    CGPoint imageCenter = imageButton.center;
    
    //calculate offset of drag
    imageCenter.x += currentDrag.x - _clickDown.x;
    imageCenter.y += currentDrag.y - _clickDown.y;
    
    //calculate label offset from picture
    float x = _imageLabel.center.x - _imageButton.center.x;
    float y = _imageLabel.center.y - _imageButton.center.y;
    
    
    float x2 = __labelSwitch.center.x - _imageButton.center.x;
    float y2 = __labelSwitch.center.y - _imageButton.center.y;
    //update our images location
    _imageButton.center = imageCenter;
    
    //update our labels location
    _imageLabel.center = CGPointMake(x+imageCenter.x, y+imageCenter.y);
    
    __labelSwitch.center = CGPointMake(x2+imageCenter.x, y2+imageCenter.y);
    
    //update our previous point
    _clickDown = currentDrag;
}


//store where we originally clicked on the screen
- (IBAction)imageClicked:(id)sender forEvent:(UIEvent *)event {
    
    //get where we clicked on the screen
    _clickDown = [[[event allTouches] anyObject] locationInView:self.view];
    
}
- (IBAction)valueChanged:(id)sender {
    float value;
    if([sender isKindOfClass:[UISlider class]]){
        value = _alphaSlider.value;
        _alphaField.text = [NSString stringWithFormat:@"%d", (int)round(value*100)];
    }
    else{
        value = _alphaField.text.floatValue/100;
        _alphaSlider.value = value;
    }
    _imageButton.alpha = value;

}

- (IBAction)doneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)swapPhotos:(UISegmentedControl*)sender {
    if(sender.selectedSegmentIndex == 0){
        [_imageButton setImage:[UIImage imageNamed:@"penguin-chick.jpeg"] forState:UIControlStateNormal];
        _imageLabel.text = @"Penguin";
    }
    else{
        [_imageButton setImage:[UIImage imageNamed:@"PolarBear.jpeg"] forState:UIControlStateNormal];
        _imageLabel.text = @"Polar Bear";
    }
}

- (IBAction)labelsOff:(UISwitch *)sender {
    if(sender.isOn){
        _imageLabel.hidden = false;
    }
    else{
        _imageLabel.hidden = true;
    }
}

- (IBAction)tappedTheBackGround:(id)sender {
    [_alphaField resignFirstResponder];
    [_imageLabel resignFirstResponder];
}

@end














