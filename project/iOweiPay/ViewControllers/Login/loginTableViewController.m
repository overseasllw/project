//
//  loginTableViewController.m
//  loginMain2
//
//  Created by Ajit Randhawa on 7/18/12.
//  Copyright (c) 2012 Ajit Randhawa. All rights reserved.
//

#import "loginTableViewController.h"
#import "regTableViewController.h"
#import "questionsTableViewController.h"
#import "forgotPasswordTableViewController.h"

#import "Encrypter.h"
#import "LRAParams.h"

#import "../Segues.h"
#import "MainView.h"

#import "../../DataModel/Account.h"

@interface loginTableViewController ()

@end

@implementation loginTableViewController

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
    
    fieldNames = [NSArray arrayWithObjects:F_EMAIL, F_PASSWORD, nil];
    buttonNames = [NSArray arrayWithObjects:@"Login", @"Forgot Password", @"Sign Up", @"David's Login Page", nil];
    
    groups = [NSArray arrayWithObjects:fieldNames, buttonNames, nil];
    
    headers = [NSArray arrayWithObjects:
               @"Enter Your Email Address and Password", nil];
    footers = [NSArray arrayWithObjects:
               @"",
               @"Need an account?  Click \"Sign Up\" to begin registration.", nil];
    
    NSMutableArray *allItems = [NSMutableArray new];
    [allItems addObjectsFromArray:fieldNames];
    [allItems addObjectsFromArray:buttonNames];
    
    //build all the control objects
    allControls = [NSMutableDictionary new];
    for (NSString *control in allItems) {
        if ([fieldNames containsObject:control]) {
            //if the current item is in the fields array, make a text field control
            UITextField *t = [[UITextField alloc] initWithFrame:CGRectMake(120, 12, 170, 30)];
            if ([control isEqualToString:F_PASSWORD]) {
                [t setSecureTextEntry:YES];
            }
            else {
                [t setKeyboardType:UIKeyboardTypeEmailAddress];
            }
            
            [allControls setValue:t forKey:control];
        }
        
        if ([buttonNames containsObject:control]) {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [b setFrame:CGRectMake(50, 0, 200, 40)];
            [b setTitle:control forState:UIControlStateNormal];
            
            if ([control isEqualToString:@"Login"]) {
                [b addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
                [b setTitle:@"Working..." forState:UIControlStateHighlighted];
            }
            else if ([control isEqualToString:@"Sign Up"]) {
                [b addTarget:self action:@selector(showRegistration) forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([control isEqualToString:@"Forgot Password"]) {
                [b addTarget:self action:@selector(showPasswordReset) forControlEvents:UIControlEventTouchUpInside];
                [b setTitle:@"Working..." forState:UIControlStateHighlighted];
            } else if ([control isEqualToString:@"David's Login Page"])
            {
                [b addTarget:self action:@selector(showNewLoginPage) forControlEvents:UIControlEventTouchUpInside];
            }
            [allControls setValue:b forKey:control];
        }
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)showNewLoginPage
{
    [self performSegueWithIdentifier:@"gotoDavidsLoginScreen" sender:self];
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

- (void)doLogin
{
    /*
    UITextField * emailTextField = [allControls objectForKey:F_EMAIL];
    UITextField * passwordTextField = [allControls objectForKey:F_PASSWORD];
    
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    //create a new request and set it up to look like a form submission
    NSURL *url = [NSURL URLWithString:URL_LOGIN];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [req setTimeoutInterval:30];
    NSHTTPURLResponse *resp;
    NSError *err;
    
    NSMutableString *requestString = [NSMutableString new];
    [requestString appendFormat:@"&%@=%@", [MAP_POST_NAMES objectForKey:F_EMAIL], [[allControls objectForKey:F_EMAIL] text]];
    [requestString appendFormat:@"&%@=%@", [MAP_POST_NAMES objectForKey:F_PASSWORD], [Encrypter sha2:[[allControls objectForKey:F_PASSWORD] text]]];
    
    if ([requestString length] > 0) {
        [requestString deleteCharactersInRange:NSMakeRange(0, 1)];
        [requestString setString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSLog(@"Login Request String: %@", requestString);
    
    
    [req setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *responseData = [NSData new];
    responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
    
    //check if a response was received
    if (responseData == nil) {
        //no data received
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Server could not be reached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
    else {
        NSDictionary *messages = [NSDictionary new];
        messages = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
        NSLog(@"JSON error: %@", err);
        NSArray *titles = [messages objectForKey:@"ORDER"];
        for (NSString *title in titles) {
            
            if ([[messages objectForKey:title] isKindOfClass:[NSString class]]) {
                [[[UIAlertView alloc] initWithTitle:title
                                            message:[messages objectForKey:title]
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
            else {
                continue;
            }
            
        }
        
        //if a USER object was returned, process the login and continue to the main menu
        if([titles containsObject:@"USER"]) {
            
            //the USER object, if login is successful
            NSLog(@"\nUSER: %@", [messages objectForKey:@"USER"]);
            
            /
             
             the returned user info is [messages objectForKey:@"USER"]
             
             insert custom processing for the returned decrypted user info.
             if these values are edited in the application, they need to be returned to the
             userInfo table encrypted using $_SESSION['accountLock'] as the AES key
             
             user info is returned here as an NSDictionary with the following keys:
             accountNumber, firstName, lastName, address, zipcode, city, state, midInitial
             
            
            
            [emailTextField setText:@""];
            [passwordTextField setText:@""];
            */
            //create the main menu view controller and push it onto the screen
    
    // Log in for testing w/ David's stuff
    [Account accountWithLoginCredentials:@"davidq2012@gmail.com" password:@"password" completion:^(LoginResult result) {
        NSLog(@"Logged in as david.");
    }];
    
    //[Account main].userAccountNumber
    
    [self performSegueWithIdentifier:LOGIN_SUCCESS_SEGUE sender:self];
       // }
    //}

}

- (void)showRegistration
{
    [[allControls objectForKey:F_EMAIL] resignFirstResponder];
    [[allControls objectForKey:F_PASSWORD] resignFirstResponder];
    
    regTableViewController *view = [[regTableViewController alloc] init];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)showPasswordReset
{
    [[allControls objectForKey:F_EMAIL] resignFirstResponder];
    [[allControls objectForKey:F_PASSWORD] resignFirstResponder];
    
    UITextField *emailText = [allControls objectForKey:F_EMAIL];
    NSString *email = [emailText text];
    
    //check if there is an email address provided
    if (email == nil || [email length] < 1) {
        [[[UIAlertView alloc] initWithTitle:@"Provide an email" message:@"Provide an email address, then use the \"Forgot Password\" button to reset your password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        return;
    }
    //else make a network request to get the recovery questions
    else {
        
        //create a new request and set it up to look like a form submission
        NSURL *url = [NSURL URLWithString:URL_PASSRESET];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [req setTimeoutInterval:30];
        NSHTTPURLResponse *resp;
        NSError *err;
        
        NSMutableString *requestString = [NSMutableString new];
        [requestString appendFormat:@"&%@=%@", [MAP_POST_NAMES objectForKey:F_EMAIL], [[allControls objectForKey:F_EMAIL] text]];
        
        if ([requestString length] > 0) {
            [requestString deleteCharactersInRange:NSMakeRange(0, 1)];
            [requestString setString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        NSLog(@"Password Reset Request String 1: %@", requestString);
        
        [req setHTTPBody:[requestString dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *responseData = [NSData new];
        responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
        
        //check if a response was received
        if (responseData == nil) {
            //no data received
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Server could not be reached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        }
        else {
            NSDictionary *messages = [NSDictionary new];
            messages = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&err];
            NSLog(@"JSON error: %@", err);
            NSArray *titles = [messages objectForKey:@"ORDER"];
            for (NSString *title in titles) {
                if([title isEqualToString:@"ORDER"] || [title isEqualToString:@"questions"]) continue;
                
                [[[UIAlertView alloc] initWithTitle:title
                                            message:[messages objectForKey:title]
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
            
            //if the question array was returned, initialize a password recovery screen
            if ([messages objectForKey:@"questions"] != nil) {
                NSArray *securityQuestions = [messages objectForKey:@"questions"];
                forgotPasswordTableViewController *view = [[forgotPasswordTableViewController alloc] initWithQuestionArray:securityQuestions];
                
                [self presentViewController:view animated:YES completion:nil];
            }
        }
        
    
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[groups objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [[groups objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if ([buttonNames containsObject:identifier]) {
            //create an empty cell without a border for the registration button
            cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        }
        else {
            //create a label and set some properties for all other cells
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 110, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label.text = identifier;
            [cell.contentView addSubview:label];
        }
        
        [cell.contentView addSubview:[allControls objectForKey:identifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - alert view delegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Setup Security Questions"]) {
        questionsTableViewController *questionView = [[questionsTableViewController alloc] initWithNibName:@"questionsTableViewController" bundle:nil];
        [self presentViewController:questionView animated:YES completion:nil];
    }
}

@end
