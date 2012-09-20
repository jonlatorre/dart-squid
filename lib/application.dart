/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/


//███████████████████████████████████████████████████████████████████████████████████████
/**
* This is the global application-wide class that must be instantiated once per each
* application using our [Widget] components.
* This class will maintain important references to our "Canvas" as well as maintain a
* list of widgets, "selected" widgets, standard fonts, settings, and more.
*
* Although browser-based applications built using this framework can have as their
* *outermost container* either an HTML page or an SVG document, any HTML version
* is simply a "wrapped" version of the SVG doc variety.
*
* The outermost SVG document (wrapped or not), will contain within it another (nested)
* SVG document that is used as our Application [canvas]. Though all Widgets will
* be created within the [canvas] SVG, the outermost SVG will specify the overall
* dimension-constraints placed upon our canvas.
*
* **Note:** some prototypical examples of valid SVG and HTML container documents
* exist in the dart-squid project source-code 'resources' directory. The following
* sections provide some insight into what properties are used and what values you
* may wish to use within your application's SVG container.
*
* # (outermost) SVG Container Notes
* ## Overview
* The outermost SVG element defines the default coordinate system used within and
* establishes, by default, a 1:1 relation with pixels; i.e., an SVG dimensional-unit
* of "1" = "1px" at this point in time.
* An initial viewport coordinate system and an initial user coordinate system exist such
* that the two coordinates systems are identical. The origin in this coordinate system
* places 0,0 at the upper-left corner and all (visible / on-screen) content is rendered
* to the right and below that origin.
*
* Had a 'viewBox' attribute been specified on the SVG element this 1:1
* relation would not necessarily be the in effect. E.g., including the following directive
* could affect that relation: `viewBox="0 0 800 600"`.
* If a viewBox is specified, it could lead to clipping the visible region of the
* SVG document while also forcing all content to scale into this viewBox as
* browser-window size is changed (try it; you'll see what is meant here).
*
* ## SVG Element Dimensions Notes:
*
* dart-squid Applications can be enabled within SVG documents that implement *fixed-size
* width/height* specifications or *variable/proportional-sized* width/height specs
* (e.g., "100%" for width/height values).
*
* *See note below about browser issues with variable sized SVG docs.*
*
* ### Fixed-Value Dimensions
* Values are specified (in number of pixels) within the opening `<svg>` tag
* and look like this, e.g.:
*
*     width="3000"
*     height="2000"
*
* Use this approach when you want your application "canvas" size to remain constant
* and/or include space that would otherwise be larger than the maximum
* (visible on screen at one time) browser-window-size.  This allows the canvas to extend
* (right and down) and form canvas region that is accessible by scrolling side-to-side and
* up/down.  Think of it as having a sheet of paper larger than you can work with at once
* on your desktop, and you can shift that paper around as needed to view it in its entirety.
*
* TODO: an enhancement may be introduced to allow programmatic changes of these values at create/run time.
*
* ### Variable/Proportional-Value Dimensions
* (Note: SVG docs using this approach are presenting rendering challenges currently)
* Values are specified (in percentages; percent of viewable screen area) within the opening `<svg>` tag
* and look like this, e.g.:
*
*     width="100%"
*     height="100%"
*
* Use this approach when you want your application "canvas" to automatically
* stretch and shrink when the visible browser-window space is increased or decreased as
* a result of the user resizing the browser application.  Keep in mind that if this
* approach is used, it is possible to have Widgets that are no longer (visually)
* accessible if they were created at a location that, after shrinking the visible
* window region, is no longer visible (at least, that is, until window is again
* resized to include that formerly-visible area).
*
*
* ### Browser Issue with Percent-Based Sizing (in non-HTML-wrapped-SVG's)
* (research needed) For some reason, SVG Width/Height 100%-values are *not re-adjusting down-through
* svg tree* (SVG element hierarchy) during `canvas.reSize()` event and subsequent painting of widgets,
* but only when the SVG document is a standalone-SVG (not "wrapped" by and HTML file).
* This effects repaint of any widgets that were aligned to Right and/or Bottom of Canvas
* and then Moved (with mouse)... perhaps others too; when canvas is resized
* by reducing width/height of Browser's window,
* the new canvas bounds (smaller) would chop off parts of embedded child widgets
* (contained in their own SVG) in the formerly aligned-to-canvas-bounds parent widgets.
*
* ---
* ## See Also
* There are some related "helper methods" (in globals.dart) that are relevant and useful:
* [isInstanceNameUnique], [indexOfInstanceName], and [indexOfTag].
*  ---
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//TODO: POTENTIAL DESIGN THOUGHTS / IDEAS / CONSIDERATIONS
//
//appViewBox - OUTERMOST VIEWBOX/SVG VALUES - FOR R/O QUICK ACCESS (updated on ReSize!)
//
//activeWidget - keep track of which one has focus in the application
//
//"Widget" list could be extended to keep track of which Widgets are "Forms"; also which are modal: T/F
//
//Help dispatcher
//
//Exceptions handler -- setup standard exceptions also here in Core
//
//mainForm - so we know where to set focus when an application starts up; a bit overkill, or
//necessary for restoring saved state?
//
//▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
//
//includeCanvasNavigation/Sizing? T/F -- does main canvas need to stretch beyond view bounds?
//includeCanvasNavigationPanel (true/false) - zoom/pan,etc
//███████████████████████████████████████████████████████████████████████████████████████
class Application {

    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Private variables
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    String         _name            = 'SVGApplication';

    /// The SVG 'rect' element that exists as the first element on our canvas solely
    /// for allowing an easy way to style our application canvas fill-color, etc.
    SVGRectElement _backgroundRect  = null;

    SVGElement     _cssTestingRect  = null;
    SVGSVGElement  _canvas          = null;
    String         _classesCSS      = 'ApplicationCanvas';
    ObjectBounds   _canvasBounds    = new ObjectBounds();
    num            _marginLeft      = 0.0;
    num            _marginTop       = 0.0;
    bool           _isStandaloneSVG = true;
    bool           _isRunningOnServer   = false;
    String         _browserType     = null;

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    These two variables are used only during initial "launch" of the application.
    This was implemented as a workaround to how the Dart future(s), as of 4/15/2012,  were
    being processed within the _UpdateCanvasBounds method.  Our application object is
    instantiated from  main() (i.e., initiation via outer main thread), and for whatever
    reason, the future(s) in here would only complete after ALL of main() finished.
    So, this callback essentially transfers control to another routine inside main(),
    only after our initial future(s) complete.  A flag prevents repeats.

    I.e., this is a HACK due to the fact that the only *accurate* and *predictable* way
    to get screen-dimensions (browser-viewable-region) is through these futures, since
    Dart no longer exposes the values in non-future-ways. (LAME!) JS had no such issues.
    Is this perhaps over-engineering (by Dart team) of client.values (screen dimensions)
    access? ...if JS can expose without futures, why did Dart choose to make these deferred
    values?  It is not like it takes more than a couple milliseconds to obtain these, right?
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    ChangeHandler   _onAppReady     = null;
    bool            _isAppReady     = false;


    List<Widget>    _widgetsList    = new List<Widget>();
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * List of [Widget] references (i.e., object pointers to Widgets) used throughout our application.
    * Widget (instance) Names must be unique, since these are used in SVG code for "id" values
    * of SVG elements that we will need to add/modify/remove from within our SVG application.
    *
    * *NOTE:* the public accessor is here currently for easy debug inspection and such;
    * direct-use is discouraged for all but read-only operations
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    List<Widget>    get widgetsList => _widgetsList;


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * List used to keep track of which widgets are "Selected";
    * especially useful during multi-select operations. Zero or more widgets in an
    * application can be "selected" via click (shift-click for multiples).
    */
    //---------------------------------------------------------------------------------------
    //TODO: This will be related to some ability to "draw" a selection-box and select all
    //(appropriate) widgets within that box for some type of further manipulation
    //(be it movement/sizing, or otherwise)
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    List<Widget>    selectedWidgetsList = new List<Widget>();


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Public variables/accessors.
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    //Implement Hint processing in Widgets; this is to be app-wide default value //TODO - ALLOW CHANGES
    const bool  showHint        = true;
    const int   hintPause       = 1000;

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Used for development / debugging tracing purposes. When [true] enables trace-points
    * per [TracingDefs] list constants (globals.dart), and the [Application.trace]
    * method will write (to browser 'Console') pertinent information for any enabled
    * trace point(s) that are encountered during execution.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    bool    tracingEnabled   = false;


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: PRIVILEGED METHODS (publicly visible accessors to our protected members)
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * The SVG object (of element type 'svg') that will act as an application's "canvas"
    * onto which all widgets will be placed directly or indirectly via hierarchical
    * nesting within other widgets residing directly on this "canvas" element.
    *
    * ## SVG Notes
    * See the [Application] object top-level documentation for a discussion of SVG document
    * construction to properly implement this canvas item placeholder in your application's
    * container HTML or SVG doc.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    SVGSVGElement get canvas    => _canvas;

    /**
    * Application Name; notational only, though perhaps useful when setting a page
    * title / caption or including in debug / tracing / testing output.
    */
    String  get name                => _name;

    /// Is this application running within an SVG document [:true:] or is it an SVG embedded in HTML [:false:].
    bool    get isStandaloneSVG     => _isStandaloneSVG;

    /// Are we serving this app from an http server?
    bool    get isRunningOnServer   => _isRunningOnServer;

    /// Detect Chromium vs. any other type (for now, only concerned with FireFox potentially).
    String  get browserType         => _browserType;



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Comma-delimited list of Class Names that CSS *selectors* will be able to target
    * and Style. The default selector target is 'ApplicationCanvas'.
    *
    * The Application class has limited CSS styling potential, as it is
    * simply the [canvas] background [SVGRectElement] being styled.
    * As such, any CSS styling applicable to a rect element can be specified.
    *
    * ## Example CSS Class Selector
    * The following example will paint the canvas background fully opaque using a skyblue
    * fill with a 20px wide dashed border in blue.
    *
    *     .ApplicationCanvas {
    *         fill: skyblue;
    *         fill-opacity: 1;
    *         stroke: blue;
    *         stroke-width: 20px;
    *         stroke-opacity:   1;
    *         stroke-dasharray: 1,2;
    *     }
    *
    * ## See Also
    * [Widget.classesCSS] property for detailed comments regarding Widget styling.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    String get classesCSS           => _classesCSS;
    void set classesCSS(String sClasses) {
        _classesCSS = sClasses;
        _updateCanvasAttributes();
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Returns an [ObjectBounds] object that provides quick-access to our
    * [canvas] Bounding-Box information. This information is updated from within the
    * private _resize method (which executes on resize events).
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    ObjectBounds get canvasBounds   => _canvasBounds;

    ///The [canvas] SVG element's left-inset within HTML doc, when applicable.
    num get marginLeft              => _marginLeft;

    ///The [canvas] SVG element's right-inset within HTML doc, when applicable.
    num get marginTop               => _marginTop;

    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: PRIVATE METHODS
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    _updateCanvasAttributes

    Create the "background" -- this is nothing more than a Rect which fills the entire canvas.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _updateCanvasAttributes() {
        //Create rect only on initial setup...
        if (_backgroundRect == null) {
            _backgroundRect = new SVGElement.tag('rect');
            _canvas.nodes.add(_backgroundRect);
        }

        _backgroundRect.attributes = {
            'id'    : '${_name}_CanvasBackground',
            'x'     :'0',
            'y'     :'0',
            'width' :'100%',
            'height':'100%',
            'class' : _classesCSS
        };

    } //... _updateCanvasAttributes()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    CreateMetricsTestingObjects

    The hidden objects created here will be used Get the computed value of CSS styles
    applied to our Widgets via matching class-selectors

    IMPORTANT! Though not visible, processing/geometry-updates are performed for hidden objects.
    See http://www.w3.org/TR/SVG/painting.html#VisibilityControl
    This is what allows us to use these "hidden" objects to help us GetComputedStyles and
    the associated element metrics (i.e., for element attributes influenced by CSS Style(s))
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _createMetricsTestingObjects() {
        //the dart:html version (not yet supported by getComputedStyle)
        if (_cssTestingRect == null) {
            _cssTestingRect = new SVGElement.tag('rect');
            _canvas.nodes.add(_cssTestingRect);

            //Position off-screen, hide it, name it
            _cssTestingRect.attributes = {
                'visibility': 'visible',
                'id'        : 'CSSTestingRect',
                'x'         :'-1000',
                'y'         :'-1000',
                'width'     :'100',
                'height'    :'100'
            };
        }

    } //... createMetricsTestingObjects()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    _UpdateCanvasBounds

    Keep our _CanvasBounds Object updated.
    This method should be called by any method that traps changes in Canvas size (e.g., Resize).

    ═══════════════════════════════════════════════════════════════════════════════════════
    NOTES (from JS version of Widgets):
    The Chrome browser (using JS) gets every single permutation of size-calculations
    (calculate the viewport bounds) correct, but FireFox sucks totally!
    Though, Dart is not exposing viewportElement correctly and other issues too.

    With Chrome, (using JavaScript) any of these permutations worked:
        _canvasBounds.R    = (_canvasBounds.L + mCanvas.viewportElement.clientWidth);
        _canvasBounds.R    = document.documentElement.clientWidth;
        _canvasBounds.R    = window.innerWidth - 17; (where the 17 is adjusting for width of scrollbar)

    BUT, with FireFox, only the last technique works.  And, then FF does not UPDATE this value
    since ReSize is not called. (see comment in Resize event for details on the FF bug);
    *The FF BUG is PRESENT THROUGH FF 10.x and counting...
    IF it is ever fixed, and if innerWidth is only option still, consider the following (or similar)
    to calc inset for FF:
        http://stackoverflow.com/questions/986937/javascript-get-the-browsers-scrollbar-sizes
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _updateCanvasBounds() {
        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        NOTES:
        We use the _Canvas.viewportElement.rect future to get access to the "bounding"
        rect that returns the ENTIRE SVG Element size (vs. viewport), BUT it is needed
        in the case where our SVG is embedded inside an HTML document, since the top and left
        values reflect the proper inset (in browser window) of margin width and/or other HTML
        elements taking up space around our SVG.

        We use the document.documentElement.rect future to get access to the "client"
        rect information that includes proper browser-view-region (including consideration for
        scrollbar(s) if present) for the right and bottom values.

        Using these two, we can compute our real working-region for any align-to-viewable-area
        situations.

        ALSO IMPORTANT:
        This Future-based approach produces correct value, but but takes forever to return value!
        (i.e., after entire main() finishes!)
        See comments included with _isAppReady/_onAppReady variables for more info about
        how/why callback was used.

        DOING THIS WITHOUT FUTURES: (EASY IN JS; dart:html framework made this ridiculous)
        The following few lines of code were the ONLY "immediate" version (non Future) that worked
        in Dartium from what I could determine, though the need to figure out scrollbar width
        was an added layer of garbage subject to issues:

            static const int scrollBarWidth  = 17;  //"standard" width?
            _canvasBounds.R  = (_canvasBounds.L + window.innerWidth  - scrollBarWidth);
            _canvasBounds.B  = (_canvasBounds.T + window.innerHeight - scrollBarWidth);
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        Future<ElementRect> _viewportRect;
        _viewportRect = _canvas.viewportElement.rect;   //_Canvas.viewportElement.rect returns size of entire SVG

        //note: within ".then", the future's return value is accessible as either _viewportRect.value (i.e., future-var-name.value) or "rect" (parm name)
        _viewportRect.then((rect) {
            _marginLeft = rect.bounding.left;   //left inset
            _marginTop  = rect.bounding.top;    //top inset

            Future<ElementRect> _docRect;
            _docRect = document.documentElement.rect;   //_Canvas.viewportElement.rect *should* have worked too, but it returns size of entire SVG
            _docRect.then((rect2) {
                _canvasBounds.L     = rect2.client.left;
                _canvasBounds.T     = rect2.client.top;
                _canvasBounds.R     = (_canvasBounds.L  + rect2.client.right   - _marginLeft);
                _canvasBounds.B     = (_canvasBounds.T  + rect2.client.bottom  - _marginTop);

                trace(103, this);

                if (!_isAppReady) {
                    trace(100, this);
                    _isAppReady = true;
                    _onAppReady();
                } else {
                    //cleanup callback ref if still around; this may be overkill...
                    if (_onAppReady != null) {
                        _onAppReady = null;
                    }
                }

            });

        });

    } //... _updateCanvasBounds()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    When the canvas is resized (by shrinking or expanding the browser application's Window),
    any widgets that are aligned to the right and/or bottom (visible-region in browser
    window/tab) *canvas* bounds, per a [Widget]'s alignment specs, will have their bounds
    and/or position affected.

    This method loops through the application's widgets only looking at "top" (parent-less)
    widgets since it is only that set of widgets that can be aligned to the canvas
    (their "container").
    Furthermore, since the upper-left corner always remains position (0,0) for the canvas's
    SVG coordinate space, it is only any Widgets that align right and/or bottom that must
    be realigned when the canvas size is altered

    NOTE: FireFox has a BUG whereby it is not calling Resize for SVG documents.
        see: https://bugzilla.mozilla.org/show_bug.cgi?id=509795
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _resize (event) {
        event.stopPropagation();
        event.preventDefault();

        _updateCanvasBounds();

        //loop through application "top level" widgets (i.e., those without parent - residing on our "Canvas")
        int             tempChildCount          = _widgetsList.length;
        Widget          ptrChildWidget          = null;
        WidgetAlignment ptrChildWidgetAlignObj  = null;

        for (int i = 0; i < tempChildCount; i++) {
            ptrChildWidget = _widgetsList[i];
            if (!ptrChildWidget.hasParent) {
                ptrChildWidgetAlignObj = ptrChildWidget.align;
                if (((ptrChildWidgetAlignObj.R.objToAlignTo == null) && (ptrChildWidgetAlignObj.R.aspect > eAspects.NONE)) ||
                    ((ptrChildWidgetAlignObj.B.objToAlignTo == null) && (ptrChildWidgetAlignObj.B.aspect > eAspects.NONE)))
                {
                    ptrChildWidget.reAlign();
                    ptrChildWidget.reAlignSiblings();  //since other top-level widgets could align to the re-aligned widget
                }
            }
        }
    } //...resize()



    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: PUBLIC METHODS
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Used for development / debugging tracing purposes, in conjunction with [tracingEnabled].
    * Dual capabilities depending on whether optional [_objInitiatingTrace] is provided;
    * when it is, all logging is handled by this method. Otherwise, logging in handled
    * by caller and caller is simply obtaining return value to determine if a [_tracePoint]
    * is enabled in the [TracingDefs] list constants (in globals.dart).
    *
    * ### Parameters (required)
    *   * [int] _tracePoint: the String version of this value is used to locate the
    *   matching [TracingDefs] entry, and indicates the tracing-step (tracePoint) encountered.
    *   * [dynamic] _objInitiatingTrace: (optional) if provided, contains object to dump
    *   trace information for (e.g., a [Widget] instance or a subclass thereof); can also
    *   pass a String message-to-log through this parm instead.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    bool trace(int tracePoint, [dynamic objInitiatingTrace = null]) {
        if (!tracingEnabled) return false;
        if (!(TracingDefs[tracePoint.toString()].isActive)) return false;
        if (objInitiatingTrace == null) return true;
        logToConsole(['LINE1', TracingDefs[tracePoint.toString()].tracePointDesc, objInitiatingTrace, 'LINE4']);
        return true;
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    getCSSPropertyValuesForClassNames

    I TRIED to use the Future<CSSStyleDeclaration> implementation of getComputedStyle(),
    but NOTHING would work (UPDATE: this was probably due to same issue as getting window-size
    using a Future, which had to wait for all code in main() to finish before run).

    The Dart source code appears to just be returning window.$dom_getComputedStyle() anyhow.

    http://code.google.com/searchframe#TDGadvYaD94/trunk/dart/lib/html/dartium/html_dartium.dart
        (search for "getComputedStyle" to find relevant lines)

    So, INSTEAD OF USING a FUTURE, I just hard-coded the $dom_... approach here.

    ═══════════════════════════════════════════════════════════════════════════════════════
    ISSUES! BUG IN WEBKIT!  (NEED TO REPORT - TODO)
    More of the WebKit buggy mess has been exposed, this time with regard to zoom-factors
    and how it affects this off-screen getComputedStyle stuff.  It SHOULD always return the
    same INT values, regardless of zoom level, but it does not.  And, this apparently only
    affects *BORDER STYLES* and not margin/padding values.

    This causes int.parse() to fail later when we expect an int all the time.
    (see [Widget] _applyStylesToWidgetBorders code, getProperWidthValues contained method for "fix")

    The WebKit calculations are just garbage when the result of dividing the zoom-factor into
    a property (like border-width) does not result in a nice even number.
    And, it makes no sense... their "math" is just garbage.  And, there should be no "math"
    to amount to anything; values should remain what CSS says they are, regardless of zoom.

    Results of 10px and 2px tests, which should ALL return 10 and 2 respectively, as INT...
    (if only 2px listed, that is because 10px was expected INT)
    33%: BadNumberFormatException: '9.00900936126709'
    50%: -- ALL VALUES are INT
    67%: BadNumberFormatException: '9.00900936126709'
    75%: BadNumberFormatException: '9.333333015441895'
    90%: BadNumberFormatException: '1.1111111640930176' (FOR 2px Border)
    100% -- ALL VALUES are INT
    110%: BadNumberFormatException: '1.8181817531585693' (FOR 2px Border)
    125%: BadNumberFormatException: '9.600000381469727'
    150%: -- ALL VALUES are INT
    175%: BadNumberFormatException: '9.714285850524902'
    200%: -- ALL VALUES are INT

    I suspect this is some issue resulting from typecasting, e.g., .astype(Float32) or
    some matrix used to calc zooms is off a bit, etc.?  Wild guess.

    ═══════════════════════════════════════════════════════════════════════════════════════
    CONSIDER: make this more generic; rect-only for now... may eventually need text-metrics
    calcs if native SVG-Text is used (which requires manual metrics calcs, line-splits, etc)

    */

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    // BEGIN: dartdoc comments for getCSSPropertyValuesForClassNames...
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * This routine is called from the [Widget] private method [_updateStylePropertiesListValuesFromCSS]
    * in order to obtain calculated property values, from CSS, that will be applied to the
    * various visual parts of the widget.  It can be used for any off-screen CSS-style-calculation
    * work as needed, so long as parameter compatibility is maintained.
    *
    * ### Parameters (required)
    *   * [String] targetName: the logical visual sub-component of the [Widget] being styled (e.g., its Frame).
    *   * [String] selectorNames: a **space-delimited** list of CSS selector (class) names
    *   that will be applied to the Widget sub-component being styled in order to compute property values
    *   reflecting the application of CSS.
    *   * [:List:] listStylable: each element within this list of [StyleTarget] objects
    *   specify details that include "target properties" to calculate values for (e.g., 'margin-left'),
    *   plus a default value for these properties.
    *
    * ### Returns
    * Value is returned via the (by reference parameter) listStylable's [CSSTargetsMap.calcValue] field.
    * Value is result computed using off-screen application of CSS, or the
    * specified default-value if unable to compute a result.
    *
    * ## See Also
    * * [StyleTarget] — very important and integral to this widget-styling process.
    * * [CSSTargetsMap] — the [Widget.classesCSS] property maintains such a [Map]
    * .
    *
    * ## IMPORTANT NOTES
    * ### Note 1
    * *Critically important format*: Browser (Chrome 18+) ONLY processes SelectorNames properly
    * if *space-delimited* (commas cause issues!)
    *
    * ### Note 2
    * Even though SVG-SPECIFIC PropertyNames appear in Chrome's object-inspector (debugger)
    * as non-hyphenated camelCase (e.g., strokeWidth), our getPropertyValue lookups must use
    * use the hyphenated lowercase form (e.g., stroke-width) — at least for Chrome v18+ —
    * to get values. Caller must load "target property" values within List appropriately!
    *
    * ### Note 3
    * *Border-style(s)* are at *end of each list* passed to this routine (for border groups),
    * and when we reach the style attribute(s), we have access to already-encountered
    * border-width data to determine our enumerated internal [eBorderStyle]).
    *
    *     FURTHER STYLING NOTE: Include "UseVirtualBorder" in the SelectorNames list to access our
    *     "virtual" styles of "Raised" and "Lowered" when the provided CSS Style is Outset/Inset
    *     respectively (i.e., we use this phrase to detect our desire for an enhanced
    *     double-line version of outset/inset border).
    *
    * ### Note 4
    * The CSS StyleSheet values *must use* a valid unit of measure (e.g., px, pt, em)
    * *after any size properties* or they will interpret to zero here!!!
    * Numbers without UOM (unit of measure) suffix will always yield *zero*!
    *
    * Within this method, the calls to [window.$dom_getComputedStyle] ==>
    * [CSSStyleDeclaration.getPropertyValue] ==>
    * yields *whole number* ([int]) values (in *px*),
    * and *requires* a specified UOM in the CSS stylesheet definitions to yield desired value.
    *
    * ## MORE NOTES IN SOURCE CODE:
    * Refer to the source-code for additional detailed comments regarding some of the
    * challenges encountered with this routine, including apparent Webkit bugs that are of
    * some concern.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    getCSSPropertyValuesForClassNames(String targetName, String selectorNames, List<StyleTarget> listStylable) {
        String  sPropertyName       = '';
        String  sPropertyValue      = '';
        String  sCalculatedValue    = '';
        num     iBorderWidth        = 0.0;
        int     iIndex              = 0;
        bool    useVirtualBorder    = false;

        if (selectorNames.indexOf('UseVirtualBorder') > -1) {useVirtualBorder = true;}

        setSVGAttributes(_cssTestingRect, {'class': selectorNames});

        if (trace(101)) {
            logToConsole([
                'LINE2',
                "${TracingDefs['101'].tracePointDesc}   SelectorNames = ${selectorNames};  targetName = ${targetName};",
                'LINE3'
            ]);
        }

        //TODO: NOTE THAT SECOND PARM OF getComputedStyle is String name of a pseudo-element (e.g., :first-line or :hover and so forth)
        CSSStyleDeclaration styledec = window.$dom_getComputedStyle(_cssTestingRect, '');

        for (StyleTarget target in listStylable) {
            if (target.targetObject != targetName) {continue;}

            sPropertyName = target.targetProperty;
            sPropertyValue = target.defaultValue;

            sCalculatedValue = styledec.getPropertyValue(sPropertyName);

            //Strip trailing "px" from width/size-properties and return just Int value for any px-width specs
            sCalculatedValue = sCalculatedValue.replaceFirst('px','');


            //See if we have a CSS style specification to convert to our internal enumeration value
            if (sPropertyName.indexOf('style') > -1) {
                //now, see if style maps to one in our list of style names: e.g., index of 1 for "SOLID",... unknown values default to "NONE" type.
                iIndex = eBorderStyle.getEnumValueDefaultNone(sCalculatedValue.toUpperCase());

                //First, check for "virtual" extensions to inset/outset border-styles; convert those to our own internal styles of lowered/raised respectively
                if ((iIndex == eBorderStyle.OUTSET)  && (useVirtualBorder)) {iIndex = eBorderStyle.RAISED;}
                if ((iIndex == eBorderStyle.INSET)   && (useVirtualBorder)) {iIndex = eBorderStyle.LOWERED;}

                //Handle all other (non-virtual) border styles now; any unknowns have already been mapped to internal "NONE" type.
                sCalculatedValue = eBorderStyle.Names[iIndex];

                if (trace(102)) {
                    logToConsole([
                        "${TracingDefs['102'].tracePointDesc}   targetName = ${targetName};  sPropertyName = ${sPropertyName};  useVirtualBorder = ${useVirtualBorder};  eBorderStyle.Name = ${eBorderStyle.Names[iIndex]};  CALCULATED VALUE = ${sCalculatedValue} (CALC)",
                        'LINE4'
                    ]);
                }

            }

            target.calcValue = sCalculatedValue;
        } //for

    } //...getCSSPropertyValuesForClassNames()



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Add the [Widget] instance reference specified in the [objToAdd] parameter
    * to the Application object's [widgetsList] after making sure that:
    *
    *   1. specified [objToAdd] truly is a [Widget] or subclass thereof.
    *   2. the Widget's [Widget.instanceName] will be unique across entire application.
    *
    * This method will be invoked by all Widget derivations, via the [Widget]
    * constructor object initialization process.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void addWidget (Widget objToAdd) {
        //make sure objToAdd is proper Type before allowing add...
        if (objToAdd is! Widget) {
            throw new InvalidTypeException('Application.AddWidget',  'Widget', objToAdd);
        }

        //make sure instanceName (of object being added to list) is Unique
        if (isInstanceNameUnique(_widgetsList, objToAdd.instanceName)) {
            _widgetsList.add(objToAdd);
        } else {
            throw new UniqueConstraintException(objToAdd.instanceName);
        }
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * If a given [instanceNameToRemove] exists in our Application object's [widgetsList],
    * remove it.
    *
    * This method is called from [Widget.destroy] — i.e., destructor — methods to free application
    * references to any Widget being destroyed. We clear "selected" widgets too, since the removal
    * of a widget could otherwise leave straggling widget references in [selectedWidgetsList].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void removeWidget(String instanceNameToRemove) {
        int indexToRemove = indexOfInstanceName(_widgetsList, instanceNameToRemove);

        if (indexToRemove > -1) {
            clearWidgetSelection();
            _widgetsList.removeRange(indexToRemove, 1);
        }
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    // The following are various helper-functions for accessing Widget-List information that
    // would otherwise be private; remember that directly accessing that list is discouraged
    // as it may be made completely private in the future. (i.e., public "getter" may go away)
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪

    /**
    * Quick access to the value of [widgetsList.length]
    */
    int getWidgetCount() {
        return _widgetsList.length;
    }

    /**
    * Return the [Widget] reference stored in [widgetsList] at [indexOfObjectToGet].
    */
    Widget getWidgetByIndex(int indexOfObjectToGet) {
        return _widgetsList[indexOfObjectToGet];
    }


    /**
    * Return the index of the [widgetToLocateInList] stored in [widgetsList].
    */
    int indexOfWidget(Widget widgetToLocateInList) {
        return _widgetsList.indexOf(widgetToLocateInList);
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Handles the process of removing all Widgets from [selectedWidgetsList].
    *
    * Performs UI display updates to visually reflect selection of no widgets.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void clearWidgetSelection() {
        for (Widget widget in selectedWidgetsList) {
            widget.selectionRect.attributes['display'] = 'none';
        }

        selectedWidgetsList.clear();
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Handles the process of adding a Widget to [selectedWidgetsList].
    *
    * When adding to what Widgets are "selected", re-selecting an already selected Widget
    * will de-select it and return [:false:], otherwise [:true:] is returned.
    * Additional logic in this method also prevents situations like multi-selecting children
    * of a selected widget (where they are hierarchically "owned" by selection already).
    *
    * Performs UI display updates to visually reflect resultant selection.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    bool addWidgetToSelection(Widget widgetToAdd) {
        int             indexTest       = -1;
        bool            alreadySelected = false;
        List<String>    hierTest        = null;
        List<String>    addPathSplit    = null;

        //test for this instance-name already in our list; if so, exit while indicating it is selected already.
        indexTest = indexOfInstanceName(selectedWidgetsList, widgetToAdd.instanceName);
        if (indexTest > -1) return true;

        addPathSplit= widgetToAdd.hierarchyPath.split(',');

        //more detailed tests...
        for (int i = 0; i < selectedWidgetsList.length; i++) {

            hierTest = selectedWidgetsList[i].hierarchyPath.split(',');

            /*
            ═══════════════════════════════════════════════════════════════════════════════════════
            if an already selected widget's hierarchy-path includes this widget's instance-name
            in its path, we are now attempting to add selected widget that is at a higher
            hierarchical level than already-added widget(s).  This is easy to know, since a
            widget's hierarchy-path is unique: i.e., if our current "selected" widget's instance-name
            appears elsewhere, it MUST be appearing only because it is part of a longer "path" to
            a lower-level (hierarchically) widget.  As such, we remove any "contained"
            (hierarchically) widgets that already exist in our selection-list prior to adding
            our new higher-level selection.
            ═══════════════════════════════════════════════════════════════════════════════════════
            */
            if (hierTest.indexOf(widgetToAdd.instanceName) > -1) {
                selectedWidgetsList[i].selectionRect.attributes['display'] = 'none';
                selectedWidgetsList.removeRange(i, 1);
                continue;
            }


            /*
            ═══════════════════════════════════════════════════════════════════════════════════════
            Are we attempting to add a Widget that would be a sub-component of already-selected
            widget?  If so, we can bail... (since, this widget is "selected" by default as
            it is contained within the other)
            We look at this widget's "path" elements and make sure none of them already appear
            in the path of an already selected widget.
            ═══════════════════════════════════════════════════════════════════════════════════════
            */
            for (String instanceName in addPathSplit) {
                if (hierTest.indexOf(instanceName) > -1) {
                    alreadySelected = true;
                    break;
                }
            }

            if (alreadySelected) return false;
        }

        //the new one passed all the tests... must be a valid selection now that we have cleaned up any potential issues.
        selectedWidgetsList.add(widgetToAdd);

        //Now make it visually clear what is selected (TODO: This will be unnecessary in a future additional "box-draw" multi-select version)
        setSVGAttributes(widgetToAdd.selectionRect, {
            'display'       : 'inherit',
            'visibility'    : 'visible'
        });

        return true;

    } //addWidgetToSelection



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Get count of all the top-level Widgets (i.e., those residing directly on our [canvas]
    * object); if optional parm [stopAtIndex] is specified, return count of only those widgets
    * appearing later (after specified index) in [widgetsList].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    int getTopLevelWidgetsCount ([int stopAtIndex = 0]) {
        int countWidgets = 0;
        int i = _widgetsList.length;

        while (i-- > stopAtIndex) {
            if (!_widgetsList[i].hasParent) {
                countWidgets++;
            }
        }
        return countWidgets;
    }




    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * Constructs an Application object, initializes various properties, and once the
    * _updateCanvasBounds private method completes its [Future] operations, returns control
    * to the caller by way of executing the callback handler (method) specified in the
    * constructor parameter [_onAppReady].
    *
    * ### Parameters (required)
    *   * [String] _name: whatever name you wish to give your application — simply notational.
    *   * [SVGSVGElement] canvasElement: the SVG element (obj reference) to use as our Canvas.
    *   * [ChangeHandler] _onAppReady: method called when this application is "ready" to start
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Application(this._name, SVGSVGElement canvasElement, this._onAppReady) {

        if (canvasElement is! SVGSVGElement) {
            throw new InvalidTypeException('$_name (Application Object) Constructor : canvasElement is not an instance of SVGSVGElement.',  'SVGSVGElement', canvasElement);
        }

        _canvas = canvasElement;
        _browserType = getBrowserType();

        //Test for our "app" being within an .svg file (vs. .html, etc); iFrame-held would still show .SVG as "standalone" unless we look Window.top.loc...
        _isStandaloneSVG    = window.location.href.toLowerCase().endsWith('.svg');
        _isRunningOnServer  = window.location.href.toLowerCase().startsWith('http');

        _updateCanvasAttributes();


        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Essentially, an "_addCanvasResizeWatcher()" bit of functionality.
        See [_resize] method docs for more details.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        window.on.resize.add( (event) => _resize(event) );


        //Make sure our off-screen testing objects are available once canvas is ready
        _createMetricsTestingObjects();


        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        IMPORTANT NOTE: This final construction step also "completes" the app-load when
        _UpdateCanvasBounds fires the callback specified in constructor -- which will transfer
        control back to specified method in main()
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _updateCanvasBounds();

    } //constructor


} //Application (class)
