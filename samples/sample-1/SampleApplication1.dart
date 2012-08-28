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
Furthermore, we prefix all our library references within this test applicatin to avoid
any potential namespace collisions.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
#import("../../lib/dart_squid.dart", prefix:'Tsvg');



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
    Tsvg.Application    globalApplicationObject = null;

    Tsvg.Widget         testWidget      = null;
    Tsvg.Widget         testWidget2     = null;
    Tsvg.Widget         testWidget3     = null;

    Tsvg.Widget         menuButtonsContainer    = null;
    List<Tsvg.TextWidget> menuButtons   = null;

    Tsvg.Button         testButton      = null;
    Tsvg.TextWidget     embeddedWebPage = null;
    Tsvg.TextWidget     notesPage       = null;
    Tsvg.iFrameWidget   webIFrame       = null;
    Tsvg.TextWidget     foRepaintTests  = null;

    Tsvg.TextWidget     textButton      = null;

    //This group is for when we are testing within HTML
    Element divInner    = null;
    Element timeElement = null;
    Element divHeader   = null;


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Misc required constants, objects and such...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    final String applicationCanvasElementID = '#TsvgAppCanvas';
    final String applicationName            = 'mySampleApplication';

    //Use this to initialize our "menu buttons" at top of page
    final List<ButtonDef> ButtonDefs = const [
        const ButtonDef('Widget1',          'myWidget',             80  , true ),
        const ButtonDef('Widget2',          'myWidget2',            80  , true ),
        const ButtonDef('Widget3',          'myWidget3',            80  , true ),
        const ButtonDef('Notes',            'WidgetNotesWebPage',   60  , true ),
        const ButtonDef('README (via XHR)', 'EmbedWebPage',         160 , false),
        const ButtonDef('FO Repaint Tests', 'FORepaintTestsPage',   140 , false),
        const ButtonDef('iFrameWidget',     'EmbedWebPageInIFrame', 120 , false)
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


    void testEnumerations() {
        Tsvg.logToConsole([
            '',
            'LINE1',
            'Various enumeration tests...',
            'LINE2',
            "Tsvg.eSides.Left: ${Tsvg.eSides.Left} with Name of: ${testStringCondition( Tsvg.eSides.Names[Tsvg.eSides.Left.toString()], 'L' )}",
            "Tsvg.eSides.Names: ${Tsvg.eSides.Names} (EXPECTED: list of all names)",
            "eSides ADDITIVE test: ${testStringCondition( Tsvg.eSides.Names[(Tsvg.eSides.Left + Tsvg.eSides.Left).toString()], 'CX' )}",
            'LINE3',
            "Tsvg.eWidgetPart.Names=${Tsvg.eWidgetPart.Names}",
            'LINE1'
        ]);
    }



    void testWidgetMetrics() {
        Tsvg.logToConsole([
            '',
            'LINE1',
            'Tsvg.WidgetMetrics tests',
            'LINE2',
            'Instantiating and setting Margin.R value...'
        ]);

        var testWidgetMetrics = new Tsvg.WidgetMetrics();
        testWidgetMetrics.Margin.R = 222.2;

        Tsvg.logToConsole([
            testWidgetMetrics,
            "testWidgetMetrics.Margin(aka,WidgetBounds).CX: ${testStringCondition( testWidgetMetrics.Margin.CX.toString(), '111.1' )}",
            'LINE1'
        ]);
    }


    void testObjectBounds() {
        Tsvg.logToConsole([
            '',
            'LINE1',
            'Tsvg.ObjectBounds tests',
            'LINE2',
            'Instantiating...'
        ]);

        Tsvg.ObjectBounds testBounds = new Tsvg.ObjectBounds();
        testBounds.L = 10.0;
        testBounds.R = 110.0;
        testBounds.T = 20.0;
        testBounds.B = 170.0;

        Tsvg.logToConsole([
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
        Tsvg.logToConsole([
            '',
            'LINE1',
            'Tsvg.AlignSpec tests',
            'LINE2',
            'Instantiating...'
        ]);

        Tsvg.AlignSpec testAlignSpec = new Tsvg.AlignSpec();

        testAlignSpec.dimensionValue = 123.45;
        testAlignSpec.resetAlignSpec();

        Tsvg.logToConsole([
            testAlignSpec,
            "testAlignSpec.dimensionValue: ${testStringCondition( testAlignSpec.dimensionValue.toString(), '0.0' )}",
            'LINE3',
            "TODO: a thorough Tsvg.AlignSpec test requires more scenarios.",
            'LINE1'
        ]);

    }


    void testAlign() {
        Tsvg.logToConsole([
            '',
            'LINE1',
            'Tsvg.WidgetAlignment tests',
            'LINE2',
            'Instantiating...'
        ]);

        Tsvg.WidgetAlignment testAlign = new Tsvg.WidgetAlignment();
        testAlign['T'].dimensionValue = 112.12;

        Tsvg.logToConsole([
            testAlign,
            "testAlign.T:      ${testAlign.T}",
            "testAlign['T'].dimensionValue:      ${testStringCondition( testAlign['T'].dimensionValue.toString(),       '112.12' )}",
            'LINE3',
            "TODO: a thorough Tsvg.WidgetAlignment test require creation of a Widget to align to, canvas align test, and much more.",
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
        Tsvg.logToConsole([
            'LINE3',
            "${eventObj.instanceName} onShow EVENT fired",
            'LINE3'
        ]);
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    EXAMPLE CALLBACK F(X) of MouseNotifyEventObject Type..
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void btnDeleteWidgetMouseClick(Tsvg.MouseNotifyEventObject eventObj) {
        Tsvg.TextWidget widget = eventObj.sender;

        widget.caption = 'Deleted 1';

        Tsvg.logToConsole([
            'LINE2',
            "${widget.instanceName} btnTextMouseClick EVENT fired at coordinates (${eventObj.eventInfo.clientX},${eventObj.eventInfo.clientY})",
            'LINE3',
            "Application Widgets List:"
        ]);

        globalApplicationObject.widgetsList.forEach( (widgetListItem) {
            print("    ${widgetListItem.instanceName}");
        });


        if (testWidget != null) {
            Tsvg.logToConsole([
                'LINE4',
                '${testWidget.instanceName} Destroy() being executed; next btn-click should show list less this InstanceName'
            ]);

            testWidget.destroy();
            testWidget = null;
        }

        Tsvg.logToConsole([
            'LINE2'
        ]);
    }


    void btnMenuOnMouseDown(Tsvg.MouseNotifyEventObject eventObj) {
        Tsvg.TextWidget widget = eventObj.sender;

        Tsvg.logToConsole([
            'LINE2',
            "${widget.instanceName} btnMenuOnMouseDown EVENT fired at coordinates (${eventObj.eventInfo.clientX},${eventObj.eventInfo.clientY})",
            'LINE3',
            "Further info...:"
        ]);
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    This method
    TODO: DOCUMENT
    TODO: EventsProcessor needs extended to do type checking yet.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void menuButtonsClickHandler(Tsvg.MouseNotifyEventObject eventObj) {
        var sender = eventObj.sender;
        Tsvg.Widget _targetWidget = null;

        int indexTest = Tsvg.indexOfInstanceName(globalApplicationObject.widgetsList, eventObj.sender.tag);

        if (indexTest > -1) {
            _targetWidget    = globalApplicationObject.getWidgetByIndex(indexTest);

            print("${sender.instanceName}  Click fired at coordinates (${eventObj.eventInfo.clientX},${eventObj.eventInfo.clientY}) by Widget with tag=${eventObj.sender.tag} to show/hide Widget with InstanceName:tag = ${_targetWidget.instanceName}:${_targetWidget.tag}");

            _targetWidget.toggleVisibility();

            //update the look of our button to reflect whether it's "target widget" is showing or not.
            sender.classesCSS.setClassSelectorsForTargetObjectName('Widget_Base',       'WidgetButton_Base,${(_targetWidget.visible ? "LightGreenFill" : "LightPinkFill")}');
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
    void IncorrectMouseEventSignatureTest(Tsvg.NotifyEventObject eventObj) {
        Tsvg.Widget widget = eventObj.sender;

        Tsvg.logToConsole([
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
        Tsvg.setElementAttributes(divHeader, a);

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
        testWidget  = new Tsvg.Widget('myWidget', globalApplicationObject);
        //set bounds via the "long way" (one at a time) vs. SetBounds()
        testWidget.x        = 100.0;
        testWidget.y        = 100;
        testWidget.width    = 200;
        testWidget.height   = 100;
        testWidget.align.R.dimension = Tsvg.eSides.R;
        testWidget.align.B.dimension = Tsvg.eSides.B;

        //testWidget.onAlign = btnMenuOnAlign;
        testWidget.on.show = testWidgetOnShowEventCallback(testWidget); //TODO: Works as desired, but DART EDITOR (0.1.0.201207231114, Build 9822) throws warning: "expression does not yield a value"
        testWidget.show();

        //test incorrect callback signature traps...
        //testWidget.on.mouseDown = IncorrectMouseEventSignatureTest;

        testWidget.on.mouseDown = btnMenuOnMouseDown;
        //testWidget.on.mouseDown = null;
        testWidget.isMovable.x = true;
        testWidget.isMovable.y = true;
        testWidget.isSizable.x = true;
        testWidget.isSizable.y = true;
        testWidget.anchors = Tsvg.eSides.R;

        Tsvg.logToConsole([
            'LINE1',
            'createTestWidget1 method finished; Widget created with instanceName: ${testWidget.instanceName}',
            'LINE1'
        ]);
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Test creating a widget on the app canvas.
    Align its right-side to the left side of another widget.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createTestWidget2() {
        testWidget2 = new Tsvg.Widget('myWidget2', globalApplicationObject);
        testWidget2.setBounds(100,100,400,400);
        testWidget2.isMovable.x = true;
        testWidget2.align.R.objToAlignTo = testWidget;
        testWidget2.align.R.dimension = Tsvg.eSides.L;
        testWidget2.show();

        Tsvg.logToConsole([
            'LINE1',
            'createTestWidget2 method finished; Widget created with instanceName: ${testWidget2.instanceName}',
            'LINE1'
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

        //setting a constraint "= testConstraint" would be equiv to setting it inline to: "= num (Tsvg.MouseNotifyEventObject objInitiator) {return -100; }"
        num testConstraint() {
            return -100.0;
        }

        testWidget3 = new Tsvg.Widget('myWidget3', globalApplicationObject, testWidget2);
        testWidget3.setBounds(100,100,100,100);
        testWidget3.show();

        //test "costly change"...
        testWidget3.beginUpdate();
        testWidget3.setBounds(120,120,110,150);
        testWidget3.align.CX.dimension = Tsvg.eSides.R;
        testWidget3.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base', 'RedFill');
        testWidget3.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter', 'RaisedBorder');      //Test "outset" ==> "raised" (virtual border style)
        testWidget3.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter', 'UseVirtualBorder');  //Test "outset" ==> "raised" (virtual border style)
        //print('testWidget3.classesCSS[Widget_BorderOuter]' + testWidget3.classesCSS['Widget_BorderOuter']);
        testWidget3.isMovable.x = true;
        testWidget3.isMovable.y = true;
        testWidget3.isSizable.x = true;
        testWidget3.isSizable.y = true;
        testWidget3.sizeRules.maxWidth = 200;
        testWidget3.sizeRules.minWidth = 50;
        testWidget3.sizeRules.maxHeight = 200;
        testWidget3.sizeRules.minHeight = 50;
        testWidget3.posRules.minX = (Tsvg.MouseNotifyEventObject objInitiator) {return -300; };
        testWidget3.posRules.maxX = (Tsvg.MouseNotifyEventObject objInitiator) {return 100; };
        testWidget3.posRules.minY = (Tsvg.MouseNotifyEventObject objInitiator) {return -100; };
        testWidget3.posRules.maxY = (Tsvg.MouseNotifyEventObject objInitiator) {return 420; };
//        testWidget3.PosRules.MinX = (Tsvg.MouseNotifyEventObject objInitiator) {return textButton.x; };  //TODO: Test more substantial ideas..
        testWidget3.endUpdate();

//        testWidget3.Anchors = Tsvg.eSides.R;
//        testWidget3.Align.L.Dimension = Tsvg.eSides.L;

        Tsvg.logToConsole([
            'LINE1',
            'createTestWidget3 method finished; Widget created with instanceName: ${testWidget3.instanceName}',
            'LINE1'
        ]);
    }




    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    TODO: DOCUMENT
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createMenuButtonsContainer() {
        menuButtonsContainer = new Tsvg.Widget('MenuButtonsContainer', globalApplicationObject);
        menuButtonsContainer.height = 50;
        menuButtonsContainer.align.T.dimension = Tsvg.eSides.T;
        menuButtonsContainer.align.R.dimension = Tsvg.eSides.R;
        menuButtonsContainer.align.L.dimension = Tsvg.eSides.L;
        menuButtonsContainer.sizeRules.minWidth = 500;

        //Style it
        menuButtonsContainer.classesCSS.setClassSelectorsForTargetObjectName('Widget_Base', 'MenuButtonsContainer');
        menuButtonsContainer.classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame', 'MenuButtonsContainerFrame');
        menuButtonsContainer.classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderOuter', 'OutsetBorder');
        menuButtonsContainer.classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderInner', 'GrooveBorder');
        menuButtonsContainer.show();

        Tsvg.logToConsole([
            'LINE1',
            'createMenuButtonsContainer method finished; Widget created with instanceName: ${menuButtonsContainer.instanceName}',
            'LINE1'
        ]);

    }


    void createMenuButtons() {
        Tsvg.TextWidget tempMenuButton = null;
        menuButtons =  new List<Tsvg.TextWidget>();

        num currentLeft = 10;
        ButtonDefs.forEach( (buttonInList) {
            tempMenuButton = new Tsvg.TextWidget('MenuButton${buttonInList.tag}', globalApplicationObject, menuButtonsContainer);
            tempMenuButton.setBounds((currentLeft), 10, buttonInList.width, 35);
            currentLeft = currentLeft + buttonInList.width;
            tempMenuButton.align.CY.dimension = Tsvg.eSides.CY;


            //create a "button" on the canvas; the click event is what makes it behave like a button.
            tempMenuButton.classesCSS.setClassSelectorsForTargetObjectName('Widget_Base',       'WidgetButton_Base,${(buttonInList.isActive ? "LightGreenFill" : "LightPinkFill")}');
            tempMenuButton.classesCSS.setClassSelectorsForTargetObjectName('Widget_Frame',      'WidgetButton_Frame');
            tempMenuButton.classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderOuter','WidgetButton_BorderOuter, UseVirtualBorder');
            tempMenuButton.classesCSS.setClassSelectorsForTargetObjectName('Widget_BorderInner','WidgetButton_BorderInner');
            tempMenuButton.caption = buttonInList.caption;
            tempMenuButton.tag = buttonInList.tag;

            tempMenuButton.on.mouseClick = menuButtonsClickHandler;

            //add to our container list and show it
            menuButtons.add(tempMenuButton);
            tempMenuButton.show();

        }); //...forEach

        Tsvg.logToConsole([
            'LINE1',
            'createMenuButtons method has finished; all buttons have been created.',
            'LINE1'
        ]);

    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Textwidget being used as a "button" with a click event.
    This particular one tests truncation of overflow text and also uses callback that
    deletes another widget.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createDeleteWidgetButton() {
        //create a "button" on the canvas; the click event is what makes it behave like a button.
        textButton  = new Tsvg.TextWidget('myTextButton', globalApplicationObject);
        textButton.setBounds(20,70,95,35);
        textButton.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'WidgetButton_Base');
        textButton.classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'WidgetButton_Frame');
        textButton.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','WidgetButton_BorderOuter, UseVirtualBorder');
        textButton.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','WidgetButton_BorderInner');
        textButton.on.mouseClick = btnDeleteWidgetMouseClick;
        textButton.caption = 'DELETE-1-ABCDEF-GHI-JKL-MNO-PQR-STUVWXY-Z';  //here to test clipping of overflow
        textButton.show();

        Tsvg.logToConsole([
            'LINE1',
            'createDeleteWidgetButton method finished; TextWidget created with instanceName: ${textButton.instanceName}',
            'LINE1'
        ]);
    } //CreateTextButton1



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Textwidget with foreign object...
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createWebPageInWidget() {
        embeddedWebPage = new Tsvg.TextWidget('EmbedWebPage', globalApplicationObject);
        embeddedWebPage.setBounds(50,50,500,500);
        embeddedWebPage.embeddedFO.scrollOverflow = true;
        embeddedWebPage.caption = '''
            <div>
                <em><span itemprop="description">PLACEHOLDER HTML to be overwritten by XHR action. This text shows if you
                are not accessing this SVG Widgets application over HTTP (e.g., if accessing via file://...).</span></em>
                <br>
                <br>
        ''';

        //ONLY POSSIBLE WHEN ACCESSING VIA HTTP..., otherwise, we will get hit with:
        //HttpRequest cannot load file:///drive:/pathtofile/readme.html. Cross origin requests are only supported for HTTP.
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

            getWebPageContent("README.html", onSuccess);    //TODO: Create example-file and push to samples dir.
        }


        Tsvg.logToConsole([
            'LINE1',
            'createWebPageInWidget method finished; TextWidget created with instanceName: ${embeddedWebPage.instanceName}',
            'LINE1'
        ]);

    }


    void createNotesWidget() {
        notesPage  = new Tsvg.TextWidget('WidgetNotesWebPage', globalApplicationObject);
        notesPage.setBounds(100,75,650,550);
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
            <span class="BoldRed " >SVG Components Features Notes</span><br /><br />
            <div class="SmallText">
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


        Tsvg.logToConsole([
            'LINE1',
            'createNotesWidget method finished; TextWidget created with instanceName: ${notesPage.instanceName}',
            'LINE1'
        ]);

    }



    void createFoRepaintTestWidget() {
        foRepaintTests  = new Tsvg.TextWidget('FORepaintTestsPage', globalApplicationObject, initialCaption:'test');
        foRepaintTests.tag      = 'FOR1';
        foRepaintTests.setBounds(450,100,750,450);
        foRepaintTests.isMovable.x = true;
        foRepaintTests.isMovable.y = true;
        foRepaintTests.isSizable.x = true;
        foRepaintTests.isSizable.y = true;
        foRepaintTests.classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'WidgetButton_Base');
        foRepaintTests.classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'WidgetButton_Frame');
        foRepaintTests.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','DarkBlueBorderComponent');
        foRepaintTests.classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','DarkBlueBorderComponent');
        foRepaintTests.embeddedFO.scrollOverflow = true;
        foRepaintTests.caption = '''
            <div style="background-color: #add8e6;" >
            <span class="BoldRed" >SVG Components FO Repaint Tests</span>
            <p>This is a TextWidget that uses <b>SVG ForeignObject (FO)</b> to embed HTML content.</p>
            <p>HTML Controls test (edit, select, radio) below.</p>
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
            <p>Choose your Ship-to-Country:
            <select name="country" id="dropdownStates">
                <option value="US">United States</option>
                <option value="CA">Canada</option>
                <option value="MX">Mexico</option>
                <option value="GB">United Kingdom</option>
                <option value="ZZ">Other</option>
            </select><br />
            <input type="radio" name="sex" value="Male"/> Male<br /><input type="radio" name="sex" value="Female" /> Female<br /> 
            <input type="value" name="qty" value="1" /> 
            <input type="button" value="test"  name="submit" alt="Review Selection and Proceed With Order" /> 
            </p>
            </div>
        ''';


        Tsvg.logToConsole([
            'LINE1',
            'createFoRepaintTestWidget method finished; TextWidget created with instanceName: ${foRepaintTests.instanceName}',
            'LINE1'
        ]);

    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Textwidget with foreign object...
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void createWebPageIFrameWidget() {
        webIFrame  = new Tsvg.iFrameWidget('EmbedWebPageInIFrame', globalApplicationObject);
        webIFrame.setBounds(10,60,700,600);

        //Some tests that make use of the setURL method...
        webIFrame.setURL('http://www.intersoftdevelopment.com');
        //webIFrame.setURL('.');            //display local file directory tree from where we run
        //webIFrame.setURL('README.html');  //display local file in that directory

        webIFrame.isMovable.x = true;
        webIFrame.isMovable.y = true;
        webIFrame.isSizable.x = true;
        webIFrame.isSizable.y = true;

        Tsvg.logToConsole([
            'LINE1',
            'createWebPageIFrameWidget method finished; iFrameWidget created with instanceName: ${webIFrame.instanceName}',
            'LINE1'
        ]);
    }


    /*
    ███████████████████████████████████████████████████████████████████████████████████████████
    MAIN APPLICATION EXECUTION STARTS HERE...
    (this apparent over-complexity only exists so we can have "align to window-edges"
    functionality available for our widgets)

    FLOW NOTES:
        main() will create the Widget's Application-object instance.
        The application object constructor takes a callback to transfer execution when it is
        "ready" (due to Dart not completing pending Future(s) prior to main() finishing
        otherwise).  The application object transfers back here to our RunApplication(),
        where all the real work is done.

    **the ONLY code that can run outside of RunApplication is stuff that is NOT DEPENDENT on
    our Widgets/application objects.

    ***one potential (slim chance?) issue would be any application resize events that fire
    during the processing of the method within RunApplication, since presumably the future(s)
    in the applcation object would cause unpredictable widget-alignments to occur.
    ███████████████████████████████████████████████████████████████████████████████████████████
    */
    void runApplication() {

        Tsvg.logToConsole([
            'LINE1',
            'Main() Entry...',
            'Running Application "$applicationName" within ${document.window.location.href} and SVG application canvas element ID=$applicationCanvasElementID',
            'LINE2',
            'The following bounds values should appear realistic for current browser-window size...',
            '    Application.CanvasBounds.Width: ${globalApplicationObject.canvasBounds.Width}',
            '    Application.CanvasBounds.Height: ${globalApplicationObject.canvasBounds.Height}',
            '',
            'Application background styled with CSS Class(es): ${globalApplicationObject.classesCSS}',
            'LINE1'
        ]);


        //Misc non-visual test setups
        testEnumerations();
        testWidgetMetrics();
        testObjectBounds();
        testAlignSpec();
        testAlign();

        //Some basic widget-creation tests
        createTestWidget1();
        createTestWidget2();
        createTestWidget3();


        createWebPageIFrameWidget();    //OK

        //Due to BUG with ElementImplementation InnerHtml (Dart issue# 2977), these currently do not work in standalone SVG document.
        if (!globalApplicationObject.isStandaloneSVG) {
            //createDeleteWidgetButton();

            createNotesWidget();

            createWebPageInWidget();

            createFoRepaintTestWidget();
        }

        //Note: these buttons refer to previously-created objects; be careful moving this
        createMenuButtonsContainer();
        createMenuButtons();
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Anything from here forward in main() must be safe to execute outside of RunApplication

    First, CREATE GLOBALLY-AVAILABLE INSTANCE OF OUR APPLICATION OBJECT
    Parameters are app-name and the SVG Element we will use for our "Canvas", and finally
    the callback (to RunApplication) where our app really begins
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    globalApplicationObject = new Tsvg.Application(applicationName, document.query(applicationCanvasElementID), runApplication );

    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: HTML-DOC TESTING...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    if (!globalApplicationObject.isStandaloneSVG) {
        createHTMLTestObjects();
    }



}  //main

