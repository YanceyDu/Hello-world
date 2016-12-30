//
//  ViewController.m
//  YCEmojiTest
//
//  Created by Yancey on 16/3/22.
//  Copyright © 2016年 Yancey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTextField1;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField2;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad{
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    UILocalNotification *not = [[UILocalNotification alloc]init];
    not.alertTitle = [ViewController replaceUnicode:@"sssssssssssss\\Ud83d\\Ude77"];
    not.alertBody = [ViewController replaceUnicode:@"sssssssssssss\\Ud83d\\Ude2c"];
    not.applicationIconBadgeNumber = 2;
    not.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    [[UIApplication sharedApplication]scheduleLocalNotification:not];
}

- (IBAction)buttonClick {
    NSString *inputString1 = self.inputTextField1.text;
    NSString *inputString2 = self.inputTextField2.text;

    unsigned int low = 0;
    unsigned int high = 0;
    NSScanner *lowScanner= [NSScanner scannerWithString:inputString1];
    [lowScanner scanHexInt:&low];
    NSScanner *highScanner = [NSScanner scannerWithString:inputString2];
    [highScanner scanHexInt:&high];
    
//    NSInteger low = [lowStr integerValue];
//    NSInteger high = [highStr integerValue];
//    NSInteger low = [[NSString stringWithFormat:@"0x%@",[inputString1 substringFromIndex:2]] integerValue];
//    NSInteger high = [[NSString stringWithFormat:@"0x%@",[inputString2 substringFromIndex:2]] integerValue];
    
    NSMutableString *resultStr = [NSMutableString string];
    
    for(NSInteger i = low; i <= high; i++){
//        [resultStr appendString:[ViewController replaceUnicode:[NSString stringWithFormat:@"\\u%ld",(long)i]]];
        [resultStr appendString:[NSString stringWithFormat:@"\\u%lx",(long)i]];
    }
    
    self.resultLabel.text = [ViewController replaceUnicode:[resultStr copy]];
//    self.resultLabel.text = resultStr;
//    NSLog([ViewController replaceUnicode:[resultStr copy]]);
//    self.resultLabel.text = resultStr;
    
}

+ (NSString *)stringFromHexString:(NSString *)hexString { //
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString; 
}


+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
//    NSLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\\\r\\\\n"withString:@"\\n"];
}
@end
