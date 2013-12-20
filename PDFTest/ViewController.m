//
//  ViewController.m
//  PDFTest
//
//  Created by Geoff Spears on 12/19/2013.
//  Copyright (c) 2013 Geoff Spears. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, readwrite) NSInteger count;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ViewController 

static NSString *filename = @"test.pdf";

-(IBAction)generateButtonTapped:(id)sender
{
    NSString *number = [self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
    self.count = [number integerValue];
    [self savePDFToDisk];
}

-(void)savePDFToDisk
{
    PDFPageRenderer *renderer = [[PDFPageRenderer alloc] init];
    renderer.delegate = self;
    UIMarkupTextPrintFormatter *formatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:self.sampleHTML];
    [renderer addPrintFormatter:formatter startingAtPageAtIndex:0];
    [renderer saveToPDF:self.fullPath];
}

- (NSString *)fullPath
{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:filename];
}

-(NSString *)sampleHTML
{
    return [NSString stringWithFormat:@"<!DOCTYPE html><html><head/><body><table>%@</table></body></html>", [self duplicatedText:self.count]];
}

-(NSString *)duplicatedText:(int)numberOfLines
{
    NSMutableString *toReturn = [[NSMutableString alloc] initWithCapacity:numberOfLines * 69];
    for(int i = 1; i <= numberOfLines; i++)
    {
        [toReturn appendFormat:@"<tr><td>%d: All work and no play makes Geoff a dull boy.</td></tr>", i];
    }
    return toReturn;
}

-(void)renderingComplete:(NSString *)filePath
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *exportView = [[MFMailComposeViewController alloc] init];
        exportView.mailComposeDelegate = self;

        NSString *fileType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(kUTTypePDF, kUTTagClassMIMEType);
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        if(data)
        {
            [exportView addAttachmentData:data mimeType:fileType fileName:filename];
        }
        [self presentViewController:exportView animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No email configured." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultSent:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No email configured." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
    }
}

@end
