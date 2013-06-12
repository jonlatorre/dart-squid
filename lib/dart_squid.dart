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
*     <script type="application/javascript" xlink:href="../../lib/packages/browser/dart.js"></script>
*     <script type="application/dart" xlink:href="yourAppFileContainingMain.dart"/>
*
* *HTML Document:* the following lines will be placed just after the closing </body>
* element tag:
*
*     <script src="../../lib/packages/browser/dart.js"></script>
*     <script type="application/dart" src="yourAppFileContainingMain.dart"/>
*
* **Note:** see the resources sub-directory within the dart-squid project for a
* prototypical SVG or HTML document that can help fulfill the requirements of this
* first step (see: prototypical_app_container.svg / .html files).
*
* ### 2) Implement Dart Code and Use dart-squid Components
* Every Dart application requires an entry-point method of `main()`, and that method
* will reside in the .dart file specified in the `<script>` tag in our container document.
*
* The dart-squid library will need to be included in this .dart file:
*
*     import 'path-to-library/dart_squid.dart' as squid; //(prefix optional)
*
* Within `main()`, it will be helpful to declare a few variables, with one referencing
* the inner SVG Element (see Step 1 above) that will be our [Application.canvas]:
*
*     squid.Application globalApplicationObject = null;
*     const String APP_CANVAS_ELEMENT_ID    = '#dartsquidAppCanvas';
*     const String APP_NAME                 = 'myAppName';
*
* Just before the end of `main()', we place code that instantiates our [Application]
* object like this:
*
*     globalApplicationObject = new dsvg.Application(APP_NAME, document.query(APP_CANVAS_ELEMENT_ID), optionalImageList );
*
* Now we are ready for writing our widget-based application code to execute...
*
*  ---
*/
//███████████████████████████████████████████████████████████████████████████████████████
library dart_squid;


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// Standard libraries provided by Dart framework
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
import 'dart:html';
import 'dart:math';
import 'dart:svg' hide Rect; //force the use of html.Rect throughout since errors occur otherwise in getBoundingClientRect calls.
import 'dart:async';

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// Code that makes up the dart-squid framework
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
part 'enumerations.dart';
part 'event_types.dart';
part 'events_processor.dart';
part 'exception_types.dart';
part 'object_bounds.dart';
part 'style_targets_css.dart';
part 'svg_defs.dart';                         //i.e., for image-lists, filters, etc.
part 'application.dart';
part 'line_and_color.dart';
part 'widget_borders.dart';
part 'widget_constraints.dart';
part 'widget_metrics.dart';
part 'widget.dart';
part 'globals.dart';
part 'iframe_widget.dart';
part 'html_widget.dart';
part 'tri_state_option_widget.dart';        //i.e., for checkboxes_and_radios

//---------------------------------------------------------------------------------------
// BELOW are IN-PROGRESS (do not push to github yet)
//---------------------------------------------------------------------------------------
part 'composite_widget.dart';               //i.e., test putting some of these together
//part 'image_widget.dart';  //a generalized one without check-state stuff (from tri-state)
//part 'text_widget.dart';
//part 'buttons.dart';
//part 'sliders.dart';
