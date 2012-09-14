/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

#import('dart:html');

/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
NOTE: For our own libraries, must specify .dart extension.
Furthermore, we prefix all our library references within this test application to avoid
any potential namespace collisions.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
#import("../../lib/dart_squid.dart", prefix:'dsvg');



class ButtonDef {
  final String      caption;
  final String      tag;
  final num         width;
  final bool        isActive;
  const ButtonDef(this.caption, this.tag, this.width, this.isActive);
}


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

    dsvg.Widget         menuButtonsContainer    = null;
    List<dsvg.HtmlWidget> menuButtons   = null;

    dsvg.HtmlWidget     embeddedWebPage = null;
    dsvg.HtmlWidget     notesPage       = null;
    dsvg.IFrameWidget   webIFrame       = null;
    dsvg.HtmlWidget     foRepaintTests  = null;

    dsvg.HtmlWidget     btnLog      = null;

    //This group is for when we are testing within HTML
    Element divInner    = null;
    Element timeElement = null;
    Element divHeader   = null;


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Misc required constants, objects and such...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    const String APP_CANVAS_ELEMENT_ID  = '#dartsquidAppCanvas';
    const String APP_NAME               = 'mySampleApplication';

    //Use this to initialize our "menu buttons" at top of page
    final List<ButtonDef> ButtonDefs = const [
        const ButtonDef('Widget1',          'myWidget1',            80  , true ),
        const ButtonDef('Widget2',          'myWidget2',            80  , true ),
        const ButtonDef('Widget3',          'myWidget3',            80  , true ),
        const ButtonDef('Features & Notes', 'WidgetNotesWebPage',   140 , true ),
        const ButtonDef('README (via XHR)', 'EmbedWebPage',         160 , false),
        const ButtonDef('FO Repaint Tests', 'FORepaintTestsPage',   140 , true ),
        const ButtonDef('IFrameWidget',     'EmbedWebPageInIFrame', 120 , false)
    ];


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: VARIOUS TESTING METHODS CALLED BY main()
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    //TODO int setTimeout(TimeoutHandler handler, int timeout);

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
        testBounds.L = 10.0;
        testBounds.R = 110.0;
        testBounds.T = 20.0;
        testBounds.B = 170.0;

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

        testAlignSpec.dimensionValue = 123.45;
        testAlignSpec.resetAlignSpec();

        dsvg.logToConsole([
            testAlignSpec,
            "testAlignSpec.dimensionValue: ${testStringCondition( testAlignSpec.dimensionValue.toString(), '0.0' )}",
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
        testAlign['T'].dimensionValue = 112.12;

        dsvg.logToConsole([
            testAlign,
            "testAlign.T:      ${testAlign.T}",
            "testAlign['T'].dimensionValue:      ${testStringCondition( testAlign['T'].dimensionValue.toString(),       '112.12' )}",
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
    void testWidgetOnShowEventCallback(Dynamic eventObj) {
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
        timeElement = document.query('#time');

        void myHandler(Element handledElement) {
            handledElement.innerHTML = "Current time: ${new Date.now()}";
        }

        void junkHandler(var handledElement) {
            handledElement.innerHTML = "SET VIA junkHandler";
        }


        var a = {'class':'BoldRed', 'style': 'border:2px solid black; background-color:yellow; text-align:center;'};
        divHeader.innerHTML = "DART RUN STARTED &mdash; see console for tracing information.";
        dsvg.setElementAttributes(divHeader, a);

        timeElement.innerHTML = "Preparing time loop... ";
        window.setInterval(() {myHandler(timeElement);}, 1000);
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Create various widgets
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Test creating a widget on the app canvas.
    Align it to the bottom-right corner of viewport.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createTestWidget1() {
        //create a widget on the canvas
        testWidget1  = new dsvg.Widget('myWidget1', globalApplicationObject);
        //set bounds via the "long way" (one at a time) vs. SetBounds()
        testWidget1.x        = 100.0;
        testWidget1.y        = 100;
        testWidget1.width    = 200;
        testWidget1.height   = 100;
        testWidget1.align.R.dimension = dsvg.eSides.R;
        testWidget1.align.B.dimension = dsvg.eSides.B;

        //testWidget.onAlign = btnMenuOnAlign;

        //TODO: Next line works as desired, but DART EDITOR (through build 11702 so far) throws warning: "expression does not yield a value"
        testWidget1.on.show = testWidgetOnShowEventCallback(testWidget1);
        testWidget1.show();

        //test incorrect callback signature traps...
        //testWidget.on.mouseDown = IncorrectMouseEventSignatureTest;

        testWidget1.on.mouseDown = btnTestOnMouseDown;
        //testWidget.on.mouseDown = null;
        testWidget1.isMovable.x = true;
        testWidget1.isMovable.y = true;
        testWidget1.isSizable.x = true;
        testWidget1.isSizable.y = true;
        testWidget1.anchors = dsvg.eSides.R;

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
        testWidget2.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base', 'TanFill');
        testWidget2.setBounds(100,100,400,400);
        testWidget2.isMovable.x = true;
        testWidget2.align.R.objToAlignTo = testWidget1;
        testWidget2.align.R.dimension = dsvg.eSides.L;
        testWidget2.show();

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
        testWidget3.setBounds(100,100,100,100);
        testWidget3.show();

        //test "costly change" inside begin/endUpdate block...
        testWidget3.beginUpdate();
        testWidget3.setBounds(120,120,110,150);
        testWidget3.align.CX.dimension = dsvg.eSides.R;
        testWidget3.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base', 'RedFill');
        testWidget3.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter', 'RaisedBorder');      //Test "outset" ==> "raised" (virtual border style)
        testWidget3.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter', 'UseVirtualBorder');  //Test "outset" ==> "raised" (virtual border style)
        testWidget3.isMovable.x = true;
        testWidget3.isMovable.y = true;
        testWidget3.isSizable.x = true;
        testWidget3.isSizable.y = true;
        testWidget3.sizeRules.maxWidth = 200;
        testWidget3.sizeRules.minWidth = 50;
        testWidget3.sizeRules.maxHeight = 200;
        testWidget3.sizeRules.minHeight = 50;
        testWidget3.posRules.minX = (dsvg.MouseNotifyEventObject objInitiator) {return -300; };
        testWidget3.posRules.maxX = (dsvg.MouseNotifyEventObject objInitiator) {return 100; };
        testWidget3.posRules.minY = (dsvg.MouseNotifyEventObject objInitiator) {return -100; };
        testWidget3.posRules.maxY = (dsvg.MouseNotifyEventObject objInitiator) {return 420; };
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
    TODO: DOCUMENT
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createMenuButtonsContainer() {
        menuButtonsContainer = new dsvg.Widget('MenuButtonsContainer', globalApplicationObject);
        menuButtonsContainer.height = 50;
        menuButtonsContainer.align.T.dimension = dsvg.eSides.T;
        menuButtonsContainer.align.R.dimension = dsvg.eSides.R;
        menuButtonsContainer.align.L.dimension = dsvg.eSides.L;
        menuButtonsContainer.sizeRules.minWidth = 500;

        //Style it
        menuButtonsContainer.classesCSS.setClassSelectorsForTargetObjectName('Widget_Base',         'MenuButtonsContainer');
        menuButtonsContainer.classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame',        'MenuButtonsContainerFrame');
        menuButtonsContainer.classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderOuter',  'OutsetBorder');
        menuButtonsContainer.classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderInner',  'GrooveBorder');
        menuButtonsContainer.show();

        dsvg.logToConsole([
            'LINE1',
            'createMenuButtonsContainer method finished; object created:',
            menuButtonsContainer
        ]);
    }


    void createMenuButtons() {
        dsvg.HtmlWidget tempMenuButton = null;
        menuButtons =  new List<dsvg.HtmlWidget>();

        num currentLeft = 10;
        ButtonDefs.forEach( (buttonInList) {
            tempMenuButton = new dsvg.HtmlWidget('MenuButton${buttonInList.tag}', globalApplicationObject, menuButtonsContainer);
            tempMenuButton.setBounds((currentLeft), 10, buttonInList.width, 35);
            currentLeft = currentLeft + buttonInList.width;
            tempMenuButton.align.CY.dimension = dsvg.eSides.CY;


            //create a "button" on the canvas; the click event is what makes it behave like a button.
            tempMenuButton.classesCSS.setClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base,${(buttonInList.isActive ? "LightGreenFill" : "LightPinkFill")}');
            tempMenuButton.classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame');
            tempMenuButton.classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderOuter','ButtonWidget_BorderOuter, UseVirtualBorder');
            tempMenuButton.classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderInner','ButtonWidget_BorderInner');
            tempMenuButton.caption = buttonInList.caption;
            tempMenuButton.tag = buttonInList.tag;

            tempMenuButton.on.mouseClick = menuButtonsClickHandler;

            //add to our container list and show it
            menuButtons.add(tempMenuButton);
            tempMenuButton.show();

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

        //TODO: make generic -- loop through App-object instead.
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
        btnLog.setBounds(20,50,225,35);
        btnLog.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base');
        btnLog.classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame');
        btnLog.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','ButtonWidget_BorderOuter, UseVirtualBorder');
        btnLog.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','ButtonWidget_BorderInner');
        btnLog.on.mouseClick = btnLogAppWidgetsDataToConsoleClick;
        btnLog.caption = "Log App's Widgets' Info Now";
        btnLog.show();

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
        btnLog  = new dsvg.HtmlWidget('myTextButton', globalApplicationObject);
        btnLog.setBounds(20,70,95,35);
        btnLog.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base');
        btnLog.classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame');
        btnLog.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','ButtonWidget_BorderOuter, UseVirtualBorder');
        btnLog.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','ButtonWidget_BorderInner');
        btnLog.on.mouseClick = btnDeleteWidgetMouseClick;
        btnLog.caption = 'DELETE-1-ABCDEF-GHI-JKL-MNO-PQR-STUVWXY-Z';  //here to test clipping of overflow
        btnLog.show();

        dsvg.logToConsole([
            'LINE1',
            'createDeleteWidgetButton method finished; object created:',
            btnLog
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
        if (globalApplicationObject.isRunningOnServer) {
            getWebPageContent(String url, onSuccess(HttpRequest req)) {
              // call the web server asynchronously
              var request = new HttpRequest.get(url, onSuccess);
            }

            //load the raw response text from the server into our foreign object
            onSuccess(HttpRequest req) {
               embeddedWebPage.embeddedFO.htmlDiv.innerHTML= req.responseText;
            }

            getWebPageContent("dart_squid_SVG_UI_Widgets_Documentation.html", onSuccess);
        }

        dsvg.logToConsole([
            'LINE1',
            'createWebPageInWidget method finished (isRunningOnServer=${globalApplicationObject.isRunningOnServer}); object created:',
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
        notesPage.setBounds(100,85,650,550);
        notesPage.isMovable.x = true;
        notesPage.isMovable.y = true;
        notesPage.isSizable.x = false;
        notesPage.isSizable.y = true;
        notesPage.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'Notes_Base');
        notesPage.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','RaisedOutsetComponent, UseVirtualBorder');
        notesPage.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','LoweredInsetComponent, UseVirtualBorder');
        notesPage.embeddedFO.scrollOverflow = true;

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
            Note: only Google Chrome browser (Dartium for native Dart version) works <b>reasonably</b> well, and as of Chrome V17/V18/V19/V20/V21/V22/... these issues persist:<br />
            <ul>
                <li>Chrome: Webkit (presumably) has MAJOR ISSUES with repaint-rect calculations and control-updates with regards to ForeignObjects (FO)
                when the page-zoom-factor is other than 100%!
                Such FO issues have persisted since v17 (repaints not triggered);</li>
                <li>Chrome: Scrollbar(s) on ForeignObjects get hosed if zoom-factor is not 100% &mdash; Chrome thinks the scrollbar is still at
                the position it would be at 100% zoom. Likewise content in non-100%-zoom-regions is not properly refreshed, as Webkit is only repainting some
                arbitrary portion of the area instead.</li>
                <li>Chrome: Cursor-type not honored by browser after mousedown and mousemove begins;</li>
                <li>Chrome: re-use of external SVG-file definitions (of filters,etc) by url(file#def-name) reference does not work (FF gets this right).</li>
                <li><strong>FireFox</strong> (JS version): <b>issues galore!</b>
                <br />No resize (of browser-window) event is ever triggered, thus relative-position (to browser-dimensions) hosed.
                <br />In general, getting the browser-dimensions in FF is nearly impossible.
                <br />Borders not drawing on Widgets (probably position-calc related). Thus, no way to style, move, resize Widgets.
                <br />And much more...</li>
            </ul>
            <br />
            </div>
            </div>
        ''';
        notesPage.show();

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

        //findSelectBox = document.query("#comboColor");  //works
        colorSelectElement      = foRepaintTests.embeddedFO.htmlDiv.$dom_querySelector("#comboColor");    //works - is this "faster" approach than using "query" (i.e., limits search to div)?
        frameWidthSelectElement = foRepaintTests.embeddedFO.htmlDiv.$dom_querySelector("#comboFrameWidth");

        //Gets the "value" portion of first-selected option in select-element. (e.g., "RedColor")
        selectedColorValue      = colorSelectElement.item(colorSelectElement.selectedIndex).value;
        selectFrameWidthValue   = frameWidthSelectElement.item(frameWidthSelectElement.selectedIndex).value;

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
        foRepaintTests.tag = 'FOR1';
        foRepaintTests.setBounds(300,150,800,500);
        foRepaintTests.isMovable.x = true;
        foRepaintTests.isMovable.y = true;
        foRepaintTests.isSizable.x = true;
        foRepaintTests.isSizable.y = true;
        foRepaintTests.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base');
        foRepaintTests.classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame');
        foRepaintTests.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','foRepaintTestsOuterBorder');
        foRepaintTests.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','foRepaintTestsInnerBorder');
        foRepaintTests.embeddedFO.scrollOverflow = true;
        foRepaintTests.caption = '''
            <div class="FORepaintTest" style="background-color: #fff8dc; " >
            <span class="BoldRed" >SVG Components FO Repaint Tests</span>
            <p>This is a HtmlWidget that uses <b>SVG ForeignObject (FO)</b> to embed HTML content.</p>
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
                Submit Button Test (does nothing): <input id="inputSubmitButton" type="button" value="submittest1"  name="submit" alt="Submit Test (inactive)" />
            </p>
            <p>A regression in Webkit/Chrome was introduced (it seems) as of Chrome v17 where control repaints and/or
            content repaints within a FO inside an SVG are very, very buggy if browser zoom-level is other than 100%
            (Chrome/Dartium v22,23 seem OK at 100% zoom).  But, for non-100%-page-zoom situations, both the Chrome(JS)
            and Dartium(Dart) versions incorrectly update FO content and controls (as of v18,19,20, 21, 22, 23...).
            </p>
            <p>The controls will fail to reflect user changes and/or display garbled mess unless a <b>user-triggered</b> browser repaint
            occurs via: user scrolling the FO controls off the page and back, changing the browser zoom-factor (CTRL+/-), etc.
            Even after a user-triggered repaint, the bounding-box of the repainted-region will be only that of the 100%-zoom-factor size, thus
            leaving garbage elsewhere unrefreshed, scrollbars disfunctional (since the browser "forgets" where they are), etc.<br />
            The (webkit) issue has been reported AGES ago and remains outstanding.<br /><br />
            FO was used for Text because <span class="BoldRed" >Line-wraps</span> occur by default and wrap as desired and expected by any typical HTML output.
            </p>
            </div>
        ''';

        dsvg.logToConsole([
            'LINE1',
            'createFoRepaintTestWidget method finished; object created:',
            foRepaintTests
        ]);

        foRepaintTests.show();

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        WIRE UP AN EVENT-HANDLER that will fire when our embedded HTML's color and frame-wdith
        selection dropdown values change.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        SelectElement  colorSelectElement = null;
        SelectElement  frameWidthSelectElement = null;

        //colorSelectElement = document.query("#comboColor");  //works
        colorSelectElement      = foRepaintTests.embeddedFO.htmlDiv.$dom_querySelector("#comboColor");    //works - is this "faster" approach than using "query" (i.e., limits search to div)?
        frameWidthSelectElement = foRepaintTests.embeddedFO.htmlDiv.$dom_querySelector("#comboFrameWidth");

        //assign event-handler to that select element
        colorSelectElement.on.change.add( (event) => foRepaint_HtmlContolsChangeHandler(event) );
        frameWidthSelectElement.on.change.add( (event) => foRepaint_HtmlContolsChangeHandler(event) );
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
        webIFrame.setBounds(10,60,700,600);

        //Some tests that make use of the setURL method...
        webIFrame.setURL('http://www.intersoftdevelopment.com');
        //webIFrame.setURL('.');            //display local file directory tree from where we run
        //webIFrame.setURL('README.html');  //display local file in that directory

        webIFrame.isMovable.x = true;
        webIFrame.isMovable.y = true;
        webIFrame.isSizable.x = true;
        webIFrame.isSizable.y = true;

        dsvg.logToConsole([
            'LINE1',
            'createWebPageIFrameWidget method finished; object created:',
            webIFrame
        ]);
    }


    /*
    ███████████████████████████████████████████████████████████████████████████████████████████
    APPLICATION EXECUTION STARTS HERE UPON APPLICATION-READY CALLBACK...
    (this apparent over-complexity only exists so we can have "align to window-edges"
    functionality available for our widgets)

    FLOW NOTES:
        main() will create the Widget's Application-object instance.
        The application object constructor takes a callback to transfer execution when it is
        "ready" (due to Dart not completing pending Future(s) prior to main() finishing
        otherwise).  The application object transfers back here to our runApplication(),
        where all the real work is done.

    **the ONLY code that can run outside of runApplication is stuff that is NOT DEPENDENT on
    our Widgets/application objects.

    ***one potential (slim chance?) issue would be any application resize events that fire
    during the processing of the method within runApplication, since presumably the future(s)
    in the applcation object would cause unpredictable widget-alignments to occur.
    ███████████████████████████████████████████████████████████████████████████████████████████
    */
    void runApplication() {

        dsvg.logToConsole([
            'LINE1',
            'runApplication() Entry (via Application object onReady callback)...'
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


        createWebPageIFrameWidget();

        //Due to BUG with ElementImplementation InnerHtml (Dart issue# 2977), these currently do not work in standalone SVG document.
        if (!globalApplicationObject.isStandaloneSVG) {
            //createDeleteWidgetButton();

            createLogAppWidgetsDataToConsoleButton();

            createNotesWidget();

            createWebPageInWidget();

            createFoRepaintTestWidget();
        }

        //Note: these buttons refer to previously-created objects; be careful moving this
        createMenuButtonsContainer();
        createMenuButtons();

    }  //runApplication


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    MAIN() EXECUTION STARTS HERE
    Anything from here forward in main() must be safe to execute outside of runApplication

    First, CREATE GLOBALLY-AVAILABLE INSTANCE OF OUR APPLICATION OBJECT
    Parameters are app-name and the SVG Element we will use for our "Canvas", and finally
    the callback (to runApplication) where our app really begins
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    globalApplicationObject = new dsvg.Application(APP_NAME, document.query(APP_CANVAS_ELEMENT_ID), runApplication );

    globalApplicationObject.tracingEnabled = true; //change to false if ALL tracing is to be off.

    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: HTML-DOC TESTING...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    if (!globalApplicationObject.isStandaloneSVG) {
        createHTMLTestObjects();
    }



}  //main

