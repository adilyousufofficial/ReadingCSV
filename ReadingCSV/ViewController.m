//
//  ViewController.m
//  ReadingCSV
//
//  Created by Adil Yousuf on 13/12/2021.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

NSMutableArray* translated_language;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//-(NSString *)dataFilePath {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:@"myfile.csv"]; //Localizable.strings
//}

- (IBAction)didTapCreateCSV:(id)sender {
    // For CSV File :
    NSMutableString *stringToWrite = [[NSMutableString alloc] init];
//    [stringToWrite appendString:[NSString stringWithFormat:@"First Name,Last Name,Full Name,Phone Number, Email,Job, organizationName,Note\n\n"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i = 0 ;i<[translated_language count];i++)     {
            [stringToWrite appendString:[NSString stringWithFormat:@"%@\n",[translated_language objectAtIndex:i]]];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *documentDirectory=[paths objectAtIndex:0];
            NSString *strBackupFileLocation = [NSString stringWithFormat:@"%@/%@", documentDirectory,@"Localizable.strings"];
            
            NSError *error = NULL;

            BOOL success = [stringToWrite writeToFile:strBackupFileLocation atomically:YES encoding:NSUTF8StringEncoding error:&error]; //[stringToWrite writeToFile:strBackupFileLocation atomically:YES encoding:NSUTF8StringEncoding error:error:&error];

            if (!success) {
                NSLog(@"oh no! - %@",error.localizedDescription);
            } else {
                NSLog(@"File Path: %@", strBackupFileLocation);
            }
        });
    });
}

- (IBAction)didTapReadCSV:(id)sender {
    NSString* key;
    NSString* translation_english;
    NSString* translation;
    translated_language = [[NSMutableArray alloc] init];
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"final" ofType:@"csv"];
    NSString *strFile = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    if (!strFile) {
        NSLog(@"Error reading file.");
    }
    NSArray *arrayCountry = [[NSArray alloc] init];
    arrayCountry = [strFile componentsSeparatedByString:@"\n"];
    
    for(NSString *countryname in arrayCountry) {
//        NSLog(@"%@", countryname);
        NSArray* sp = [countryname componentsSeparatedByString:@","];
        key = sp[0];
//        for (int i = 1; i < sp.count - 1; i++) {
//            <#statements#>
//        }
        
        NSString* str = @"";
        for (int j=1; j<sp.count;j++) {
            if ([self isEmpty:str]) {
                str = sp[j];
            } else {
                str = [NSString stringWithFormat:@"%@,%@", str, sp[j]];
            }
        }
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        translation_english = str;//sp[1];
        key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        translation_english = [translation_english stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        translation = [NSString stringWithFormat:@"%@ = %@",key,translation_english];
        translation = [translation stringByAppendingString:@";"];
        NSLog(@"%@", translation);
        [translated_language addObject: translation];
    }
    NSLog(@"Translated Language Count: %lu", (unsigned long)[translated_language count]);
    NSLog(@"Countries Count: %lu", (unsigned long)[arrayCountry count]);
}

- (BOOL) isEmpty:(NSString*)str{

    if(str == nil || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]){
        return true;
    }
    return false;
}

@end
