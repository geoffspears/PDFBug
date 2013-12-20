//
//  PDFPageRenderer.m
//  PDFTest
//
//  Created by Geoff Spears on 12/19/2013.
//  Copyright (c) 2013 Geoff Spears. All rights reserved.
//

#import "PDFPageRenderer.h"

@implementation PDFPageRenderer

- (CGRect) paperRect
{
    return UIGraphicsGetPDFContextBounds();
}

- (CGRect) printableRect
{
    return CGRectInset(self.paperRect, 20, 20);
}

- (void)saveToPDF:(NSString *)filename
{
    UIGraphicsBeginPDFContextToFile(filename, CGRectZero, nil);
    [self prepareForDrawingPages: NSMakeRange(0, 1)];
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    
    // on large documents on a device the number of pages returned by the UIMarkupTextPrintFormatter
    // is incorrect and causes the resulting PDF to be truncated.
    for ( int i = 0 ; i < self.numberOfPages; i++ )
    {
        UIGraphicsBeginPDFPage();
        [self drawPageAtIndex: i inRect: bounds];
    }
    UIGraphicsEndPDFContext();
    [self.delegate renderingComplete:filename];
}

@end
