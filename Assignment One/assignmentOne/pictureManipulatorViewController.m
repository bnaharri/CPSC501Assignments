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

NSMutableArray *_imageArray;
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
int _selectedIndex = 0;
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
    
    _imageArray = [[NSMutableArray alloc] init];
    pictureModel *penguinPicture = [[pictureModel alloc] init];
    
    penguinPicture.labelText = @"Penguin";
    penguinPicture.image = [UIImage imageNamed:@"penguin-chick.jpeg"];
    penguinPicture.alphaSlider = .5;
    penguinPicture.hideLabel = false;
    
    [_imageArray addObject:penguinPicture];
    
    pictureModel *polarbearPicture = [[pictureModel alloc] init];
    polarbearPicture.labelText = @"Polar Bear";
    polarbearPicture.image = [UIImage imageNamed:@"polar_bear.jpeg"];
    polarbearPicture.alphaSlider = .5;
    polarbearPicture.hideLabel = false;
    
    [_imageArray addObject:polarbearPicture];
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
        [self _hideUI:false];
        [self swapPhotos:_imageSelector];
        _maximizedMode = false;
    }
    //get where we clicked on the screen
    _clickDown = [[[event allTouches] anyObject] locationInView:self.view];
}

- (IBAction)valueChanged:(id)sender {
    pictureModel *current = [_imageArray objectAtIndex: _selectedIndex];
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
    
    current.alphaSlider = value;
}

- (IBAction)doneEditing:(id)sender {
    pictureModel *current = [_imageArray objectAtIndex: _selectedIndex];
    current.labelText = _imageLabel.text;
    [sender resignFirstResponder];
}

- (IBAction)swapPhotos:(UISegmentedControl*)sender {
    pictureModel *current = [_imageArray objectAtIndex: sender.selectedSegmentIndex];
    [_imageButton setImage:current.image forState:UIControlStateNormal];
    _imageLabel.text = current.labelText;
    _alphaSlider.value = current.alphaSlider;
    _alphaField.text = [NSString stringWithFormat:@"%d", (int)round(current.alphaSlider*100)];
    _imageLabel.hidden = current.hideLabel;
    [__labelSwitch setOn:!current.hideLabel];
    _selectedIndex = sender.selectedSegmentIndex;
    _imageButton.alpha = current.alphaSlider;
}

- (IBAction)labelsOff:(UISwitch *)sender {
    pictureModel *current = [_imageArray objectAtIndex: _selectedIndex];
    
    if(sender.isOn){
        _imageLabel.hidden = false;
        current.hideLabel = false;
    }
    else{
        _imageLabel.hidden = true;
        current.hideLabel = true;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: true];
}

- (void)_hideUI:(bool)value{
    _imageLabel.hidden = value;
    _imageSelector.hidden = value;
    _alphaSlider.hidden = value;
    _alphaField.hidden = value;
    __labelSwitch.hidden = value;
    __maximizeImageButton.hidden = value;
    _opacityLabel.hidden = value;
    _addPhotoButton.hidden = value;
}

- (IBAction)_maximizePressed:(id)sender {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [_imageButton setBounds:screenRect];
    
    _imageButton.center = CGPointMake(screenRect.size.width/2.0, screenRect.size.height/2.0);
    
    [self _hideUI:true];
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

- (IBAction)_addPicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }

    [imagePicker setDelegate:self];

    [self presentModalViewController:imagePicker animated:YES];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    pictureModel *newImage = [[pictureModel alloc] init];
    
    newImage.image = image;
    newImage.labelText = @"New Image!";
    newImage.hideLabel = false;
    newImage.alphaSlider = .5;
    [_imageArray addObject:newImage];
    _selectedIndex = [_imageArray count]-1;
    
    [_imageSelector insertSegmentWithTitle:[NSString stringWithFormat:@"%d", [_imageArray count]] atIndex:_selectedIndex animated:false];
    [self dismissModalViewControllerAnimated:YES];
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
    pictureModel *current = [_imageArray objectAtIndex: _selectedIndex];
    current.labelText = _imageLabel.text;
    [_alphaField resignFirstResponder];
    [_imageLabel resignFirstResponder];
}

@end














