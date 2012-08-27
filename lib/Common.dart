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
final String Version        = '2012-08-24 : 0.3.1';
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
    FUNCTION: LoadFromRGBString
    Our off-page CSS style calculations will return colors (in Chrome/Dartium) in the
    form: "rgb(255, 255, 255)"
    Parse that String and load our Color object R,G,B values from it.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void LoadFromRGBString(String RGBString) {
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
    Color.fromBrowserRBGString(String RGBString) {LoadFromRGBString(RGBString);}

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
BEGIN: TYPEDEFS

DESCRIPTION
Method signatures to enforce throughout application, especially for CallBack parameters.

▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
EVENT-RELATED TYPEDEFS...
(NOTE: see that EventsProcessor class documentation too)

In an attempt to bring some level of type-predictability to the component set,
we define event-object types (and corresponding objects) that will be used to
establish consistent method-signatures for events and a consistent way to pass values
to event implementor's code.

E.g., all basic events will use the NotifyEventObject which will pass the event-handler
a reference to the Widget that invoked the event (i.e., "sender").

Other more involved events will define their own event objects that will introduce
any further values or references (where applicable) needed for consistent and predictable
event handling.  E.g., a KeyPress event will add a reference to the Key value pressed
(by including the native associated Event object), and a Mouse-related Event will
include the native MouseEvent object ref (so we can have access to Button, ShiftState,
X & Y coords of click, etc., as well as perhaps reference to the SVG DOM element
that initiated the event if useful, etc.)

To see how this is all implemented, take a look at examples of the internal Widget Methods
(like Show, Hide, MouseDown, etc) and the samples that create some Widgets and setup user-
defined callbacks for Widget.on.eventNameHere; the Widget class native events will include
callbacks to those (look for _on.eventNameHere(new(NotifyEventObj())) stuff.

███████████████████████████████████████████████████████████████████████████████████████████
*/
typedef void ChangeHandler();
typedef void NotifyEvent(NotifyEventObject objInitiator);
typedef void MouseNotifyEvent(MouseNotifyEventObject objInitiator);
typedef num  MouseConstraintEvent(MouseNotifyEventObject objInitiator);     //return constrained coordinate value
//typedef void KeypressNotifyEvent(KeyPressEventObject objInitiator); //obj to include: Keyboard Event... String Key, bool ShiftKey, bool AltKey, etc
//typedef void GestureNotifyEvent(Dynamic Object, var GestureInfo??); //placeholder for idea

class NotifyEventObject {
    Widget sender;

    NotifyEventObject(this.sender);
}

/*
▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
MouseNotifyEventObject includes a reference to the MouseEvent object that contains info like:
    (int)event.button, (bool)event.shiftKey, (int)event.clientX, (int)event.clientY, etc

For details about MOUSE EVENTS in  DART, SEE http://api.dartlang.org/html/MouseEvent.html
That will show what fields are available, their datatypes, etc.
▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
*/
class MouseNotifyEventObject {
    Widget      sender;
    MouseEvent  eventInfo;

    MouseNotifyEventObject(this.sender, this.eventInfo);
}



/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: EXCEPTION Types

DESCRIPTION
These objects should be named such that their intent/usage is rather obvious.

Usage Example:
    throw new InvalidTypeException('Invalid callback method signature',  'NotifyEvent', userFxToExecuteOnEvent);

███████████████████████████████████████████████████████████████████████████████████████████
*/
class UniqueConstraintException implements Exception {
    String dupValue;
    UniqueConstraintException(this.dupValue);

    String toString() => "Unique Constraint Violation.  Duplicate value: $dupValue";
}


class InvalidTypeException implements Exception {
    String  typeErrorDesc;
    String  typeExpected;
    Dynamic offendingType;

    InvalidTypeException(this.typeErrorDesc, this.typeExpected, this.offendingType);

    String toString() => "Unexpected Type Error ($typeErrorDesc).  Expected type: ()$typeExpected.  Encountered type: $offendingType";
}

