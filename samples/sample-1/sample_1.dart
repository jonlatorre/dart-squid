/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

import 'dart:html';
import 'dart:math';
import 'dart:svg';

/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
NOTE: For our own libraries, must specify .dart extension.
Furthermore, we prefix all our library references within this test application to avoid
any potential namespace collisions.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
import '../../lib/dart_squid.dart' as dsvg;


class DemoItemDef {
    final num       x;
    final num       y;
    final num       width;
    final num       height;
    final bool      isShowing;
    final bool      isMovableX;
    final bool      isMovableY;
    final bool      isSizableX;
    final bool      isSizableY;
    final String    menuButtonCaption;
    final num       menuButtonWidth;
    final String    descriptionText;

    const DemoItemDef(
        this.x,
        this.y,
        this.width,
        this.height,
        this.isShowing,
        this.isMovableX,
        this.isMovableY,
        this.isSizableX,
        this.isSizableY,
        this.menuButtonCaption,
        this.menuButtonWidth,
        this.descriptionText
    );

} //DemoItemDef class


/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: main() is Entry point from SVG/HTML
███████████████████████████████████████████████████████████████████████████████████████████
*/
main() {

    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CREATE FORWARD-DECLARATIONS FOR TESTING VARIABLES/OBJECTS
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    dsvg.Application    globalApplicationObject = null;

    dsvg.Widget         testWidget1     = null;
    dsvg.Widget         testWidget2     = null;
    dsvg.Widget         testWidget3     = null;

    dsvg.Widget         topMenuHolder   = null;
    List<dsvg.HtmlWidget> menuButtons   = null;

    dsvg.HtmlWidget     embeddedWebPage = null;
    dsvg.HtmlWidget     notesPage       = null;
    dsvg.IFrameWidget   webIFrame       = null;
    dsvg.HtmlWidget     foRepaintTests  = null;

    dsvg.HtmlWidget     btnLog          = null;
    dsvg.HtmlWidget     btnDel          = null;

    dsvg.TriStateOptionWidget   checkboxTest1   = null;

    dsvg.CompositeWidget        compTest1       = null;

    //This group is for when we are testing within HTML
    Element divInner    = null;
    Element divHeader   = null;


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Misc required constants, objects and such...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    const String APP_CANVAS_ELEMENT_ID  = '#dartsquidAppCanvas';
    const String APP_NAME               = 'mySampleApplication';

    //Use this to initialize our "menu buttons" at top of page; indexed by instanceName
    final Map<String, DemoItemDef> DemoItemDefs = const {
        //instanceName                              x   , y     , width , height,showing, movex , movey , sizex , sizey , btnCaption                , btnWid, Description
        'myWidget1'             : const DemoItemDef(100 , 100   , 200   , 100   , true  , true  , true  , true  , true  , 'Widget1'                 , 80    , 'This widget is aligned to bottom/right corner of page.'    ),
        'myWidget2'             : const DemoItemDef(100 , 100   , 400   , 400   , true  , true  , false , false , false , 'Widget2'                 , 80    , 'Container for smaller widget. Limitted to X-axis Moves.'    ),
        'myWidget3'             : const DemoItemDef(100 , 100   , 100   , 100   , true  , true  , true  , true  , true  , 'Widget3'                 , 80    , ''    ),
        'WidgetNotesWebPage'    : const DemoItemDef(50  , 85    , 650   , 550   , true  , true  , true  , false , true  , 'Features & Notes'        , 160   , ''    ),
        'EmbedWebPage'          : const DemoItemDef(0   , 0     , 100   , 100   , false , true  , true  , true  , true  , 'README (via XHR)'        , 160   , ''    ),
        'FORepaintTestsPage'    : const DemoItemDef(500 , 350   , 800   , 500   , true  , true  , true  , true  , true  , 'FO Repaint Tests'        , 160   , ''    ),
        'checkboxTest'          : const DemoItemDef(820 , 50    , 50    , 50    , true  , true  , true  , true  , true  , 'Tri-State ckBox'         , 140   , 'Tri-state image control: checkbox or similar.'    ),
        'compositeTest'         : const DemoItemDef(320 , 250   , 170   , 70    , false , true  , true  , true  , true  , 'Composite'               , 110   , 'Composite Widget (i.e., Widget with embedded Widget(s).'    ),
        'EmbedWebPageInIFrame'  : const DemoItemDef(10  , 60    , 700   , 600   , false , true  , true  , true  , true  , 'IFrameWidget'            , 120   , ''    )
    };


    final List<dsvg.ConstSvgDefsItem>  InitialImageListItems = const [
        const dsvg.ConstSvgDefsItem('checkMarkOn'  , defURL: '../../resources/graphics/blue_check_symbol.svg' ),
        const dsvg.ConstSvgDefsItem('checkMarkNull', defURL: '../../resources/graphics/gray_check_symbol.svg' ),
        const dsvg.ConstSvgDefsItem('filter3D'  , defURL: '../../resources/filters/standard_filters.svg' ),
//        const dsvg.ConstSvgDefsItem('ferrari'  , defURL: 'Ferrari.svg' ),
//        const dsvg.ConstSvgDefsItem('failtest1'  , defURL: 'missing-file-here.svg' ),
//        const dsvg.ConstSvgDefsItem('failtest2-no-valid-parms' ),
//        const dsvg.ConstSvgDefsItem('failtest3' , defText: '<svg id="missing-attr-end-quote-here><g></g></svg>' ),
        const dsvg.ConstSvgDefsItem('textTest'  , defText: '<svg id="via_Text"><g></g></svg>' )
     ]; //InitialImageListItems



    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: VARIOUS TESTING METHODS CALLED BY main()
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    String testStringCondition(String value, String expectedValue) {
        String  PassFail = ((value.toString() == expectedValue) ? "OK" : "FAIL");
        return '${value} (EXPECTED: ${expectedValue}) [${PassFail}]';
    }


    void testWidgetMetrics() {
        dsvg.logToConsole([
            '',
            'LINE1',
            'dsvg.WidgetMetrics tests',
            'LINE2',
            'Instantiating and setting Margin.R value...'
        ]);

        var testWidgetMetrics = new dsvg.WidgetMetrics();
        testWidgetMetrics.Margin.R = 222.2;

        dsvg.logToConsole([
            testWidgetMetrics,
            "testWidgetMetrics.Margin(aka,WidgetBounds).CX: ${testStringCondition( testWidgetMetrics.Margin.CX.toString(), '111.1' )}",
            'LINE1'
        ]);
    }


    void testObjectBounds() {
        dsvg.logToConsole([
            '',
            'LINE1',
            'dsvg.ObjectBounds tests',
            'LINE2',
            'Instantiating...'
        ]);

        dsvg.ObjectBounds testBounds = new dsvg.ObjectBounds();
        testBounds
            ..L = 10.0
            ..R = 110.0
            ..T = 20.0
            ..B = 170.0;

        dsvg.logToConsole([
            testBounds,
            "testBounds.L:      ${testStringCondition( testBounds['L'].toString(),     '10.0' )}",
            "testBounds.R:      ${testStringCondition( testBounds['R'].toString(),     '110.0' )}",
            "testBounds.Width:  ${testStringCondition( testBounds['Width'].toString(), '100.0' )}",
            "testBounds.CX:     ${testStringCondition( testBounds['CX'].toString(),    '60.0' )}",
            'LINE3',
            "testBounds.T:      ${testStringCondition( testBounds['T'].toString(),     '20.0' )}",
            "testBounds.B:      ${testStringCondition( testBounds['B'].toString(),     '170.0' )}",
            "testBounds.Height: ${testStringCondition( testBounds['Height'].toString(),'150.0' )}",
            "testBounds.CY:     ${testStringCondition( testBounds['CY'].toString(),    '95.0' )}",
            'LINE1'
        ]);
    }


    void testAlignSpec() {
        dsvg.logToConsole([
            '',
            'LINE1',
            'dsvg.AlignSpec tests',
            'LINE2',
            'Instantiating...'
        ]);

        dsvg.AlignSpec testAlignSpec = new dsvg.AlignSpec();

        testAlignSpec.aspectValue = 123.45;
        testAlignSpec.resetAlignSpec();

        dsvg.logToConsole([
            testAlignSpec,
            "testAlignSpec.aspectValue: ${testStringCondition( testAlignSpec.aspectValue.toString(), '0.0' )}",
            'LINE3',
            "TODO: a thorough dsvg.AlignSpec test requires more scenarios.",
            'LINE1'
        ]);

    }


    void testAlign() {
        dsvg.logToConsole([
            '',
            'LINE1',
            'dsvg.WidgetAlignment tests',
            'LINE2',
            'Instantiating...'
        ]);

        dsvg.WidgetAlignment testAlign = new dsvg.WidgetAlignment();
        testAlign['T'].aspectValue = 112.12;

        dsvg.logToConsole([
            testAlign,
            "testAlign.T:      ${testAlign.T}",
            "testAlign['T'].aspectValue:      ${testStringCondition( testAlign['T'].aspectValue.toString(),       '112.12' )}",
            'LINE3',
            "TODO: a thorough dsvg.WidgetAlignment test require creation of a Widget to align to, canvas align test, and much more.",
            'LINE1'
        ]);

    } //TestAlign


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Various callback methods for testing...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    EXAMPLE CALLBACK F(X) of NotifyEvent Type..
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void testWidgetOnShowEventCallback(dynamic eventObj) {
        dsvg.logToConsole([
            'LINE3',
            "${eventObj.instanceName} onShow EVENT fired"
        ]);
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    EXAMPLE CALLBACK F(X) of MouseNotifyEventObject Type..
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void btnDeleteWidgetMouseClick(dsvg.MouseNotifyEventObject eventObj) {
        dsvg.HtmlWidget widget = eventObj.sender;

        widget.caption = 'Deleted 1';

        dsvg.logToConsole([
            'LINE2',
            "${widget.instanceName} btnTextMouseClick EVENT fired at coordinates (${eventObj.eventInfo.clientX},${eventObj.eventInfo.clientY})",
            'LINE3',
            "Application Widgets List:"
        ]);

        globalApplicationObject.widgetsList.forEach( (widgetListItem) {
            print("    ${widgetListItem.instanceName}");
        });


        if (testWidget1 != null) {
            dsvg.logToConsole([
                'LINE4',
                '${testWidget1.instanceName} Destroy() being executed; next btn-click should show list less this InstanceName'
            ]);

            testWidget1.destroy();
            testWidget1 = null;
        }

        dsvg.logToConsole([
            'LINE2'
        ]);
    }


    void btnTestOnMouseDown(dsvg.MouseNotifyEventObject eventObj) {
        dsvg.HtmlWidget widget = eventObj.sender;

        dsvg.logToConsole([
            'LINE2',
            "${widget.instanceName} btnTestOnMouseDown EVENT fired at coordinates (${eventObj.eventInfo.clientX},${eventObj.eventInfo.clientY})"
        ]);

    } //btnTestOnMouseDown




    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    This method is called by each of the "menu buttons" along the top of the sample page.
    Show/Hide the Widget associated with each button, and toggle the button-colors
    between red/green background respectively to visually reflect [Widget.visible] status.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void menuButtonsClickHandler(dsvg.MouseNotifyEventObject eventObj) {
        var sender = eventObj.sender;
        dsvg.Widget _targetWidget = null;

        int indexTest = dsvg.indexOfInstanceName(globalApplicationObject.widgetsList, eventObj.sender.tag);

        if (indexTest > -1) {
            _targetWidget    = globalApplicationObject.getWidgetByIndex(indexTest);

            print("${sender.instanceName}  Click fired at coordinates (${eventObj.eventInfo.clientX}, ${eventObj.eventInfo.clientY}) by Widget with tag = ${eventObj.sender.tag} to ${(_targetWidget.visible ? 'HIDE' : 'SHOW')} Widget with instanceName = ${_targetWidget.instanceName}.");

            _targetWidget.toggleVisibility();

            //update the look of our button to reflect whether it's "target widget" is showing or not.
            sender.classesCSS.setClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base,${(_targetWidget.visible ? "LightGreenFill" : "LightPinkFill")}');
        }

    } //menuButtonsClickHandler



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    This method can be used to test how the type-checking works if an event is wired
    to the wrong method signature.  A type-error will occur if a mouse-event is pointed
    to this "standard" (non mouse) notify event, and further output will be prevented.
    TODO: EventsProcessor needs extended to do type checking yet.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void IncorrectMouseEventSignatureTest(dsvg.NotifyEventObject eventObj) {
        dsvg.Widget widget = eventObj.sender;

        dsvg.logToConsole([
            'LINE2',
            "${widget.instanceName} IncorrectMouseEventSignatureTest EVENT -- this will never be reached",
            'LINE2'
        ]);
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Create some stuff IF WE ARE TESTING FROM WITHIN HTML DOCUMENT
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    void  createHTMLTestObjects() {

        divHeader = document.query('#headline');

        void junkHandler(var handledElement) {
            handledElement.innerHtml = "SET VIA junkHandler";
        }


        var a = {'class':'BoldRed', 'style': 'border:2px solid black; background-color:yellow; text-align:center;'};
        divHeader.innerHtml = "DART RUN STARTED &mdash; see console for tracing information";
        dsvg.setElementAttributes(divHeader, a);
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Methods used to create various widgets
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    ///Some common widget-initialization using Map (allows quickly changing tests)
    void initializeTestWidget(dsvg.Widget newWidgetRef) {
        DemoItemDef def = DemoItemDefs[newWidgetRef.instanceName];
        if (def == null) return; //TODO: THROW ERROR

        newWidgetRef
            ..setBounds(def.x, def.y, def.width, def.height)
            ..isMovable.x = def.isMovableX
            ..isMovable.y = def.isMovableY
            ..isSizable.x = def.isSizableX
            ..isSizable.y = def.isSizableY;

    } //initializeTestWidget


    ///Like initializeTestWidget idea, but show() does not always immediately follow the parameters set in initializeTestWidget.
    void showOrNot(dsvg.Widget newWidgetRef) {
        DemoItemDef def = DemoItemDefs[newWidgetRef.instanceName];
        newWidgetRef.visible = def.isShowing;
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Test creating a widget on the app canvas.
    Align it to the bottom-right corner of viewport.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createTestWidget1() {
        //create a widget on the canvas
        testWidget1  = new dsvg.Widget('myWidget1', globalApplicationObject);
        initializeTestWidget(testWidget1);

        testWidget1
            ..align.R.aspect = dsvg.eAspects.R
            ..align.B.aspect = dsvg.eAspects.B;

        //testWidget.onAlign = btnMenuOnAlign;

        //TODO: Next line works as desired, but DART EDITOR (through build r14458 so far) throws warning: "expression does not yield a value"
        testWidget1.on.show = testWidgetOnShowEventCallback(testWidget1);

        //test incorrect callback signature traps...
        //testWidget.on.mouseDown = IncorrectMouseEventSignatureTest;

        testWidget1.on.mouseDown = btnTestOnMouseDown;

        testWidget1.anchors = dsvg.eAspects.R;

        showOrNot(testWidget1);

        dsvg.logToConsole([
            'LINE1',
            'createTestWidget1 method finished; object created:',
            testWidget1
        ]);
   }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Test creating a widget on the app canvas.
    Align its right-side to the left side of another widget.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createTestWidget2() {
        testWidget2 = new dsvg.Widget('myWidget2', globalApplicationObject);
        initializeTestWidget(testWidget2);

        testWidget2
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Base', 'TanFill')
            ..align.R.objToAlignTo = testWidget1
            ..align.R.aspect = dsvg.eAspects.L;

        showOrNot(testWidget2);

        dsvg.logToConsole([
            'LINE1',
            'createTestWidget2 method finished; object created:',
            testWidget2
        ]);
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Test creating a square widget within another widget.
    Apply a different css style to it.
    Put the begin/end-update stuff to the test too.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createTestWidget3() {

        //setting a constraint "= testConstraint" would be equiv to setting it inline to: "= num (dsvg.MouseNotifyEventObject objInitiator) {return -100; }"
        num testConstraint() {
            return -100.0;
        }

        testWidget3 = new dsvg.Widget('myWidget3', globalApplicationObject, testWidget2);
        initializeTestWidget(testWidget3);
        showOrNot(testWidget3);

        //test "costly change" inside begin/endUpdate block...
        testWidget3.beginUpdate();
        testWidget3
            ..setBounds(120,120,110,150)
            ..align.CX.aspect = dsvg.eAspects.R
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Base', 'RedFill')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame', 'FrameOption3')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter', 'RaisedBorder')      //Test "outset" ==> "raised" (virtual border style)
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter', 'UseVirtualBorder')  //Test "outset" ==> "raised" (virtual border style)
            ..sizeRules.maxWidth = 200
            ..sizeRules.minWidth = 50
            ..sizeRules.maxHeight = 200
            ..sizeRules.minHeight = 50
            ..posRules.minX = (dsvg.MouseNotifyEventObject objInitiator) {return -300; }
            ..posRules.maxX = (dsvg.MouseNotifyEventObject objInitiator) {return 100; }
            ..posRules.minY = (dsvg.MouseNotifyEventObject objInitiator) {return -100; }
            ..posRules.maxY = (dsvg.MouseNotifyEventObject objInitiator) {return 420; };
//        testWidget3.PosRules.MinX = (dsvg.MouseNotifyEventObject objInitiator) {return textButton.x; };  //TODO: Test more substantial ideas..
        testWidget3.endUpdate();

        dsvg.logToConsole([
            'LINE1',
            'createTestWidget3 method finished; object created:',
            testWidget3
        ]);
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    TODO: Additional Tests / Examples:
        + more Anchor examples
        + more alignment hooks - using callbacks
        + further constraint examples
        + Better visual info about what constraints are in effect for various Widgets
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Creates a container for various menu buttons, positions it along the top using only
    alignment features (vs. setting specific size).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createMenuButtonsContainer() {
        topMenuHolder = new dsvg.Widget('MenuButtonsContainer', globalApplicationObject);
        topMenuHolder
            ..height = 50
            ..align.T.aspect = dsvg.eAspects.T
            ..align.R.aspect = dsvg.eAspects.R
            ..align.L.aspect = dsvg.eAspects.L
            ..sizeRules.minWidth = 500
            //Style it...
            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_Base',         'MenuButtonsContainer')
            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame',        'MenuButtonsContainerFrame')
            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderOuter',  'OutsetBorder')
            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderInner',  'GrooveBorder')
            ..show();

        dsvg.logToConsole([
            'LINE1',
            'createMenuButtonsContainer method finished; object created:',
            topMenuHolder
        ]);
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Creates various menu buttons using info fron ButtonDefs (list) to size them, space
    them, and assign some labels (text); style them to look like buttons. Add click-handler.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createMenuButtons() {
        dsvg.HtmlWidget tempMenuButton = null;
        menuButtons     =  new List<dsvg.HtmlWidget>();
        num currentLeft = 10;

        DemoItemDefs.forEach( (String key, DemoItemDef itemInList) {
            tempMenuButton = new dsvg.HtmlWidget('MenuButton${key}', globalApplicationObject, parentInstance: topMenuHolder);
            tempMenuButton
                ..setBounds((currentLeft), 10, itemInList.menuButtonWidth, 40)
                ..align.CY.aspect = dsvg.eAspects.CY
                ..classesCSS.setClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base,${(itemInList.isShowing ? "LightGreenFill" : "LightPinkFill")}')
                ..classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame')
                ..classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderOuter','ButtonWidget_BorderOuter, UseVirtualBorder')
                ..classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderInner','ButtonWidget_BorderInner')
                ..caption = itemInList.menuButtonCaption
                ..tag = key
                ..on.mouseClick = menuButtonsClickHandler;

            //add to our container list and show it
            menuButtons.add(tempMenuButton);
            tempMenuButton.show();

            currentLeft = currentLeft + itemInList.menuButtonWidth;
        }); //...forEach

        dsvg.logToConsole([
            'LINE1',
            'createMenuButtons method has finished; all buttons have been created.'
        ]);

    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    This method is called our "Log to Console" button is clicked.
    Provides a way to dump info about various Widgets in this sample for inspection and
    debugging purposes.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void btnLogAppWidgetsDataToConsoleClick(dsvg.MouseNotifyEventObject eventObj) {

        dsvg.logToConsole([
            'LINE1',
            'btnLogWidgetsDataToConsole (VIA CLICK EVENT) Executed',
            'LINE2',
            "ALL objects contained in Application's Widget's List (widgetsList) follow:"
        ]);

        globalApplicationObject.widgetsList.forEach( (widgetInList) {
          dsvg.logToConsole([
              'LINE3',
              widgetInList
          ]);
        }); //...forEach

        //TODO: move to Sample_2: checkboxTest1.isNullable = !(checkboxTest1.isNullable);

    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    HtmlWidget being used as a "button" with a click event.
    This particular one is wired to a routine that logs Application's widget data to console.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createLogAppWidgetsDataToConsoleButton() {
        //create a "button" on the canvas; the click event is what makes it behave like a button.
        btnLog  = new dsvg.HtmlWidget('myTextButton', globalApplicationObject);
        btnLog
            ..setBounds(520,50,225,35)
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','ButtonWidget_BorderOuter, UseVirtualBorder')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','ButtonWidget_BorderInner')
            ..on.mouseClick = btnLogAppWidgetsDataToConsoleClick
            ..caption = "Log App's Widgets' Info Now"
            ..show();

        dsvg.logToConsole([
            'LINE1',
            'btnLogAppWidgetsDataToConsole method finished; object created:',
            btnLog
        ]);
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    HtmlWidget being used as a "delete button" with a click event.
    This particular one tests truncation of overflow text and also uses callback that
    deletes another widget and logs some information.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createDeleteWidgetButton() {
        //create a "button" on the canvas; the click event is what makes it behave like a button.
        btnDel  = new dsvg.HtmlWidget('myTextButton', globalApplicationObject);
        btnDel
            ..setBounds(20,70,95,35)
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','ButtonWidget_BorderOuter, UseVirtualBorder')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','ButtonWidget_BorderInner')
            ..on.mouseClick = btnDeleteWidgetMouseClick
            ..caption = 'DELETE-1-ABCDEF-GHI-JKL-MNO-PQR-STUVWXY-Z'  //here to test clipping of overflow
            ..show();

        dsvg.logToConsole([
            'LINE1',
            'createDeleteWidgetButton method finished; object created:',
            btnDel
        ]);
    } //CreateTextButton1



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    HtmlWidget (which uses internal foreign object (FO) for text/HTML display).
    This particular test is for loading the FO with content returned via XHR
    if we are running this sample on local server.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createWebPageInWidget() {
        embeddedWebPage = new dsvg.HtmlWidget('EmbedWebPage', globalApplicationObject);
        embeddedWebPage.setBounds(50,50,800,600);
        embeddedWebPage.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base'       ,'Widget_Base_White');
        embeddedWebPage.embeddedFO.scrollOverflow = true;
        embeddedWebPage.caption = '''
            <div>
                <em><span itemprop="description">PLACEHOLDER HTML to be overwritten by XHR action. This text shows if you
                are not accessing this SVG Widgets application over HTTP (e.g., if accessing via file://...).</span></em>
                <br>
                <br>
        ''';

        //ONLY POSSIBLE WHEN ACCESSING VIA HTTP..., otherwise, we will get hit with:
        //HttpRequest cannot load file:///drive:/path_to_file/readme.html. Cross origin requests are only supported for HTTP.
        //Exception: Error: NETWORK_ERR: HttpRequest Exception 101
        if (dsvg.isRunningOnServer()) {

            //effectively, getWebPageContent asynchronously now; could use HttpRequest.request and grab the xhr.responseText result
            //or use the specialized HttpRequest.getString method which returns a String (as we chose here)
            HttpRequest.getString("dart_squid_SVG_UI_Widgets_Documentation.html").then(
                (xhr) {
                    //load the raw response text from the server into our foreign object
                    embeddedWebPage.embeddedFO.htmlDiv.innerHtml= xhr;
                },
                onError: (e) {
                    // error!
                });
        }

        dsvg.logToConsole([
            'LINE1',
            'createWebPageInWidget method finished (isRunningOnServer=${dsvg.isRunningOnServer()}); object created:',
            embeddedWebPage
        ]);

    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    HtmlWidget (which uses internal foreign object (FO) for text/HTML display).
    This example simply displays some static HTML content (notes about dart-squid).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createNotesWidget() {
        notesPage  = new dsvg.HtmlWidget('WidgetNotesWebPage', globalApplicationObject);
        initializeTestWidget(notesPage);

        notesPage
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'Notes_Base')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','RaisedOutsetComponent, UseVirtualBorder')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','LoweredInsetComponent, UseVirtualBorder')
            ..embeddedFO.scrollOverflow = true;

        notesPage.caption = '''
            <div class="FOBackground">
            <span class="BoldRed " >SVG Components Features &amp; Notes</span><br /><br />
            <div class="FeaturesText">
                Pure-SVG Widget/Component-Set Highlights:<br />
                <ul>
                    <li><b>Nesting of widgets</b> (visual and true object-hierarchical); rather like Delphi panels and controls.</li>
                    <li><b>Base Widget implements borders, positioning, sizing, and alignment</b> (relative to other Widget parts, parent/container-widgets, or browser-window bounds).</li>
                    <li><b>Borders Sub-Components</b> include margin, outer, frame, inner, and padding (from outermost to innermost).</li>
                    <li><b>Movable/Sizable</b> (including sizing, moving, and position rules/constraints); <b>alignment preserved during move/size operations where it makes sense.</b></li>
                    <li><b>Multi-Select</b> (for Moves) &mdash; depress SHIFT key while left-clicking.</li>
                    <li><b>CSS used to Style parts</b>, including pre-defined border-styles (raised, grooved, flat, etc).</li>
                    <li>Effects via SVG-Filters are possible.)</li>
                </ul>
                <br />
                Note: only Webkit / Blink &mdash; Google Chrome browser, or Dartium for native Dart version &mdash; works <b>reasonably</b> well,
                and as of Dartium/Chromium V28+ builds these issues persist with Webkit-based browsers:<br />
                <ul>
                    <li>Refusal to paint / show initially-showing SVG objects whose on-screen
                    position is dependent on browser-window-metrics.  See the
                    <a href="../samples-index.html">samples-index page</a> for more details;</li>
                    <li>Scrollbar(s) on ForeignObjects get hosed if zoom-factor is not 100% &mdash; Chrome thinks the scrollbar is still at
                    the position it would be at 100% zoom.</li>
                    <li>Cursor-type not honored by browser after mousedown and mousemove begins &mdash; a recent webkit patch (for V30+? perhaps) may finally fix this;</li>
                    <li>Re-use of external SVG-file definitions (of filters,etc) by url(file#def-name) reference does not work (FF gets this right).</li>
                </ul>
                <br />
                <strong>FireFox</strong> (JS version): <b>(issues galore!)</b>
                <br />
                <ul>
                    <li>No resize (of browser-window) event is ever triggered, thus Widgets placed in relative-positions (to browser-dimensions) hosed.</li>
                    <li>In general, getting the browser-dimensions in FF is nearly impossible.</li>
                    <li>Borders not drawing on Widgets (probably position-calc related). Thus, no way to style, move, resize Widgets.</li>
                    <li>And much more...</li>
                </ul>
                <br />
            </div>
            </div>
        ''';

        showOrNot(notesPage);

        dsvg.logToConsole([
            'LINE1',
            'createNotesWidget method finished; object created:',
            notesPage
        ]);

    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    This method is called from event handler assigned to an HTML select-element embedded
    within a foreignObject within the HTML assigned to HtmlWidget "foRepaintTests"
    created in next method (createFoRepaintTestWidget).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void foRepaint_HtmlContolsChangeHandler (event) {
        event.stopPropagation();
        event.preventDefault();

        SelectElement   colorSelectElement      = null;
        SelectElement   frameWidthSelectElement = null;
        String          selectedColorValue      = '';
        String          selectFrameWidthValue   = '';

        colorSelectElement      = document.query("#comboColor");
        frameWidthSelectElement = document.query("#comboFrameWidth");

        //Gets the "value" portion of first-selected option in select-element. (e.g., "RedColor")
        selectedColorValue      = colorSelectElement.value;
        selectFrameWidthValue   = frameWidthSelectElement.value;

        //tracing...
        print('Wired FO-Contained-Object Color Value: ${selectedColorValue}');
        print('Wired FO-Contained-Object FrameWidth Value: ${selectFrameWidthValue}');

        //Change frame based on that selected value (it holds our CSS class to apply).
        foRepaintTests.classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame', 'ButtonWidget_Frame, ${selectedColorValue}, ${selectFrameWidthValue}');

    } //selectColorChangeHandler


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    HtmlWidget (which uses internal foreign object (FO) for text/HTML display).
    This example exists to keep tabs on the outstanding issues with Chrome/Dartium/Webkit
    SVG-rendering-issues (within FOs) when page-zoom is other than 100%.  HTML controls
    and repaint-region (in general) is trashed on non-100%-zooms currently.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createFoRepaintTestWidget() {
        foRepaintTests  = new dsvg.HtmlWidget('FORepaintTestsPage', globalApplicationObject, initialCaption:'testInitialCaption');
        initializeTestWidget(foRepaintTests);

        foRepaintTests
            ..tag = 'FOR1'
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','foRepaintTestsOuterBorder')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','foRepaintTestsInnerBorder')
            ..embeddedFO.scrollOverflow = true;


        foRepaintTests.caption = '''
            <div class="FORepaintTest" style="background-color: #fff8dc; " >
            <span class="BoldRed" >SVG Components FO (SVG Foreign Object) Repaint Tests</span>
            <p>This is the HtmlWidget that uses an <b>SVG ForeignObject (FO)</b> to embed HTML content.
            <br>
            <br>
            FO was used because <span class="BoldRed">automatic HTML content line-wraps</span> occur as desired and as expected of
            any typical HTML output &mdash; FO is just an HTML document embedded inside an SVG control.  Contrast this to native SVG &quot;text&quot;
            elements which offer no automatic line-wrap capabilities currently.
            </p>
            <p>HTML Controls test (edit, select, radio) appear below.  Some of these controls interact with Widget(s) in this Sample Application.</p>
            <p>Set this <b>Widget's Frame Color</b>:
                <select id="comboColor" name="color">
                    <option value="RedColor">Red</option>
                    <option value="MedOrangeColor">Med Orange</option>
                    <option value="DarkOrangeColor">Dark Orange</option>
                    <option value="MedBlueColor">Med Blue</option>
                    <option value="BrightPurpleColor">Bright Purple</option>
                    <option value="MintGreenColor">Mint Green</option>
                </select>
                <br />
                Set this <b>Widget's Frame Width</b>:
                <select id="comboFrameWidth" name="frameWidth">
                    <option value="FrameOption1">2px</option>
                    <option value="FrameOption2">4px</option>
                    <option value="FrameOption3">6px</option>
                    <option value="FrameOption4">8px</option>
                    <option value="FrameOption5">10px</option>
                </select>
                <br />
                Radio Control Test: <input id="inputRadio" type="radio" name="sex" value="Male"/> Male &nbsp;&nbsp;&nbsp;<input type="radio" name="sex" value="Female" /> Female<br />
                Value Input Test: <input id="inputQty" type="value" name="qty" value="1" />
                <br />
                Submit Button Test (does nothing): <input id="inputSubmitButton" type="button" value="submittest1"  name="submit" alt="Submit Test (inactive)" />
            </p>
            <p><span class="BoldRed">BUG NOTE:</span> There is a Webkit/Chrome bug (still exists as of v26 it seems) where the browser, for purposes of embedded scrollbars in the FO,
            interprets the bounding-box of the repainted-FO-region to be only that of the 100%-zoom-factor size, thus
            there will be disfunctional scrollbars at any zoom factor other than 100%
            (since the browser "forgets" where they are and does not process mouse-events on them); use the keyboard instead (pgUp/Down and/or Up/Down Arrows).
            </p>
            </div>
        ''';

        dsvg.logToConsole([
            'LINE1',
            'createFoRepaintTestWidget method finished; object created:',
            foRepaintTests
        ]);

        showOrNot(foRepaintTests);

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        WIRE UP AN EVENT-HANDLER that will fire when our embedded HTML's color and frame-wdith
        selection dropdown values change.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        SelectElement  colorSelectElement = null;
        SelectElement  frameWidthSelectElement = null;

        colorSelectElement      = document.query("#comboColor");
        frameWidthSelectElement = document.query("#comboFrameWidth");

        //assign event-handler to that select element
        colorSelectElement.onChange.listen( (event) => foRepaint_HtmlContolsChangeHandler(event) );
        frameWidthSelectElement.onChange.listen( (event) => foRepaint_HtmlContolsChangeHandler(event) );
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    IFrameWidget example that loads its content from a URL; in this case, display
    our company home-page to demonstrate the fully-functional and navigable web-page
    embedded inside a sizable, movable widget.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createWebPageIFrameWidget() {
        webIFrame  = new dsvg.IFrameWidget('EmbedWebPageInIFrame', globalApplicationObject);
        initializeTestWidget(webIFrame);

        //Some tests that make use of the setURL method...
        //webIFrame.setURL('.');            //display local file directory tree from where we run
        //webIFrame.setURL('README.html');  //display local file in that directory
        webIFrame.setURL('http://www.intersoftdevelopment.com');

        showOrNot(webIFrame);

        dsvg.logToConsole([
            'LINE1',
            'createWebPageIFrameWidget method finished; object created:',
            webIFrame
        ]);
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    This method is called our "Log to Console" button is clicked.
    Provides a way to dump info about various Widgets in this sample for inspection and
    debugging purposes.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void triStateItemClick(dsvg.MouseNotifyEventObject eventObj) {
        dsvg.TriStateOptionWidget triStateWidget = eventObj.sender;

        dsvg.logToConsole([
            'LINE1',
            'triStateItemClick (VIA CLICK EVENT) Executed on ${triStateWidget.instanceName} object.',
            'LINE2',
            'Current "checkState" = ${dsvg.eCheckState.Names[triStateWidget.checkState]}'
        ]);
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    HtmlWidget being used as a "button" with a click event.
    This particular one is wired to a routine that logs Application's widget data to console.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createTriStateItem() {
        //create a "button" on the canvas; the click event is what makes it behave like a button.
        checkboxTest1  = new dsvg.TriStateOptionWidget('checkboxTest',
        globalApplicationObject,
        const [null, 'checkMarkOn','checkMarkNull']
        );

        initializeTestWidget(checkboxTest1);
        checkboxTest1
            ..checkState = dsvg.eCheckState.CHECKED
            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_Base'         , 'CheckboxWidget_Base')
            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame'        , 'CheckboxWidget_Frame')
            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderOuter'  , 'CheckboxWidget_BorderOuter')
            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderInner'  , 'CheckboxWidget_BorderInner')
            ..classesCSS.setClassSelectorsForTargetObjectName('ImageCSSStyle'       , 'filter:url(#Effect_3D);')
            ..on.mouseClick = triStateItemClick;

        showOrNot(checkboxTest1);

        dsvg.logToConsole([
            'LINE1',
            'createTriStateItem method finished; object created:',
            checkboxTest1
        ]);

    } //createTriStateItem


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    COMPOSITE WIDGET INITIAL TESTING...
    TODO: IN PROGRESS AND NOT AT ALL READY
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createCompositeItem() {
        compTest1  = new dsvg.CompositeWidget('compositeTest', globalApplicationObject );

        initializeTestWidget(compTest1);

//        compTest1.embeddedCheck
//            ..checkState = dsvg.eCheckState.CHECKED
//            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_Base'         , 'CheckboxWidget_Base')
//            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame'        , 'CheckboxWidget_Frame')
//            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderOuter'  , 'CheckboxWidget_BorderOuter')
//            ..classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderInner'  , 'CheckboxWidget_BorderInner')
//            ..classesCSS.setClassSelectorsForTargetObjectName('ImageCSSStyle'       , 'filter:url(#Effect_3D);')
//            ..on.mouseClick = triStateItemClick;

        showOrNot(compTest1);

        dsvg.logToConsole([
            'LINE1',
            'createCompositeItem method finished; object created:',
            compTest1
        ]);

    } //createCompositeItem




    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    MAIN() EXECUTION STARTS HERE

    First, CREATE GLOBALLY-AVAILABLE INSTANCE OF OUR APPLICATION OBJECT.
    Parameters are app-name and the SVG Element we will use for our "Canvas", and finally
    the list of image resources we will be re-using throughout our application.
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    //Setup image list used by other controls
    dsvg.SvgDefs ourImageList = new dsvg.SvgDefs(InitialImageListItems);

    globalApplicationObject = new dsvg.Application(APP_NAME, document.query(APP_CANVAS_ELEMENT_ID), ourImageList );

    globalApplicationObject.tracingEnabled = true; //change to false if ALL tracing is to be off.


    /*
    ███████████████████████████████████████████████████████████████████████████████████████████
    OUR "WIDGET-BASED APPLICATION" EXECUTION STARTS HERE...
    ███████████████████████████████████████████████████████████████████████████████████████████
    */
     dsvg.logToConsole([
        'LINE1',
        'WIDGET-BASED APPLICATION" EXECUTION STARTING...'
    ]);

    //Misc non-visual test setups
    testWidgetMetrics();
    testObjectBounds();
    testAlignSpec();
    testAlign();

    //Some basic widget-creation tests
    createTestWidget1();
    createTestWidget2();
    createTestWidget3();

    //Due to Dart issue# 6947, these currently do not work in standalone SVG document.
    if (!dsvg.isStandaloneSVG()) {
        //createDeleteWidgetButton();

        createLogAppWidgetsDataToConsoleButton();

        createNotesWidget();

        createWebPageInWidget();

        createFoRepaintTestWidget();

        createTriStateItem();  //The "checkbox" example

        createCompositeItem();

        //Note: these buttons refer to previously-created objects; be careful moving this
        createMenuButtonsContainer();
        createMenuButtons();

        createWebPageIFrameWidget(); //Show a website inside a widget

        createHTMLTestObjects();
    }

}  //main

