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

Using TBXMLEx
=============
TBXMLEx is built on top of TBXML, so if you are already using it in your projects, you will get 100% compatibiliy - even the import headers are the same. The extensions this library provides, on the other hand, are available via the header file *TBXMLEx.h*. 

Whilte TBXML itself is great, TBXMLEx adds a thin layer on top of that in order to provide an easier to write, with a more OO friedly interface, preventing from some programming errors of happening, like infinite loops or crashes due to inexistent nodes or attributes. 

Also, a very important enhancement that TBXMLEx has is that the parser will not crash if the XML is not well formed. Instead, it will just stop parsing and set the attribute _invalidXML_ to _YES_. The error description, if any, will be available in the _parsingErrorDescription_ property.

~~~~~~ {objective-c}
#include "TBXMLEx.h"

NSString *xml = @"<files> \
	<file timestamp='1234567890' size='123' createdAt='01/01/20011'>file1.jpg</file> \
	<file timestamp='1234567890' size='8934' createdAt='02/01/20011'>file2.jpg</file> \
	<file timestamp='1234567890' size='2344' createdAt='03/01/20011'>file3.jpg</file> \
	<file timestamp='1234567890' size='2309842' createdAt='04/01/20011'>file4.jpg</file> \
</files>";

TBXMLEx *xml = [TBXMLEx parserWithXML:xml];

if (xml.rootElement) {
	TBXMLElementEx *fileNode = [xml.rootElement child:@"file"];

	while ([fileNode next]) {
	  // You can access the attributes through a dictionary
		NSDictionary *allAttributes = fileNode.attributes;
		NSLog(@"Timestamp: %@", [allAttributes objectWithKey:@"timestamp"]);
	
	  // Or you can have direct access to any specific attribute
		NSLog(@"Size: %d", [fileNode intAttribute:@"size"]);
		NSLog(@"createdAt: %@", [fileNode attribute:@"createdAt"]);
		NSLog(@"Filename: %@", fileNode.value); // or fileNode.text
	}
}
~~~~~~

### API

* Import "TBXMLEx.h"
* Create a parser with [TBXMLEx parserWithXML:(NSString *) contents], passing the XML contents as argument. It will return an auto-release object.
* The root element is available via the property _rootElement_ of _TBXMLEx_ (which is returned by _parserWithXML_)
* Each element, including _rootElement_, is a type of _TBXMLElementEx_
* The method _next_ of _TBXMLElementEx_ advances the pointer to the next available element. Use it to loop through the elements
* To get the attributes of a given element, you can either get them all at once by calling the _attributes_ property (like _someNode.attributes_), or accessing them directly using any of the helper methods: _attribute:(NSString *)_, _intAttribute:(NSString *)_ or _longAttribute:(NSString *)_
* To access the value of a tag or its CDATA, you can use either _text_ or _value_
* If the XML is not well formed, the property _invalidXML_ of _TBXMLEx_ will be set to _YES_, and the error description (if any) will be available through the _parsingErrorDescription_ property.

Contributing to the project
===========================
Enhancements and fixes are very welcome. In order to do, please fork the project (instructions at http://help.github.com/fork-a-repo/), do your changes, and then send a pull request (instructions at http://help.github.com/send-pull-requests/).

Test cases
===============
TBXMLEx uses GHUnit as unit testing framework, which is included as submodule. Haowever, the compiled framework is also available so you won't need to compile it by hand. If - for any reason - you wish to do so, run *git submodule init* and follow the instructions at http://longweekendmobile.com/2011/02/23/tdd-best-practices-testing-in-ios4-with-ghunit-part-1.

To run the tests, change the _Active Target_ in XCode to _Tests_, and click _Build and Run_. The tests run on the Simulator. 

