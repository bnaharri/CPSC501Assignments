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
NSString *_polarbearName = @"PolarBear.jpeg";
NSString *_penguinLabelText = @"Penguin";
NSString *_polarbearLabelText = @"Polar Bear";
bool _isPenguinSelected = TRUE;


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
    
    if(_isPenguinSelected == true){
        _penguinSlider = value;
    }
    else{
        _polarbearSlider = value;
    }

}

- (IBAction)doneEditing:(id)sender {
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

- (IBAction)_screenwasSwiped:(id)sender {
    if(!_isPenguinSelected){
        _isPenguinSelected = true;
        [_imageButton setImage:[UIImage imageNamed:_penguinName] forState:UIControlStateNormal];
        _imageLabel.text = _penguinLabelText;
        _alphaField.text = [NSString stringWithFormat:@"%d", (int)round(_penguinSlider*100)];
        _alphaSlider.value = _penguinSlider;
        _imageButton.alpha = _penguinSlider;
        _imageLabel.hidden = _penguinLabel;
        [__labelSwitch setOn: (!_penguinLabel)];
        [_imageSelector setSelectedSegmentIndex:0];
        
        
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
        [_imageSelector setSelectedSegmentIndex:1];
    }
}

- (IBAction)_tappedImage:(id)sender {
}

- (IBAction)tappedTheBackGround:(id)sender {
    [_alphaField resignFirstResponder];
    [_imageLabel resignFirstResponder];
}

@end














