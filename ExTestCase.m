#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>

@interface ExTestCase : GHTestCase { }
@end

@implementation ExTestCase

-(void) testShouldFail {
	GHAssertTrue(false, @"Test was expected to fail");
}

-(void) testShouldPass {
	GHAssertTrue(true, @"Test was expected to pass");
}

@end
