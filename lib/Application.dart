/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/


/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: Application Class

DESCRIPTION
This is the global application-wide class that should be instantiated once per each
SVG applications using our Widgets and components.

This class will maintain important references to our "Canvas" as well as lists of widgets
in use, standard fonts, settings, and more.

▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
PROPERTIES

(inherited)
- N/A

(introduced in this Class)
- name ................ (string) Application Name; notational only, though perhaps useful in setting Caption, etc.

- canvas .............. (obj) the SVG object (of element type 'svg') that will act as an application's "canvas" on
which all widgets will be placed directly or hierarchically nested within other widgets.

- backgroundRect ...... (obj) the SVG 'rect' element that exists on within our canvas solely for allowing an
easy way to style our canvas fill-color

- classesCSS .......... (string) comma-delim list of Class Names that CSS selectors will
be able to target and Style.


- selectedWidgetsList... (List<Widget>) used to keep track of which widgets are "Selected";
especially useful during multi-select operations.  TODO: This will be related
to some ability to "draw" a selection-box and select all (appropriate) widgets within that
box for some type of further manipulation (be it movement/sizing, or otherwise)

▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
METHODS

(inherited)
- N/A

(introduced in this Class - SUMMARY)
- addWidget .......... (returns: integer index to item added)  Add a Widget-instance reference to our Widgets list
                        after making sure that the Widget's InstanceName will be unique across entire application.

▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
HELPER METHODS (in Common.dart file) that are very relevant and useful...
- isInstanceNameUnique
- indexOfInstanceName
- indexOfTag

▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
EVENTS

▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
EXAMPLES:  N/A



■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
TODO: POTENTIAL DESIGN THOUGHTS / IDEAS / CONSIDERATIONS

appViewBox - OUTERMOST VIEWBOX/SVG VALUES - FOR QUICK ACCESS, READ-ONLY (this needs updated on ReSize!)

activeWidget - keep track of which one has focus in the application
"Widget" list could be extended to keep track of which Widgets are "Forms"; also which are modal: T/F

Help dispatcher

Exceptions handler -- setup standard exceptions also here in Core

mainForm - so we know where to set focus when an application starts up; a bit overkill, or
necessary for restoring saved state?

▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪

includeCanvasNavigation/Sizing? T/F -- does main canvas need to stretch beyond view bounds?
includeCanvasNavigationPanel (true/false) - zoom/pan,etc

███████████████████████████████████████████████████████████████████████████████████████████
*/
class Application {

    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Private variables
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    String         _name            = 'SVGApplication';
    SVGRectElement _backgroundRect  = null;
    SVGElement     _cssTestingRect  = null;
    SVGSVGElement  _canvas          = null;
    String         _classesCSS      = 'ApplicationCanvas';
    ObjectBounds   _canvasBounds    = null;
    num            _marginLeft      = 0.0;
    num            _marginTop       = 0.0;

    //is this application within an SVG document (true) or is it an SVG embedded in HTML (false)
    bool           _isStandaloneSVG = true;

    //see if we're hosting this app from an http server
    bool           _isRunningOnServer   = false;

    //Detect Chromium vs. any other type (for now, only concerned with FireFox potentially)
    String         _browserType     = null;

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    These two variables are used only during initial "launch" of the applicatin.
    This was implemented as a workaround to how the Dart future(s), as of 4/15/2012,  were
    being processed within the _UpdateCanvasBounds method.  Our application object is
    instantiated from  main() (i.e., initiation via outer main thread), and for whatever
    reason, the future(s) in here would only complete after ALL of main() finished.
    So, this callback essentially transfers control to another routine inside main(),
    only after our initial future(s) complete.  A flag prevents repeats.

    I.e., this is a HACK due to the fact that the only *accurate* and *predictable* way
    to get screen-dimensions (browser-viewable-region) is through these futures, since
    Dart no longer exposes the values in non-future-ways. (LAME!) JS had no such issues.
    I belive this is over-engineering (by Dart team) of client.values (screen dimensions)
    access... if JS can expose without futures, why did Dart choose to make these deferred
    values?  It is not like it takes more than a couple milliseconds to obtain these!
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    ChangeHandler   _onAppReady     = null;
    bool            _isAppReady     = false;


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    _widgetsList

    List of Widget references (i.e., object pointers to Widgets) used throughout our application.
    Widget (Instance) Names must be unique, since these are used in SVG code for "id" values
    of SVG elements that we will need to add/modify/remove from our SVG application.

    NOTE: the accessor is here for easy debug-dumps; though, direct-use is discouraged
    for all but read-only operations
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    List<Widget>    _widgetsList    = null;
    List<Widget>    get widgetsList => _widgetsList;


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    selectedWidgetsList

