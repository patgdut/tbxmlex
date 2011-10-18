#import "ParsingDemoViewController.h"
#import "TBXMLEx.h"

@implementation ParsingDemoViewController

-(void) appendResult:(NSString *) s {
	resultView.text = [NSString stringWithFormat:@"%@\n%@", resultView.text, s];
}

-(IBAction) parse:(id) sender {
	resultView.text = @"";

	NSError *error = nil;
	NSString *xmlFilePath = [[NSBundle mainBundle] pathForResource:@"files.xml" ofType:nil];
	NSString *xml = [NSString stringWithContentsOfFile:xmlFilePath encoding:NSUTF8StringEncoding error:&error];
	
	if (error) {
		resultView.text = [NSString stringWithFormat:@"Error opening the file for parsing: %@", [error localizedDescription]];
	}
	else {
		TBXMLEx *parser = [TBXMLEx parserWithXML:xml];
		
		if (!parser.rootElement) {
			resultView.text = @"Could not find the root element. Ouch";
			return;
		}
		
		TBXMLElementEx *fileNode = [parser.rootElement child:@"file"];
		
		while ([fileNode next]) {
			// You can access the attributes through a dictionary
			NSDictionary *allAttributes = fileNode.attributes;
			[self appendResult:[NSString stringWithFormat:@"Timestamp: %@", [allAttributes objectForKey:@"timestamp"]]];
			
			// Or you can have direct access to any specific attribute
			[self appendResult:[NSString stringWithFormat:@"Size: %d", [fileNode intAttribute:@"size"]]];
			
			NSObject *createdAt = [fileNode attribute:@"createdAt"];
			NSString *filename = fileNode.value; // or fileNode.text
			
			if (!createdAt || !filename) {
				// Look for the properties someplace else
				TBXMLElementEx *nameNode = [fileNode child:@"name"];
				
				if (nameNode) {
					filename = nameNode.value;
				}
				
				TBXMLElementEx *attributesNode = [fileNode child:@"attributes"];
				
				// If an attribute does not exist it will simply return "nil", but nevertheless it's 
				// always good check if it exists if you really need it
				if (attributesNode) {
					[self appendResult:[NSString stringWithFormat:@"Created at: %@", [attributesNode child:@"createdAt"].value]];
					[self appendResult:[NSString stringWithFormat:@"Owner: %@", [attributesNode child:@"owner"].value]];
				}
			}
			
			[self appendResult:[NSString stringWithFormat:@"Filename: %@", filename]];
			[self appendResult:@"*****************"];
		}
	}
}

- (void)dealloc {
	[resultView release];
	[super dealloc];
}

@end
