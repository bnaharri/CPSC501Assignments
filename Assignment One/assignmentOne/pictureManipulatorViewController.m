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

//variables for model, should be in a seperate class
CGPoint _clickDown;
float _penguinSlider;
float _polarbearSlider;
bool _penguinLabel = FALSE;
bool _polarbearLabel = FALSE;
NSString *_penguinName = @"penguin-chick.jpeg";
NSString *_polarbearName = @"polar_bear.jpeg";
NSString *_penguinLabelText = @"Penguin";
NSString *_polarbearLabelText = @"Polar Bear";
bool _isPenguinSelected = TRUE;
bool _showPopUp = true;
bool _maximizedMode = false;


@implementation pictureManipulatorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _imageButton.alpha = .5;
    _penguinSlider = .5;
    _polarbearSlider = .5;
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
    
    float x3 = __maximizeImageButton.center.x - _imageButton.center.x;
    float y3 = __maximizeImageButton.center.y - _imageButton.center.y;
    
    //update our images location
    _imageButton.center = imageCenter;
    
    //update our labels location
    _imageLabel.center = CGPointMake(x+imageCenter.x, y+imageCenter.y);
    
    __labelSwitch.center = CGPointMake(x2+imageCenter.x, y2+imageCenter.y);
    
    __maximizeImageButton.center = CGPointMake(x3+imageCenter.x, y3+imageCenter.y);
    
    //update our previous point
    _clickDown = currentDrag;
}


//store where we originally clicked on the screen
- (IBAction)imageClicked:(id)sender forEvent:(UIEvent *)event {
    if(_maximizedMode){
        _imageLabel.hidden = false;
        _imageSelector.hidden = false;
        _alphaSlider.hidden = false;
        _alphaField.hidden = false;
        __labelSwitch.hidden = false;
        __maximizeImageButton.hidden = false;
        _opacityLabel.hidden = false;
        [self swapPhotos:_imageSelector];
    }
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
    
    if(_isPenguinSelected == true){
        _penguinSlider = value;
    }
    else{
        _polarbearSlider = value;
    }

}

- (IBAction)doneEditing:(id)sender {
    if(_isPenguinSelected){
        _penguinLabelText = _imageLabel.text;
    }
    else{
        _polarbearLabelText = _imageLabel.text;
    }
    [sender resignFirstResponder];
}

- (IBAction)swapPhotos:(UISegmentedControl*)sender {
    if(sender.selectedSegmentIndex == 0){
        _isPenguinSelected = true;
        [_imageButton setImage:[UIImage imageNamed:_penguinName] forState:UIControlStateNormal];
        _imageLabel.text = _penguinLabelText;
        _alphaField.text = [NSString stringWithFormat:@"%d", (int)round(_penguinSlider*100)];
        _alphaSlider.value = _penguinSlider;
        _imageButton.alpha = _penguinSlider;
        _imageLabel.hidden = _penguinLabel;
        [__labelSwitch setOn: (!_penguinLabel)];
        
        
    }
    else{
        _isPenguinSelected = false;
        [_imageButton setImage:[UIImage imageNamed:_polarbearName] forState:UIControlStateNormal];
        _imageLabel.text = _polarbearLabelText;
        _alphaField.text = [NSString stringWithFormat:@"%d", (int)round(_polarbearSlider*100)];
        _alphaSlider.value = _polarbearSlider;
        _imageLabel.hidden = _polarbearLabel;
        _imageButton.alpha = _polarbearSlider;
        [__labelSwitch setOn: (!_polarbearLabel)];
    }
}

- (IBAction)labelsOff:(UISwitch *)sender {
    if(sender.isOn){
        _imageLabel.hidden = false;
        if(_isPenguinSelected){
            _penguinLabel = false;
        }
        else{
            _polarbearLabel = false;
        }
    }
    else{
        _imageLabel.hidden = true;
        if(_isPenguinSelected){
            _penguinLabel = true;
        }
        else{
            _polarbearLabel = true;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: true];
}

- (IBAction)_maximizePressed:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [_imageButton setBounds:screenRect];
    _imageButton.center = CGPointMake(screenRect.size.width/2.0, screenRect.size.height/2.0);
    _imageLabel.hidden = true;
    _imageSelector.hidden = true;
    _alphaSlider.hidden = true;
    _alphaField.hidden = true;
    __labelSwitch.hidden = true;
    __maximizeImageButton.hidden = true;
    _opacityLabel.hidden = true;
    _maximizedMode = true;
    if(_imageButton.alpha == 0){
        _imageButton.alpha = .1;
    }
    if(_showPopUp){
        _showPopUp = false;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Maximizing Photo"
                                                        message:@"Click the image to return to normal."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: false];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int movementDistance = 120; // tweak as needed
    float movementDuration = 0.3f; // tweak as needed
    
    if(up){
        movementDistance = -movementDistance;
    }
    else{
        movementDistance = movementDistance;
    }
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: true];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movementDistance);
    [UIView commitAnimations];
}

- (IBAction)tappedTheBackGround:(id)sender {
    if(_isPenguinSelected){
        _penguinLabelText = _imageLabel.text;
    }
    else{
        _polarbearLabelText = _imageLabel.text;
    }
    [_alphaField resignFirstResponder];
    [_imageLabel resignFirstResponder];
}

@end