    Zero or more widgets in an application can be "selected" via Cick (shift-click for
    multiples).
    TODO: In addition, we will have a bounds-box-drawing-based selection mechanism too.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    List<Widget>    selectedWidgetsList = null;


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Public variables/accessors.
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    //Implement Hint processing in Widgets; this is to be app-wide default value
    final bool  showHint        = true;
    final int   hintPause       = 1000;

    SVGSVGElement get canvas    => _canvas;     //read-only accessor to our private variable


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: PRIVILEGED METHODS (publicly visible accessors to our protected members)
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    String  get name                => _name;
    bool    get isStandaloneSVG     => _isStandaloneSVG;
    bool    get isRunningOnServer   => _isRunningOnServer;
    String  get browserType         => _browserType;


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    classesCSS (String of comma-delimited name-strings)
    See Widget classesCSS property for detailed comments.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    String get classesCSS           => _classesCSS;
    void set classesCSS(String sClasses) {
        _classesCSS = sClasses;
        _updateCanvasAttributes();
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    canvasBounds : READ ONLY
    Returns an object (group of properties) that provides quick-access to our
    Canvas's Bounding-Box information. This information is updated in our resize event.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    ObjectBounds get canvasBounds   => _canvasBounds;

    //Quick access to the margins (SVG inset within HTML doc, when applicable)
    num get marginLeft              => _marginLeft;
    num get marginTop               => _marginTop;

    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: PRIVATE MEMBERS 
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
    NOTES (from JS verson of Widgets):
    The Chrome browser (using JS) gets every single permutation of size-calculations
    (calculate the viewport bounds) correct, but FireFox sucks totally!
    Though, Dart is not exposing viewportElement correctly and other issues too.

    With Chrome, (using JavaSript) any of these permutations worked:
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

        DOING THIS WITHOUT FUTURES: (EASY IN JS; dart:html framework made this ridiculous.
        The following few lines of code were the ONLY "immediate" version (non Future) that worked
        in Dartium from what I could determine, though the need to figure out scrollbar width
        was an added layer of garbage subject to issues:

            final int   scrollBarWidth  = 17;  //"standard" width?
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
//                print("NESTED FUTURE _CanvasBounds.L, T, R, B: ${_CanvasBounds.L}, ${_CanvasBounds.T}, ${_CanvasBounds.R}, ${_CanvasBounds.B} ");
//                print("NESTED FUTURE _CanvasBounds.L, T, R, B: ${_Canvas.width}, ${_Canvas.attributes['height'].convertToSpecifiedUnits(SVGLength.SVG_LENGTHTYPE_PX)}");
//                _Canvas.attributes['height'].convertToSpecifiedUnits(SVGLength.SVG_LENGTHTYPE_PX);
//                print("NESTED FUTURE _CanvasBounds.L, T, R, B: ${_Canvas.width}, ${_Canvas.attributes['height'].valueAsString()}");

                if (!_isAppReady) {
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
    any widgets that are aligned to the right and/or bottom bounds of the canvas will have
    their bounds and/or position affected.
    Here we loop through the application's widgets only looking at "top" (parent-less) widgets
    since it is only that set of widgets that can be aligned to the canvas (their "container");
    furthermore, since the upper-left corner always remains position (0,0) for the canvas's
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
                if (((ptrChildWidgetAlignObj.R.objToAlignTo == null) && (ptrChildWidgetAlignObj.R.dimension > eSides.None)) ||
                    ((ptrChildWidgetAlignObj.B.objToAlignTo == null) && (ptrChildWidgetAlignObj.B.dimension > eSides.None)))
                {
                    ptrChildWidget.reAlign();
                    ptrChildWidget.ReAlignSiblings();  //since other top-level widgets could align to the re-aligned widget
                }
            }
        }
    } //...resize()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    addCanvasResizeWatcher
    For functionality like aligning to the right or bottom of browswer's current window
    bounds, we need to be able to detect Canvas resize events and handle appropriately.
    The called ReSize() event will update bounds information.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _addCanvasResizeWatcher() {
        window.on.resize.add( (event) => _resize(event) );
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: PUBLIC METHODS
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    getCSSPropertyValuesForClassNames

    Pass in space-delim list of selector (class) names as String, and array of PropertyNames
    that we wish to fetch values for (as well as default-values, if none are found here).
    The return values are placed in the passed-in array (which is passed by reference).
    See CSSTargetsMap (Class) documentation for more... it provides eash space-delim value.

    CRITICALLY IMPORTANT FORMAT: Browser (Chrome 18+) ONLY processes SelectorNames properly
    if SPACE-DELIMITED (commas cause issues!)  So, make sure to pass formatted appropriately.

    NOTE:
    Even thouch SVG-SPECIFIC PropertyNames appear in Chrome's object-inspector (debugger)
    as non-hyphenated camelCase (e.g., strokeWidth), our getPropertyValue lookups must use
    use the hyphenated lower-case form (e.g., stroke-width) --at least for Chrome v18+ -- to get values.
    Caller must load PropertyName values within array appropriately!

    NOTE:
    Border-STYLE(s) are at end of each array passed to this routine (for border groups),
    and when we reach the style attribute(s), we can then look at already-encountered
    border-width data to determine our enumerated internal "eBorderStyle").

