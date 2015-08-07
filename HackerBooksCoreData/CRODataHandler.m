//
//  CRODataHandler.m
//  practica
//
//  Created by Jose Manuel Franco on 16/4/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "CRODataHandler.h"
#import "Book.h"

@implementation CRODataHandler




#pragma mark -Interface Implementation

-(NSArray*) getJsonArray{
    NSArray *jsonArray=nil;
    NSData *data=nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [[paths objectAtIndex:0] stringByAppendingString:@"/"];
    NSString *jsonPath=[documentsDirectoryPath stringByAppendingString:@"json.json"];
    //Descargamos JSON
    [self downloadFileWithData:([NSURL URLWithString:@"https://t.co/K9ziV0z3SJ"])
                          withName:(jsonPath)];
            
    data=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:(jsonPath)]];
    if(data!=nil){
        NSError *error;
        jsonArray=[NSJSONSerialization JSONObjectWithData:data
                                                  options:kNilOptions
                                                    error:&error];
    }
    return jsonArray;
    
}


-(void) addJsonArray:(NSArray*)arrayJSON
   toRealmContext:(RLMRealm *)context{
    
    //
    
    for (NSDictionary *dict in arrayJSON) {
        
        
        //Book
        Book *book=[[Book alloc]initWithTitle:([dict objectForKey:@"title"])
                                     imageUrl:([dict objectForKey:@"image_url"])
                                       pdfUrl:([dict objectForKey:@"pdf_url"])];
        
        
        
        NSArray *tags =[self getObjectFromKey:(@"tags")
                                andDictionary:(dict)];
        
        
        for(NSString *obj in tags){
            //Hacemos un trim a obj
            NSString *trimmedTag = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            Tag *tag=[[Tag alloc]initWithName:trimmedTag];
            [book.tags addObject:tag];
        }
        
        NSArray *authors=[self getObjectFromKey:(@"authors") andDictionary:(dict)];
        for(NSString *obj in authors){
            //Hacemos un trim a obj
            NSString *trimmedTag = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            Author *author=[[Author alloc]initWithName:trimmedTag];
            [book.authors addObject:author];
        }
        
        
        //Añadimos book a Realm
        //Creamos un tag de Favoritos
        Tag *tag=[[Tag alloc]initWithName:@"Favorites"];
        
        [context beginWriteTransaction];
        
        [Tag createOrUpdateInRealm:context
                         withValue:tag];
        [Book createOrUpdateInRealm:context
                          withValue:book];
        
        [context commitWriteTransaction];
        
    }
    
    
}
   
#pragma mark -Class Internal
-(void) downloadFileWithData:(NSURL*)urlData
                    withName:(NSString*)name{
    
    NSData *data=[[NSData alloc ]initWithContentsOfURL:urlData];
    [data writeToFile:(name) atomically:YES];
}
    
    
-(NSArray*) getObjectFromKey:(NSString*) key
               andDictionary:(NSDictionary*)dictionary{
    
    NSString *value=[dictionary objectForKey:key];
    return [value componentsSeparatedByString:@","];
}



@end
