/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

//███████████████████████████████████████████████████████████████████████████████████████
/**
* # DART / SVG UI Development Widgets (Components / Controls)
* dart-squid is an open-source [Dart](http://www.dartlang.org/) / [SVG](http://www.w3.org/Graphics/SVG/)
* Quick UI Development framework for browser-based applications.
* SVG (Scalable Vector Graphics) is used for the UI rendering.
* CSS is (indirectly) used for styling of SVG Widgets.
*
* ## Primary Classes
* To quickly become familiar with the dart-squid classes and how they are used to create
* an interactive Dart/SVG-based GUI application, begin with the following classes:
*
*   * [Application] — all applications begin with an instance of this class.
* It implements the application's "canvas" upon which all Widgets will exist and
* interact. It also keeps track of all Widgets used in the application.
*   * [Widget] — the base-class for all visual UI components. Applications will include
* one or more widget objects; these objects can include more specialized derived
* sub-classes like [IFrameWidget].
*
* ---
* # Getting Started
* Refer to the samples directory to view source-code demonstrating how to use the
* components to build an application.
*
* Also, see the [Online dart-squid Samples](http://mv4t.com/dart-squid/samples/samples-index.html) for
* a demonstration of some of features and capabilities of these Widgets.
*
* ## Basics of Creating a dart-squid Application
* In summary, here is what is needed to create a basic dart-squid application...
*
* ### 1) Create Container Document
* Create an SVG document, or create an HTML document with and embedded SVG element.
* Within that SVG, create an embedded (i.e., inner, nested) SVG element that will be used as
* the "canvas" for the application.
* The inner SVG should look something like this:
*
*     <svg id="dartsquidAppCanvas" width="100%" height="100%">
*     </svg>
*
* The HTML or SVG document will need to include `<script>` tags to reference the ".dart" file
* that will contain the `main()` entry-point for your application, as well as a reference to
* the dart.js required library. The `<script>` tags format and placement will depend on your
* outer container-document type.
*
* *SVG Document:* the following lines will be placed just after the opening (outermost)
* SVG element tag:
*
*     <script type="application/javascript" xlink:href="http://dart.googlecode.com/svn/branches/bleeding_edge/dart/client/dart.js"/>
*     <script type="application/dart" xlink:href="yourAppFileContainingMain.dart"/>
*
* *HTML Document:* the following lines will be placed just after the closing </body>
* element tag:
*
*     <script src="http://dart.googlecode.com/svn/branches/bleeding_edge/dart/client/dart.js"></script>
*     <script type="application/dart" src="yourAppFileContainingMain.dart"/>
*
* **Note:** see the resources sub-directory within the dart-squid project for a
* prototypical SVG or HTML document that can help fulfill the requirements of this
* first step (see: prototypicalAppContainer.svg / .html files).
*
* ### 2) Implement Dart Code and Use dart-squid Components
* Every Dart application requires an entry-point method of `main()`, and that method
* will reside in the .dart file specified in the `<script>` tag in our container document.
*
* The dart-squid library will need to be included in this .dart file:
*
*     #import("path-to-library/dart_squid.dart", prefix:'squid'); //(prefix optional)
*
* Within `main()`, it will be helpful to declare a few variables, with one referencing
* the inner SVG Element (see Step 1 above) that will be our [Application.canvas]:
*
*     squid.Application globalApplicationObject = null;
*     final String applicationCanvasElementID  = '#dartsquidAppCanvas';
*     final String applicationName             = 'myAppName';
*
* Still within `main()` we define a method that the [Application] object will transfer
* execution to when it is "ready" (i.e., after it has finished computing canvas
* dimensions and performing basic setup tasks). *Note: this was necessary due to the
* way [Future] completions within the Application object behave with regards
* to the execution-flow of `main()`.*
*
* E.g., this will be our primary application method:
*
*     void runApplication() {
*        ... the primary application code will go here;
*        ... create various Widgets, define properties, setup event-handlers, etc.
*        ... see samples for more ...
*     }
*
* Essentially, that method becomes the "main" program-execution path
* once the Application starts up.
*
* Just before the end of `main()', we place code that instantiates our [Application]
* object like this:
*
*     globalApplicationObject = new squid.Application(applicationName, document.query(applicationCanvasElementID), runApplication );
*
* Notice that `runApplication` is a *method reference* (to a callback routine)
* where the application-execution will begin, as mentioned earlier.
*
*  ---
*/
//███████████████████████████████████████████████████████████████████████████████████████
#library("dart_squid");


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// Standard libraries provided by Dart framework
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
#import('dart:html');
#import('dart:math', prefix: 'Math');

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// Code that makes up the dart-squid framework
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
#source("application.dart");
#source("widget.dart");
#source("common.dart");
#source("iframe_widget.dart");
#source("html_widget.dart");

//---------------------------------------------------------------------------------------
// BELOW are IN-PROGRESS (do not push to github yet)
//---------------------------------------------------------------------------------------
//#source("text.dart");
//#source("buttons.dart");
//#source("sliders.dart");
//#source("checkboxes_and_radios.dart");