        FURTHER STYLING NOTE: Include "UseVirtualBorder" in the SelectorNames list to access our
        "virtual" styles of "Raised" and "Lowered" when the provided CSS Style is Outset/Inset
        respectively (i.e., we use this phrase to detect our desire for an enhanced
        double-line version of outset/inset border).

    NOTE: The CSS StyleSheet values MUST USE A valid unit of measure (e.g., px, pt, em)
    AFTER ANY SIZES or they will intrepret to zero here!!!  Numbers without UOM suffix yield ZERO!
    The getComputedStyle ==> getPropertyValue ==> yields WHOLE NUMBER (INT) VALUES (in px),
    and REQUIRES a specified UOM in the CSS stylesheet definitions.

    MORE NOTES:
    I TRIED to use the Future<CSSStyleDeclaration> implementation of getComputedStyle(),
    but NOTHING would work (UPDATE: this was probably due to same issue as getting window-size
    using a Future, which had to wait for all code in main() to finish before run).
    So, I looked into the Dart source code, and it is just returning window.$dom_getComputedStyle() anyhow.
    http://code.google.com/searchframe#TDGadvYaD94/trunk/dart/lib/html/dartium/html_dartium.dart
        (search for "getComputedStyle" to find relevant lines)
    So, INSTEAD OF USING a FUTURE, I just hard-coded the $dom_... approach here.

    ═══════════════════════════════════════════════════════════════════════════════════════
    RELATED IDEA: make more generic; rect-only for now... may eventually need text-metrics
    calcs if native SVG-Text is used (which requires manual metrics calcs, line-splits, etc)

    ═══════════════════════════════════════════════════════════════════════════════════════
    ISSUES! BUG IN WEBKIT!  (NEED TO REPORT - TODO)
    More of the WebKit buggy mess has been exposed, this time with regard to zoom-factors
    and how it affects this off-screen getComputedStyle stuff.  It SHOULD always return the
    same INT values, regardless of zoom level, but it does not.  And, this apparently only
    affects *BORDER STYLES* and not margin/padding values.

    This causes Math.parseInt() to fail later when we expect an int all the time.
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
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    getCSSPropertyValuesForClassNames(String targetName, String SelectorNames, List<StyleTarget> listStylable) {
        String  sPropertyName       = '';
        String  sPropertyValue      = '';
        String  sCalculatedValue    = '';
        num     iBorderWidth        = 0.0;
        int     iIndex              = 0;
        bool    useVirtualBorder    = false;

        if (SelectorNames.indexOf('UseVirtualBorder') > -1) {useVirtualBorder = true;}

        setSVGAttributes(_cssTestingRect, {'class': SelectorNames});
        //print("BEGIN GetCSSPropertyValuesForClassNames WITH SelectorNames: ${SelectorNames}  targetName: ${targetName}");

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
                //now, see if style maps to one in our list of style names: e.g., index of 1 for "solid"
                iIndex = eBorderStyle.Names.indexOf(sCalculatedValue.toLowerCase());

                //now, check for "virtual" extensions to inset/outset border-styles; convert those to our own internal styles of lowered/raised respectively
                if ((iIndex == eBorderStyle.Outset)  && (useVirtualBorder)) {iIndex = eBorderStyle.Raised;}
                if ((iIndex == eBorderStyle.Inset)   && (useVirtualBorder)) {iIndex = eBorderStyle.Lowered;}

                //any border style unknown to us shall be treated as "none"
                sCalculatedValue = (iIndex == -1 ? eBorderStyle.Names[eBorderStyle.None] : eBorderStyle.Names[iIndex]);

//                print("TargetObjectName=${targetName};  sPropertyName=${sPropertyName};  UseVirtualBorder=${useVirtualBorder}; eBorderStyle.Name=${eBorderStyle.Names[iIndex]};  ==>${sCalculatedValue} (CALC)");
            }

