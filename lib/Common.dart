/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

/*
███████████████████████████████████████████████████████████████████████████████████████████
Tsvg: Common library for Dart
▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
This file contains "global" constants, types, etc.; i.e., Commonly needed functionality.

███████████████████████████████████████████████████████████████████████████████████████████
*/


/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: GLOBAL constants and types
███████████████████████████████████████████████████████████████████████████████████████████
*/
final String Version        = '2012-08-28 : 0.3.2';
final String SeparatorLine1 = '███████████████████████████████████████████████████████████████████████████████████████████';
final String SeparatorLine2 = '■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■';
final String SeparatorLine3 = '▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪';
final String SeparatorLine4 = '═══════════════════════════════════════════════════════════════════════════════════════════';


/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: GLOBAL HELPER methods...
███████████████████████████████████████████████████████████████████████████████████████████
*/

/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
FUNCTION: set(HTML or SVG)Attributes
A handy extension to SVGElement and HtmlElement that allow us to
set an arbitrary number of attributes on an Element in given namespace.

NOTES: assigning values to element attributes using "element.attributes = {}"
is *destructive* for any already-set attribute values (i.e., you are replacing the
entire map); likewise, keep in mind that in order to remove a single attribute value,
you have to delete it using the map.remove() method.
In speed-critical regions (especially loops, mouse-move events), when setting just
one or two attributes, consider using the [] operator to set each (i.e.,
element.attributes['key'] = 'value' vs using these methods (may be marginally faster)

@param {map} attributesPairs:    Names and values of the attributes.

@example
var element = setSVGAttributes(mySVGElement, {'x':'0', 'y':'0', 'fill':'red' });
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
void setSVGAttributes(SVGElement svgEl, var attributesPairs) {
    attributesPairs.forEach((attr, value) {
        svgEl.attributes[attr] = value;
    });
}

void setElementAttributes(Element element, var attributesPairs) {
    attributesPairs.forEach((attr, value) {
        element.attributes[attr] = value;
    });
 }


/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
FUNCTION: isInstanceNameUnique
If the Dart List-class was easy to simply subclass, this function would have been
attached to such a derivation.  But, alas, I find their factory/implementation mess
just too difficult to work with.  It is not Delphi!  So, just pass in the list of
widgets and an instance-name to test for (i.e., see if it has been used), and
get back true/false as to whether it is unique.

indexOfInstanceName is very similar in function, and useful when we need list index
if a matching name is found.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
bool isInstanceNameUnique(List<Widget> widgetListRef, String instanceNameToTest) {
    for (Widget widget in widgetListRef) {
        if (widget.instanceName == instanceNameToTest) {
            return false;
        }
    }
    return true;
}

int indexOfInstanceName(List<Widget> widgetListRef, String instanceNameToTest) {
    for (int i = 0; i < widgetListRef.length; i++) {
        if (widgetListRef[i].instanceName == instanceNameToTest) return i;
    }
    return -1;
}

//TODO: Either make Tag truly unique, return a list of matches, or allow starting-index(search) to be passed in
int indexOfTag(List<Widget> widgetListRef, String tagValueToTest) {
    for (int i = 0; i < widgetListRef.length; i++) {
        if (widgetListRef[i].tag == tagValueToTest) return i;
    }
    return -1;
}


/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
FUNCTION: getIndexOfBorderTypeAndProp
Another helper...
pass reference to our list of stylable properties, and locate a particular instance.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
StyleTarget getStyleTargetFromListByObjAndProperty(List<StyleTarget> stylablePropsList, String objName, String propName) {
    for (StyleTarget target in stylablePropsList) {
        if ( (target.targetObject == objName) && (target.targetProperty == propName) ) {
            return target;
        }
    }
    return null;   //TODO: THROW EXCEPTION IF NOT IN LIST
}


/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
FUNCTION: ensureStandardNoneColor
Considers transparent/empty all to be the same value of 'none', otherwise retain
the color value passed in.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
String ensureStandardNoneColor(String colorToStandarize) {
    colorToStandarize = colorToStandarize.trim().toLowerCase();
    if ((colorToStandarize == '') || (colorToStandarize == 'transparent')) {
        return 'none';
    } else {
        return colorToStandarize;
    }
}


/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
CLASS: Line
Simplifiy and standardize storage of line information Line begin/end (X,Y) pairs
(i.e., start/end points)
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
class Line {
    num x1  = 0.0;
    num y1  = 0.0;
    num x2  = 0.0;
    num y2  = 0.0;

    Line.zeros();
    Line(this.x1, this.y1, this.x2, this.y2);
}


/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
CLASS: Color
Simplifiy and standardize storage of RGB Color information.
Skipped setters (and valid range testing) to lighten up the objects slightly.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
class Color {
    int R   = 0;
    int G   = 0;
    int B   = 0;

    static final int minValue = 0;
    static final int maxValue = 255;

    bool isBlack() {
        return (((R == minValue) && (G == minValue) && (B == minValue)) ? true : false);
    }

    bool isWhite() {
        return ((R == maxValue) && (G == maxValue) && (B == maxValue));
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    FUNCTION: shiftColor
    The amount of "shifting" (per color channel) defaults to a reasonable visual diff.
    Pass a negative value to make a color "darker" and a positive one for "lighter"
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void shiftColor([int shiftColorByInt=24]) {
        if (shiftColorByInt > 0) {lightenColor(shiftColorByInt);} else {darkenColor(-shiftColorByInt);}
    }

    void lightenColor([int shiftColorByInt=24]) {
        int GetShiftedSubColor(int channelValue) {
            return Math.min(maxValue, (channelValue + shiftColorByInt));
        }

        R = GetShiftedSubColor(R);
        G = GetShiftedSubColor(G);
        B = GetShiftedSubColor(B);
    }

    void darkenColor([int shiftColorByInt=24]) {
        int GetShiftedSubColor(int channelValue) {
            return Math.max(minValue, (channelValue - shiftColorByInt));
        }

        R = GetShiftedSubColor(R);
        G = GetShiftedSubColor(G);
        B = GetShiftedSubColor(B);
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    FUNCTION: loadFromRGBString
    Our off-page CSS style calculations will return colors (in Chrome/Dartium) in the
    form: "rgb(255, 255, 255)"
    Parse that String and load our Color object R,G,B values from it.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void loadFromRGBString(String RGBString) {
        if (!(RGBString.startsWith('rgb(')) ) return;

        List<String>    colorsSplit    = null;

        //whip string into a tight list of comma-delim values only; e.g.:255,255,255
        RGBString = RGBString.replaceFirst('rgb(', '');
        RGBString = RGBString.replaceAll(')', '');
        RGBString = RGBString.replaceAll(' ', '');

        colorsSplit= RGBString.split(',');
        R = Math.parseInt(colorsSplit[0]);
        G = Math.parseInt(colorsSplit[1]);
        B = Math.parseInt(colorsSplit[2]);
    }


    //return in the same approx format that the browser uses
    String formattedRGBString() {
        return 'rgb(${R.toString()}, ${G.toString()}, ${B.toString()})';
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CONSTRUCTORS
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    Color.empty();
    Color.fromIntRGB(this.R, this.G, this.B);
    Color.fromBrowserRBGString(String RGBString) {loadFromRGBString(RGBString);}

} //Color



/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
getBrowserType

Determine what type of browser this app is running within at a VERY high level.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
String getBrowserType() {
    if (window.navigator.userAgent.contains('Chrome/')) {
        return 'chrome';
    }

    if (window.navigator.userAgent.contains('Firefox/')) {
        return 'firefox';
    }

    return 'other';
}



/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
logToConsole

A debugging assistance routine that can dump semi-arbitrary list of strings and/or objects
to the console display in a format that is conducive to further interrogation in a
browser's debug window.

Predefined separator lines (Strings of bar-like-chars) are defined for easy formatting.

See SampleApplication for examples of usage.
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/
void logToConsole(List<Dynamic> itemsToLog) {

    itemsToLog.forEach( (itemToLog) {
        if (itemToLog is String) {
            switch(itemToLog) {
                case 'LINE1': {itemToLog = SeparatorLine1; break;}
                case 'LINE2': {itemToLog = SeparatorLine2; break;}
                case 'LINE3': {itemToLog = SeparatorLine3; break;}
                case 'LINE4': {itemToLog = SeparatorLine4; break;}
            }

            if (getBrowserType() == 'chrome') {
                print(itemToLog);
            } else {
                window.console.log(itemToLog);
            }

        } else {
            /*
            ═══════════════════════════════════════════════════════════════════════════════════════
            Any custom handling of Widgets and such here...
            ═══════════════════════════════════════════════════════════════════════════════════════
            */
            if (itemToLog is Widget) {
                print ("(${itemToLog.typeName}) instanceName=${itemToLog.instanceName}; HierarchyPath=${itemToLog.hierarchyPath}");
//                print(' ParentWidget: ${itemToLog.ParentWidget}');
//                print(' ParentSVGElement: ${itemToLog.ParentSVGElement}');
//                print(' GroupSVGElement : ${itemToLog.GroupSVGElement}');
//                print(' BorderGroupSVGElement : ${itemToLog.BorderGroupSVGElement}');
//                print(' ClientSVGElement: ${itemToLog.ClientSVGElement}');
//                print(' WidgetMetrics: ${itemToLog.WidgetMetrics}');
//                print(' Border: ${itemToLog.Border}');
//                print(' Align: ${itemToLog.Align}');
//                print(' Anchors: ${itemToLog.Anchors}');
//                print(' SizeRules: ${itemToLog.SizeRules}');
            }

            //This line will produce an expandable "object>" reference in the console.
            print(itemToLog);
        }

    }); //...forEach

} //logToConsole



/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: EVENT-RELATED TYPEDEFS AND ASSOCIATED OBJECTS
███████████████████████████████████████████████████████████████████████████████████████████
*/


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Method signature to enforce throughout application for standard callback handler parameters.
*
* ## See Also
* Refer to the [EventsProcessor] class for more information about how events are processed
* within Widgets.
*
* Refer to the [NotifyEvent] class documentation "Preface" section for a discussion
* regarding Event-Types and Event Objects in General as implemented in this framework.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
typedef void ChangeHandler();


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* ## Preface (Event-Types and Event Objects in General)
*
* In an attempt to bring some level of type-predictability to the component set,
* we define event-object types (and corresponding objects) that will be used to
* establish consistent method-signatures for events and a consistent way to pass values
* to event implementor's code.
*
* E.g., all basic events will use the [NotifyEventObject] which will pass the event-handler
* a reference to the [Widget] that invoked the event (i.e., "sender").
*
* Other more involved events will define their own event objects that will introduce
* any further values or references (where applicable) needed for consistent and predictable
* event handling.  E.g., a KeyPress event could add a reference to the Key value pressed
* (by including the native associated Event object), and a Mouse-related Event will
* include the native [MouseEvent] object ref (so we can have access to Button, ShiftState,
* X & Y coordinates of click, etc., as well as perhaps reference to the SVG DOM element
* that initiated the event if useful, etc.)
*
* To see how this is all implemented, take a look at examples of the internal Widget Methods
* (like Show, Hide, MouseDown, etc) and the samples that create some Widgets and setup user-
* defined callbacks for Widget.on.eventNameHere; the Widget class native events will include
* callbacks to those (look for _on.eventNameHere(new(NotifyEventObj())) stuff.
*
* ---
*
* NotifyEvent provides a method signature to enforce throughout application for
* event-related callback handler parameters.
*
* ## See Also
* Refer to the [EventsProcessor] class for more information about how events are processed
* within Widgets.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
typedef void NotifyEvent(NotifyEventObject objInitiator);


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Method signature to enforce throughout application for mouse-event-related callback
* handler parameters.
*
* ## See Also
* Refer to the [EventsProcessor] class for more information about how events are processed
* within Widgets.
*
* Refer to the [NotifyEvent] class documentation "Preface" section for a discussion
* regarding Event-Types and Event Objects in General as implemented in this framework.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
typedef void MouseNotifyEvent(MouseNotifyEventObject objInitiator);


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Method signature to enforce throughout application for constrained-mouse-event-related
* callback handler parameters, e.g., as used in [WidgetPosRules].
*
* ## See Also
* Refer to the [EventsProcessor] class for more information about how events are processed
* within Widgets.
*
* Refer to the [NotifyEvent] class documentation "Preface" section for a discussion
* regarding Event-Types and Event Objects in General as implemented in this framework.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
typedef num  MouseConstraintEvent(MouseNotifyEventObject objInitiator);     //return constrained coordinate value


//TODO: keyboard events support?
//obj to include: Keyboard Event... String Key, bool ShiftKey, bool AltKey, etc
//This is going to be needed by "native" (SVG-only) text-entry facilities, should we implement them.
//typedef void KeypressNotifyEvent(KeyPressEventObject objInitiator);

//TODO: touch-support?
//typedef void GestureNotifyEvent(Dynamic Object, var GestureInfo??);



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* An event object that includes a reference to the [Widget] that was the source of the
* event.
*
* ## See Also
* Refer to the [EventsProcessor] class for more information about how events are processed
* within Widgets.
*
* Refer to the [NotifyEvent] class documentation "Preface" section for a discussion
* regarding Event-Types and Event Objects in General as implemented in this framework.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class NotifyEventObject {
    Widget sender;

    NotifyEventObject(this.sender);
}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* An event object that includes a reference to the [Widget] that was the source of the
* event, plus related [MouseEvent] object that contains info like:
*
*     (int)event.button, (bool)event.shiftKey, (int)event.clientX, (int)event.clientY, etc
*
* See the [Dart Language MouseEvent Reference](http://api.dartlang.org/docs/continuous/dart_html/MouseEvent.html) —
* for further details regarding what fields are available, their data-types, etc.
*
* ## See Also
* Refer to the [EventsProcessor] class for more information about how events are processed
* within Widgets.
*
* Refer to the [NotifyEvent] class documentation "Preface" section for a discussion
* regarding Event-Types and Event Objects in General as implemented in this framework.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class MouseNotifyEventObject {
    Widget      sender;
    MouseEvent  eventInfo;

    MouseNotifyEventObject(this.sender, this.eventInfo);
}



/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: EXCEPTION Types

These objects should be named such that their intent/usage is rather obvious.

Usage Example:
    throw new InvalidTypeException('Invalid callback method signature',  'NotifyEvent', userFxToExecuteOnEvent);

███████████████████████████████████████████████████████████████████████████████████████████
*/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Custom [Exception] class whose instance is thrown when a unique constraint is violated
* within a Widget or elsewhere in the Application framework or code implementing the same.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class UniqueConstraintException implements Exception {
    String dupValue;

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * ### Parameters:
    *   * [String] dupValue: the duplicate value encountered that caused the constraint violation.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    UniqueConstraintException(this.dupValue);

    ///Produce a nicely formatted message with necessary Exception information in it.
    String toString() => "Unique Constraint Violation.  Duplicate value: $dupValue";
}


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Custom [Exception] class whose instance is thrown when a unexpected / invalid type
* is encountered within a Widget or elsewhere in the Application framework or code
* implementing the same.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class InvalidTypeException implements Exception {
    String  typeErrorDesc;
    String  typeExpected;
    Dynamic offendingType;

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * ### Parameters:
    *   * [String] typeErrorDesc: whatever descriptive information is helpful, as provided by
    * the code throwing the exception.
    *   * [String] typeExpected: the name of the Type that *should* have been encountered.
    *   * [Dynamic] offendingType: the encountered Type that violated expectation for another type.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    InvalidTypeException(this.typeErrorDesc, this.typeExpected, this.offendingType);

    ///Produce a nicely formatted message with necessary Exception information in it.
    String toString() => "Unexpected Type Error ($typeErrorDesc).  Expected type: ()$typeExpected.  Encountered type: $offendingType";
}

