//
//  MDAudioPlayerTableViewCell.h
//  MDAudioPlayerSample
//
//  Created by Matt Donnelly on 04/08/2010.
//  Copyright 2010 Matt Donnelly. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MDAudioPlayerTableViewCell : UITableViewCell
{
	UIView				*contentView;
	
	NSString			*title;
	NSString			*number;
	NSString			*duration;
	
	BOOL				isEven;
	BOOL				isSelectedIndex;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *duration;

@property (nonatomic, assign) BOOL isEven;
@property (nonatomic, assign) BOOL isSelectedIndex;

- (void)drawContentView:(CGRect)r;

@end