            target.calcValue = sCalculatedValue;
        } //for

    } //...getCSSPropertyValuesForClassNames()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    addWidget

    InstanceName must be unique to our application when we add a reference to our WidgetsList.
    This method expects to be invoked by a Widget (during Widget initialization)
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void addWidget (Widget objToAdd) {
        //make sure objToAdd is proper Type before allowing add...
        if (objToAdd is! Widget) {
            throw new InvalidTypeException('Application.AddWidget',  'Widget', objToAdd);
        }

        //make sure InstanceName (of object being added to list) is Unique
        if (isInstanceNameUnique(_widgetsList, objToAdd.instanceName)) {
            _widgetsList.add(objToAdd);
        } else {
            throw new UniqueConstraintException(objToAdd.instanceName);
        }
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    removeWidget

    This method is called from Widget destructor methods to free application references
    to any Widget being destroyed. We clear "selected" widgets too, since the removal
    of a widget could otherwise leave straggling widget references in selected-list.

    If a given InstanceName exists in our app's WidgetsList, remove it.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void removeWidget(String instanceNameToRemove) {
        int indexToRemove = indexOfInstanceName(_widgetsList, instanceNameToRemove);

        //make sure InstanceName (of object being added to list) is Unique
        if (indexToRemove > -1) {
            clearWidgetSelection();
            _widgetsList.removeRange(indexToRemove, 1);
        }
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    The following are various helper-functions for accessing Widget-List information that
    would otherwise be private.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    int getWidgetCount() {
        return _widgetsList.length;
    }

    Widget getWidgetByIndex(int IndexOfObjectToGet) {
        return _widgetsList[IndexOfObjectToGet];
    }


    int indexOfWidget(Widget widgetToLocateInList) {
        return _widgetsList.indexOf(widgetToLocateInList);
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Selection-list handling routines
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void clearWidgetSelection() {
        for (Widget widget in selectedWidgetsList) {
            widget.selectionRect.attributes['display'] = 'none';
        }

        selectedWidgetsList.clear();
    }

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    When adding to what Widgets are "selected", re-selecting an already selected Widget
    will de-selcect it and return false (true otherwise).
    Additional logic herein also prevents situations like multi-selecting children
    of a selected widget (since, they are "owned" by selection already).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    bool addWidgetToSelection(Widget widgetToAdd) {
        int             indexTest       = -1;
        bool            alreadySelected = false;
        List<String>    hierTest        = null;
        List<String>    addPathSplit    = null;
        SVGElement      _animation      = null;  //TODO: Testing

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

        //Now make it visually clear what is selected (TODO: This will be unnecessary in the future additional "box-draw" multi-select version)
        setSVGAttributes(widgetToAdd.selectionRect, {
            'display'       : 'inherit',
            'visibility'    : 'visible'
        });

        return true;

    } //addWidgetToSelection



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Count all the top-level Widgets (i.e., those residing on our Canvas object);
    if optional parm specified, return count of only those widgets later (after specified index) in list.
     ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    int getTopLevelWidgetsCount ([int stopAtIndex = 0]) {
        int countWidgets = 0;
        int i = _widgetsList.length;

        while (i-- > stopAtIndex) {
            if (!_widgetsList[i].hasParent) {
                countWidgets++;
            }
        }
        return countWidgets;
    } //...getTopLevelWidgetsCount()




    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CONSTRUCTOR

    Parameters:
        ourAppName: should be obvious; just notational
        canvasElement: the SVG element (obj reference) to use as our Canvas
        _onAppReady: the ChangeHandler (a method) called when this app is "ready"
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    Application(String ourAppName, SVGSVGElement canvasElement, this._onAppReady) :
        //Create list to track Widgets owned by this application
        _widgetsList        = new List<Widget>(),
        selectedWidgetsList = new List<Widget>()
    {

        _name = ourAppName;

        if (canvasElement is! SVGSVGElement) {
            throw new InvalidTypeException('$_name (Application Object) Constructor : canvasElement is not an instance of SVGSVGElement.',  'SVGSVGElement', canvasElement);
        }

        _canvas = canvasElement;

        //Determine what type of browser this app is running within
        _browserType = getBrowserType();

        _isStandaloneSVG    = document.window.location.href.toLowerCase().endsWith('.svg');
        _isRunningOnServer  = document.window.location.href.toLowerCase().startsWith('http');

        //a brute-force way to see if we are dealing with a .svg file (vs. .html, etc)
        _isStandaloneSVG    = (window.location.pathname.toLowerCase().endsWith(".svg") );

        _updateCanvasAttributes();
        _addCanvasResizeWatcher();

        //Make sure our testing objects are available once canvas is ready
        _createMetricsTestingObjects();

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Create our initial bounds object and update its values.
        NOTE: This also "completes" the app-load when _UpdateCanvasBounds fires the callback
        specified in constructor, which transfers control back to method in main()
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _canvasBounds = new ObjectBounds();
        _updateCanvasBounds();

    } //constructor


} //Application (class)
