//
//  ViewController.h
//  PDFTest
//
//  Created by Geoff Spears on 12/19/2013.
//  Copyright (c) 2013 Geoff Spears. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>

#import "PDFPageRenderer.h"

@interface ViewController : UIViewController <RendererDelegate, MFMailComposeViewControllerDelegate>

@end
