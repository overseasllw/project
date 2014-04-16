//
//  regTableViewController.m
//  loginMain2
//
//  Created by Ajit Randhawa on 7/18/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "regTableViewController.h"
#import "LRAParams.h"

@interface regTableViewController ()

@end

@implementation regTableViewController

- (id)init
{
    self = [super initWithNibName:@"regTableViewController" bundle:nil];
    if(self) {
        
        //set the registration url
        URL_REGISTER = @"http://10.1.10.60/jquesada/stable/loginsys2/Register.php";
        
        //set up all the input identifiers
        I_EMAIL = @"Email";
        I_PASS1 = @"Password";
        I_PASS2 = @"Confirm Password";
        
        I_FIRST_NAME = @"First Name";
        I_LAST_NAME = @"Last Name";
        I_MIDDLE = @"Middle Initial";
        I_SEX = @"Sex";
        I_BIRTH_DATE = @"Birth Date";
        I_CELL_PHONE = @"Cell Phone";
        
        I_ADDRESS1 = @"Address 1";
        I_ADDRESS2 = @"Address 2";
        I_CITY = @"City";
        I_STATE = @"State";
        I_ZIPCODE = @"Zip Code";
        
        I_BTN_REGISTER = @"Register";
        I_BTN_CANCEL = @"Cancel";
        
        //set the names of the variables in the POST array
        POST_EMAIL = @"emailaddress";
        POST_PASS1 = @"password";
        POST_PASS2 = @"confirmpassword";
        
        POST_FIRST_NAME = @"firstname";
        POST_LAST_NAME = @"lastname";
        POST_MIDDLE = @"middleinitial";
        POST_SEX = @"sex";
        POST_BIRTH_DATE = @"birthdate";
        POST_CELL_PHONE = @"cellphone";
        
        POST_ADDRESS1 = @"address1";
        POST_ADDRESS2 = @"address2";
        POST_CITY = @"city";
        POST_STATE = @"state";
        POST_ZIPCODE = @"zipcode";
        
        //specify which fields are in the credentials section in the table
        credentialsInfo = [NSArray arrayWithObjects:
                           I_EMAIL,
                           I_PASS1,
                           I_PASS2,
                           nil];
        
        //specify which fields are in the user info section in the table
        userInfo = [NSArray arrayWithObjects:
                    I_FIRST_NAME,
                    I_LAST_NAME,
                    I_MIDDLE,
                    I_SEX,
                    I_BIRTH_DATE,
                    I_CELL_PHONE,
                    nil];
        
        //specify which fields are in the billing info section in the table
        billingInfo = [NSArray arrayWithObjects:
                       I_ADDRESS1,
                       I_ADDRESS2,
                       I_CITY,
                       I_STATE,
                       I_ZIPCODE,
                       nil];
        
        //specify the button names in the buttons section at the end of the table
        buttons = [NSArray arrayWithObjects:
                   I_BTN_REGISTER,
                   I_BTN_CANCEL,
                   nil];
        
        //specify the order of table sections
        sections = [NSArray arrayWithObjects:
                    credentialsInfo,
                    userInfo,
                    billingInfo,
                    buttons,
                    nil];
        
        //establish which fields are required
        requiredFields = [NSArray arrayWithObjects:
                          I_EMAIL,
                          I_PASS1,
                          I_PASS2,
                          I_FIRST_NAME,
                          I_LAST_NAME,
                          I_BIRTH_DATE,
                          I_CELL_PHONE,
                          I_ADDRESS1,
                          I_CITY,
                          I_STATE,
                          I_ZIPCODE,
                          nil];
        
        //set headers for each section
        headers = [NSArray arrayWithObjects:
                   @"Account Credentials",
                   @"Personal Info",
                   @"Billing Address",
                   nil];
        
        //set footers for each section
        footers = [NSArray arrayWithObjects:
                   @"The email address and password you will use to access your account",
                   @"Basic account holder info",
                   @"Your billing address",
                   nil];
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [LRAParams mapFields];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //build all the controls
        if ([identifier isEqualToString:I_EMAIL]) {
            TF_EMAIL = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_EMAIL setKeyboardType:UIKeyboardTypeEmailAddress];
            [TF_EMAIL setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [TF_EMAIL setAutocorrectionType:UITextAutocorrectionTypeNo];
            [TF_EMAIL setPlaceholder:@"email@domain.com"];
            [TF_EMAIL setDelegate:self];
            [cell.contentView addSubview:TF_EMAIL];
        }
        else if ([identifier isEqualToString:I_PASS1]) {
            TF_PASS1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_PASS1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [TF_PASS1 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [TF_PASS1 setPlaceholder:@"Password (8 characters minimum)"];
            [TF_PASS1 setSecureTextEntry:YES];
            [TF_PASS1 setDelegate:self];
            [cell.contentView addSubview:TF_PASS1];
        }
        else if ([identifier isEqualToString:I_PASS2]) {
            TF_PASS2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_PASS2 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [TF_PASS2 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [TF_PASS2 setPlaceholder:@"Retype password"];
            [TF_PASS2 setSecureTextEntry:YES];
            [TF_PASS2 setDelegate:self];
            [cell.contentView addSubview:TF_PASS2];
        }
        else if ([identifier isEqualToString:I_FIRST_NAME]) {
            TF_FIRST_NAME = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_FIRST_NAME setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [TF_FIRST_NAME setAutocorrectionType:UITextAutocorrectionTypeNo];
            [TF_FIRST_NAME setPlaceholder:@"First Name (required)"];
            [TF_FIRST_NAME setDelegate:self];
            [cell.contentView addSubview:TF_FIRST_NAME];
        }
        else if ([identifier isEqualToString:I_LAST_NAME]) {
            TF_LAST_NAME = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_LAST_NAME setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [TF_LAST_NAME setAutocorrectionType:UITextAutocorrectionTypeNo];
            [TF_LAST_NAME setPlaceholder:@"Last Name (required)"];
            [TF_LAST_NAME setDelegate:self];
            [cell.contentView addSubview:TF_LAST_NAME];
        }
        else if ([identifier isEqualToString:I_MIDDLE]) {
            TF_MIDDLE = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_MIDDLE setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [TF_MIDDLE setAutocorrectionType:UITextAutocorrectionTypeNo];
            [TF_MIDDLE setPlaceholder:@"Middle Initial (optional)"];
            [TF_MIDDLE setDelegate:self];
            [cell.contentView addSubview:TF_MIDDLE];
        }
        else if ([identifier isEqualToString:I_SEX]) {
            SC_SEX = [[UISegmentedControl alloc] initWithFrame:CGRectMake(50, 5, 200, 34)];
            [SC_SEX insertSegmentWithTitle:@"Male" atIndex:0 animated:NO];
            [SC_SEX insertSegmentWithTitle:@"Female" atIndex:1 animated:NO];
            [SC_SEX setSelectedSegmentIndex:0];
            [cell.contentView addSubview:SC_SEX];
        }
        else if ([identifier isEqualToString:I_BIRTH_DATE]) {
            TF_BIRTH_DATE = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_BIRTH_DATE setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [TF_BIRTH_DATE setPlaceholder:@"Birth Date: MM/DD/YYYY (required)"];
            [TF_BIRTH_DATE setDelegate:self];
            [cell.contentView addSubview:TF_BIRTH_DATE];
        }
        else if ([identifier isEqualToString:I_CELL_PHONE]) {
            TF_CELL_PHONE = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_CELL_PHONE setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [TF_CELL_PHONE setPlaceholder:@"Cell Phone: ########## (required)"];
            [TF_CELL_PHONE setDelegate:self];
            [cell.contentView addSubview:TF_CELL_PHONE];
        }
        else if ([identifier isEqualToString:I_ADDRESS1]) {
            TF_ADDRESS1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_ADDRESS1 setPlaceholder:@"Street Address (required)"];
            [TF_ADDRESS1 setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [TF_ADDRESS1 setAutocorrectionType:UITextAutocorrectionTypeYes];
            [TF_ADDRESS1 setDelegate:self];
            [cell.contentView addSubview:TF_ADDRESS1];
        }
        else if ([identifier isEqualToString:I_ADDRESS2]) {
            TF_ADDRESS2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_ADDRESS2 setPlaceholder:@"Apt, Suite, etc. (optional)"];
            [TF_ADDRESS2 setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [TF_ADDRESS2 setAutocorrectionType:UITextAutocorrectionTypeYes];
            [TF_ADDRESS2 setDelegate:self];
            [cell.contentView addSubview:TF_ADDRESS2];
        }
        else if ([identifier isEqualToString:I_CITY]) {
            TF_CITY = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_CITY setPlaceholder:@"City (required)"];
            [TF_CITY setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [TF_CITY setAutocorrectionType:UITextAutocorrectionTypeYes];
            [TF_CITY setDelegate:self];
            [cell.contentView addSubview:TF_CITY];
        }
        else if ([identifier isEqualToString:I_STATE]) {
            TF_STATE = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_STATE setPlaceholder:@"State: XX (required)"];
            [TF_STATE setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
            [TF_STATE setAutocorrectionType:UITextAutocorrectionTypeNo];
            [TF_STATE setDelegate:self];
            [cell.contentView addSubview:TF_STATE];
        }
        else if ([identifier isEqualToString:I_ZIPCODE]) {
            TF_ZIPCODE = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
            [TF_ZIPCODE setPlaceholder:@"Zip Code: ##### (required)"];
            [TF_ZIPCODE setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [TF_ZIPCODE setDelegate:self];
            [cell.contentView addSubview:TF_ZIPCODE];
        }
        else if ([identifier isEqualToString:I_BTN_REGISTER]) {
            cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.contentView.backgroundColor = [UIColor clearColor];
            BUTTON_REGISTER = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [BUTTON_REGISTER setTitle:@"Register" forState:UIControlStateNormal];
            [BUTTON_REGISTER setTitle:@"Working..." forState:UIControlStateSelected];
            [BUTTON_REGISTER setFrame:CGRectMake(50, 0, 200, 40)];
            [BUTTON_REGISTER addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:BUTTON_REGISTER];
        }
        else if ([identifier isEqualToString:I_BTN_CANCEL]) {
            cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.contentView.backgroundColor = [UIColor clearColor];
            BUTTON_CANCEL = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [BUTTON_CANCEL setTitle:@"Cancel" forState:UIControlStateNormal];
            [BUTTON_CANCEL setFrame:CGRectMake(50, 0, 200, 40)];
            [BUTTON_CANCEL addTarget:self action:@selector(cancelRegistration) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:BUTTON_CANCEL];
        }
        
    }
    
    return cell;
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section < [headers count]) {
        return [headers objectAtIndex:section];
    } else {
        return nil;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(section < [footers count]) {
        return [footers objectAtIndex:section];
    } else {
        return nil;
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)cancelRegistration
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)doRegister
{

    if ([self checkFields]) {
        
        NSMutableString *requestString = [NSMutableString new];
        NSData *responseData = [NSData new];
        NSHTTPURLResponse *resp;
        NSError *err;
        
        //create a new request and set it up to look like a form submission
        NSURL *url = [NSURL URLWithString:URL_REGISTER];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        //[req setValue:@"ios51" forHTTPHeaderField:@"device-api-version"];
        
        //build the request string
        [requestString appendFormat:@"%@=%@", POST_EMAIL, [TF_EMAIL text]];
        [requestString appendFormat:@"&%@=%@", POST_PASS1, [TF_PASS1 text]];
        [requestString appendFormat:@"&%@=%@", POST_PASS2, [TF_PASS2 text]];
        [requestString appendFormat:@"&%@=%@", POST_FIRST_NAME, [TF_FIRST_NAME text]];
        [requestString appendFormat:@"&%@=%@", POST_LAST_NAME, [TF_LAST_NAME text]];
        [requestString appendFormat:@"&%@=%@", POST_SEX, [SC_SEX titleForSegmentAtIndex:[SC_SEX selectedSegmentIndex]]];
        [requestString appendFormat:@"&%@=%@", POST_BIRTH_DATE, [TF_BIRTH_DATE text]];
        [requestString appendFormat:@"&%@=%@", POST_CELL_PHONE, [TF_CELL_PHONE text]];
        [requestString appendFormat:@"&%@=%@", POST_ADDRESS1, [TF_ADDRESS1 text]];
        [requestString appendFormat:@"&%@=%@", POST_CITY, [TF_CITY text]];
        [requestString appendFormat:@"&%@=%@", POST_STATE, [TF_STATE text]];
        [requestString appendFormat:@"&%@=%@", POST_ZIPCODE, [TF_ZIPCODE text]];
        
        if ([[TF_MIDDLE text] length] > 0) {
            [requestString appendFormat:@"&%@=%@", POST_MIDDLE, [TF_MIDDLE text]];
        }
        
        if ([[TF_ADDRESS2 text] length] > 0) {
            [requestString appendFormat:@"&%@=%@", POST_ADDRESS2, [TF_ADDRESS2 text]];
        }
        
        //process the request string to be in a URL compliant format
        [requestString setString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"\n\nRegistration Request String: %@\n\n", requestString);
        
        //form the request body and send the request
        [req setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
        responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
        
        //check if a response was received
        if (responseData == nil) {
            //no data received
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Server could not be reached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        }
        else {
            NSDictionary *messages = [NSDictionary new];
            messages = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
            NSLog(@"JSON error: %@", err);
            NSArray *titles = [messages objectForKey:@"ORDER"];
            for (NSString *title in titles) {
                if([title isEqualToString:@"ORDER"]){
                    continue;
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:title
                                                message:[messages objectForKey:title]
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil] show];
                }
            }
        }
    }
} //end of submit function

- (BOOL)checkFields
{
    
    UITableViewCell *errorCell;
    NSMutableArray *errorMessages = [NSMutableArray new];
    
    BOOL canSend = NO;
    
    //iterate through each cell and check if its text is valid.
    for (NSArray *section in sections) {
        
        if ([section isEqualToArray:buttons]) {
            break;
        }
        
        for (NSString *identifier in section) {
            
            NSIndexPath *path = [NSIndexPath indexPathForItem:[section indexOfObject:identifier] inSection:[sections indexOfObject:section]];
            
            errorCell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:path];
            
            //handling for each cell
            if ([identifier isEqualToString:I_EMAIL] && [requiredFields containsObject:identifier]) {
                if ([TF_EMAIL text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    [errorMessages addObject:@"Please enter an email address"];
                    
                }
                //implement regex checking (currently done on the server)
            }
            else if ([identifier isEqualToString:I_PASS1] && [requiredFields containsObject:identifier]) {
                if ([TF_PASS1 text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    [errorMessages addObject:@"Please enter a password"];
                    
                }
                else if ([[TF_PASS1 text] length] < 8){
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    [errorMessages addObject:@"Password is too weak.  Enter a password containing at least 8 characters"];
                    
                }
            }
            else if ([identifier isEqualToString:I_PASS2] && [requiredFields containsObject:identifier]) {
                if ([TF_PASS2 text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    [errorMessages addObject:@"Please retype your password"];
                    
                } else if (![[TF_PASS1 text] isEqualToString:[TF_PASS2 text]]) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    [errorMessages addObject:@"Passwords don't match"];
                    
                }
            }
            else if ([identifier isEqualToString:I_FIRST_NAME] && [requiredFields containsObject:identifier]) {
                if ([TF_FIRST_NAME text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    //add some regex checking here maybe
                    [errorMessages addObject:@"Enter your first name"];
                    
                } 
            }
            else if ([identifier isEqualToString:I_LAST_NAME] && [requiredFields containsObject:identifier]) {
                if ([TF_LAST_NAME text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    //add some regex checking here maybe
                    [errorMessages addObject:@"Enter your last name"];
                    
                }
            }
            else if ([identifier isEqualToString:I_MIDDLE]) {
                //do some stuff here (not really sure what though)
                //probably add some regex checking
                
            }
            else if ([identifier isEqualToString:I_BIRTH_DATE] && [requiredFields containsObject:identifier]) {
                //add regex checking
                if ([TF_BIRTH_DATE text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    //add some regex checking here maybe
                    [errorMessages addObject:@"Enter your birth date in MM/DD/YYYY format"];
                    
                }
            }
            else if ([identifier isEqualToString:I_CELL_PHONE] && [requiredFields containsObject:identifier]) {
                //add regex checking
                if ([TF_CELL_PHONE text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    //add some regex checking here maybe
                    [errorMessages addObject:@"Enter your 10-digit cell phone number"];
                    
                }
            }
            else if ([identifier isEqualToString:I_ADDRESS1] && [requiredFields containsObject:identifier]) {
                //add regex checking
                if ([TF_ADDRESS1 text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    //add some regex checking here maybe
                    [errorMessages addObject:@"Enter your street address"];
                    
                }
                
            }
            else if ([identifier isEqualToString:I_ADDRESS2]) {
                //do some stuff here (not really sure what though)
                //probably add some regex checking
            }
            else if ([identifier isEqualToString:I_CITY] && [requiredFields containsObject:identifier]) {
                //add regex checking
                if ([TF_CITY text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    //add some regex checking here maybe
                    [errorMessages addObject:@"Enter your city of residence"];
                    
                }
            }
            else if ([identifier isEqualToString:I_STATE] && [requiredFields containsObject:identifier]) {
                //add regex checking
                if ([TF_STATE text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    //add some regex checking here maybe
                    [errorMessages addObject:@"Enter your state of residence"];
                    
                }
            }
            else if ([identifier isEqualToString:I_ZIPCODE] && [requiredFields containsObject:identifier]) {
                //add regex checking
                if ([TF_ZIPCODE text] == nil) {
                    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewRowAnimationTop animated:YES];
                    //add some regex checking here maybe
                    [errorMessages addObject:@"Enter your billing zip code"];
                    
                }
            }
            
        }
        
    }
    
    if ([errorMessages count] == 0) {
        canSend = YES;
    }
    else {
        
        for (NSString *errorMsg in errorMessages) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    }
    
    return canSend;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    UITextField *nextField;
    
    //determine what the next textfield should be
    if([textField isEqual:TF_EMAIL]) {
        nextField = TF_PASS1;
    }
    else if([textField isEqual:TF_PASS1]) {
        nextField = TF_PASS2;
    }
    else if([textField isEqual:TF_PASS2]) {
        nextField = TF_FIRST_NAME;
    }
    else if([textField isEqual:TF_FIRST_NAME]) {
        nextField = TF_LAST_NAME;
    }
    else if([textField isEqual:TF_LAST_NAME]) {
        nextField = TF_MIDDLE;
    }
    else if([textField isEqual:TF_MIDDLE]) {
        nextField = TF_BIRTH_DATE;
    }
    else if([textField isEqual:TF_BIRTH_DATE]) {
        nextField = TF_CELL_PHONE;
    }
    else if([textField isEqual:TF_CELL_PHONE]) {
        nextField = TF_ADDRESS1;
    }
    else if([textField isEqual:TF_ADDRESS1]) {
        nextField = TF_ADDRESS2;
    }
    else if([textField isEqual:TF_ADDRESS2]) {
        nextField = TF_CITY;
    }
    else if([textField isEqual:TF_CITY]) {
        nextField = TF_STATE;
    }
    else if([textField isEqual:TF_STATE]) {
        nextField = TF_ZIPCODE;
    }
    else if([textField isEqual:TF_ZIPCODE]) {
        nextField = nil;
    }
    
    if(nextField != nil) {
        UITableViewCell *containerCell = (UITableViewCell*)[[nextField superview] superview];
        NSIndexPath *path = [self.tableView indexPathForCell:containerCell];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [nextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Success"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
