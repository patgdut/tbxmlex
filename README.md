About
=====

This project, TBXMLEx ("TBXML with Extensions") is based on http://www.tbxml.co.uk.

TBXML is a light-weight XML document parser written in Objective-C designed for use on Apple iPad, iPhone & iPod Touch devices. TBXML aims to provide the fastest possible XML parsing whilst utilising the fewest resources. This requirement for absolute efficiency is achieved at the expense of XML validation and modification. It is not possible to modify and generate valid XML from a TBXML object and no validation is performed whatsoever whilst importing and parsing an XML document.

The design goals for TBXML are:
-------------------------------
* XML files conforming to the W3C XML spec 1.0 should be passable
* XML parsing should incur the fewest possible resources
* XML parsing should be achieved in the shortest possible time
* It shall be easy to write programs that utilise TBXML

How to include it in your project
=================================
There are two possible ways to include the library onto your project: by directly referencing the classes (easier) or by linking against the static library. 

### Option 1: Directly referencing the classes
This is the easiest approach: just copy all files from the _Classes_ directory to your project and reference them (_Add -> Existing files_), and add the _libz.dylib_ Framework (_Add -> Existing frameworks_). 

### Option 2: Link against the dynamic library
TBXMLEx is set up as a static library, so if you don't want to include the source code in your project but instead only reference the _.a_ file, the steps are:

- In your project, right click (or CTRL + Click) and choose _Add -> Existing files_
- Navigate to the _TBXMLEx_ directory and include the file _TBXMLEx.xcodeproj_. This will directly reference TBXMLEx
- To make sure the previous step worked, expand _TBXMLEx.xcodeproj_, and see if _libTBXMLEx.a_ is listed there
- Now drag and drop _libTBXMLEx.a_ to your project's _Target_, and add it to _Link Binary with Libraries_. Check the image below if you are unsure
- Add the library as a _dependency_ in your target (Target -> Get Info -> Direct Dependencies)
- In the build settings of your target, include the full path to the _Classes_ directory of _TBXMLEx_. This is a necessary, otherwise the compiler won't find the headers

![Screenshot 1](http://github.com/rafaelsteil/tbxmlex/raw/master/help_image1.jpg)

Using TBXMLEx
=============
TBXMLEx is built on top of TBXML, so if you are already using it in your projects, you will get 100% compatibiliy - even the import headers are the same. The extensions this library provides, on the other hand, are available via the header file *TBXMLEx.h*. 

Whilte TBXML itself is great, TBXMLEx adds a thin layer on top of that in order to provide an easier to write, with a more OO friedly interface, preventing from some programming errors of happening, like infinite loops or crashes due to inexistent nodes or attributes. 

Also, a very important enhancement that TBXMLEx has is that the parser will not crash if the XML is not well formed. Instead, it will just stop parsing and set the attribute _invalidXML_ to _YES_. The error description, if any, will be available in the _parsingErrorDescription_ property.

~~~~~~ {objective-c}
#include "TBXMLEx.h"

NSString *xml = @"<files> \
	<file timestamp='1234567890' size='123' createdAt='01/01/20011'>file1.jpg</file> \
	<file timestamp='1234567890' size='8934'> \
		<name>file2.jpg</name> \
		<attributes> \
			<createdAt>01/01/2011 13:45:56</createdAt> \
			<owner>john</owner> \
		</attributes> \
	</file> \
</files>";

TBXMLEx *xml = [TBXMLEx parserWithXML:xml];

// "files" is the rootElement
if (xml.rootElement) {
	TBXMLElementEx *fileNode = [xml.rootElement child:@"file"];

	while ([fileNode next]) {
	  // You can access the attributes through a dictionary
		NSDictionary *allAttributes = fileNode.attributes;
		NSLog(@"Timestamp: %@", [allAttributes objectForKey:@"timestamp"]);
		
		// Or you can have direct access to any specific attribute
		NSLog(@"Size: %d", [fileNode intAttribute:@"size"]);
	  
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
				NSLog(@"Created at: %@", [attributesNode child:@"createdAt"].value); // Will not crash if attribute is nil
				NSLog(@"Owner: %@", [attributesNode child:@"owner"].value);
			}
		}
		
		NSLog(@"Filename: %@", filename);
	}
}
~~~~~~

### API

* Import "TBXMLEx.h"
* Create a parser with [TBXMLEx parserWithXML:(NSString *) contents], passing the XML contents as argument. It will return an auto-released object.
* The root element is available via the property _rootElement_ of _TBXMLEx_ (which is returned by _parserWithXML_). Use it as a starting point for everything else
* Each element, including _rootElement_, is a type of _TBXMLElementEx_
* The method _next_ of _TBXMLElementEx_ advances the pointer to the next available element. Use it to loop through the elements
* To get the attributes of a given element, you can either get them all at once by calling the _attributes_ property (like _someNode.attributes_), or accessing them directly using any of the helper methods: _attribute:(NSString *)_, _intAttribute:(NSString *)_ or _longAttribute:(NSString *)_
* To access the value of a tag or its CDATA, you can use either _text_ or _value_
* If the XML is not well formed, the property _invalidXML_ of _TBXMLEx_ will be set to _YES_, and the error description (if any) will be available through the _parsingErrorDescription_ property.
* To get a child element, use the method _child:(NSString *)_ from _TBXMLElementEx_. Use if even if you have more than one child, and use the _next_ method to navigate through the elements.

Contributing to the project
===========================
Enhancements and fixes are very welcome. In order to do, please fork the project (instructions at http://help.github.com/fork-a-repo/), do your changes, and then send a pull request (instructions at http://help.github.com/send-pull-requests/).

Test cases
===============
TBXMLEx uses GHUnit as unit testing framework, which is included as submodule. Haowever, the compiled framework is also available so you won't need to compile it by hand. If - for any reason - you wish to do so, run *git submodule init* and follow the instructions at http://longweekendmobile.com/2011/02/23/tdd-best-practices-testing-in-ios4-with-ghunit-part-1.

To run the tests, change the _Active Target_ in XCode to _Tests_, and click _Build and Run_. The tests run on the Simulator. 

