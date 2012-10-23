/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

import 'dart:html';

/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
NOTE: For our own libraries, must specify .dart extension.
Consider prefixing our library references within this application to avoid
any potential namespace collisions.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
import '../lib/dart_squid.dart' as dsvg;


//place embedded app-specific class definitions here (if not in external file)
class ButtonDef {
    final String      caption   = "test button";
    //...
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

    dsvg.Widget         testWidget      = null;


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Misc required constants, objects and such...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    const String APP_CANVAS_ELEMENT_ID  = '#dartsquidAppCanvas';
    const String APP_NAME               = 'myPrototypicalApplication';


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: various example methods called from within main()
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    //Misc routine...
    String testStringCondition(String value, String expectedValue) {
        String  PassFail = ((value.toString() == expectedValue) ? "OK" : "FAIL");
        return '${value} (EXPECTED: ${expectedValue}) [${PassFail}]';
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    EXAMPLE CALLBACK F(X) of NotifyEvent Type..
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void testWidgetOnShowEventCallback(Dynamic eventObj) {
        dsvg.logToConsole([
            'LINE3',
            "${eventObj.instanceName} onShow EVENT fired",
            'LINE3'
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
    in the application object would cause unpredictable widget-alignments to occur.
    ███████████████████████████████████████████████████████████████████████████████████████████
    */
    void runApplication() {

        dsvg.logToConsole([
            'LINE1',
            'Running Application "$APP_NAME" within ${document.window.location.href} and SVG application canvas element ID=$APP_CANVAS_ELEMENT_ID',
            'LINE1'
        ]);


        //Remainder of application code here...
    }


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

}  //main

