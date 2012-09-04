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
NOTES:
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
*/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Method that allows setting an arbitrary number of attributes on the [SVGElement]
* specified in [svgEl]. The [attributesPairs] parameter is a reference to a [Map] (array)
* of element attributes and their desired values, to be applied to [svgEl].
*
* E.g., the calling code could look like this:
*
*     setSVGAttributes(_someSVGElement, {
*         'display'       : 'inherit',
*         'visibility'    : 'visible'
*     });
*
* ## See Also
* [setElementAttributes] exists for setting arbitrary number of attributes on HTML elements.
*
* ## Notes
* This helper method is especially useful when *updating* more than one attribute at a time.
* Remember that assigning values to Element attributes using "(SVG)Element.attributes = {map-data-here}"
* is *destructive* for any already-set attribute values (i.e., you are replacing the
* entire attributes map); likewise, keep in mind that in order to *remove* a single attribute value,
* you have to delete it using the [Map.remove] method.
*
* In speed-critical regions (especially loops, mouse-move events), when setting just
* one or two attributes, consider using the native Element '[]' operator to set each (i.e.,
* Element.attributes['key'] = 'value' vs. using this custom method, as it may be marginally faster).
**/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
void setSVGAttributes(SVGElement svgEl, var attributesPairs) {
    attributesPairs.forEach((attr, value) {
        svgEl.attributes[attr] = value;
    });
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Method that allows setting an arbitrary number of attributes on the (HTML) [Element]
* specified in [element]. The [attributesPairs] parameter is a reference to a [Map] (array)
* of element attributes and their desired values, to be applied to [element].
*
* E.g., the calling code could look like this:
*
*     setElementAttributes(_someHtmlElement, {
*         'x'             : '100.0',
*         'y'             : '50.0'
*     });
*
* ## See Also
* [setSVGAttributes] exists for setting arbitrary number of attributes on SVG elements.
* In addition, the *"Notes"* section there applies equally here.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
void setElementAttributes(Element element, var attributesPairs) {
    attributesPairs.forEach((attr, value) {
        element.attributes[attr] = value;
    });
 }


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Method to test for the existence of a particular [Widget] instance reference within
* the list specified in the [widgetListRef] parameter.
* The list is searched for a Widget with [Widget.instanceName] = [instanceNameToTest].
*
* If a match is located, return [true], otherwise return [false].
*
* ## See Also
* [indexOfInstanceName] is very similar in function, and useful when we need list index
* if a matching instanceName is found.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
bool isInstanceNameUnique(List<Widget> widgetListRef, String instanceNameToTest) {
    for (Widget widget in widgetListRef) {
        if (widget.instanceName == instanceNameToTest) {
            return false;
        }
    }
    return true;
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Method to locate a particular [Widget] instance reference within the list specified
* in the [widgetListRef] parameter.
* The list is searched for a Widget with [Widget.instanceName] = [instanceNameToTest].
*
* If a match is located, return the list index at which it resides, otherwise return
* the value -1 (negative one) to indicate no match has been found.
*
* ## See Also
* [isInstanceNameUnique] is very similar in function, and useful when we need to
* simply know (true/false) whether a matching instanceName is found.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
int indexOfInstanceName(List<Widget> widgetListRef, String instanceNameToTest) {
    for (int i = 0; i < widgetListRef.length; i++) {
        if (widgetListRef[i].instanceName == instanceNameToTest) return i;
    }
    return -1;
}

//TODO: Either make Tag truly unique, return a list of matches, or allow starting-index(search) to be passed in
///Not used quite yet.
int indexOfTag(List<Widget> widgetListRef, String tagValueToTest) {
    for (int i = 0; i < widgetListRef.length; i++) {
        if (widgetListRef[i].tag == tagValueToTest) return i;
    }
    return -1;
}


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Method to locate a particular [StyleTarget] instance reference within the list specified
* in the [stylablePropsList] parameter.
* The list is searched for a [StyleTarget] with [StyleTarget.targetObject] = [objName] and
* [StyleTarget.targetProperty] = [propName].
*
* If a match is located in list, return the reference to it, otherwise return [:null:].
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
StyleTarget getStyleTargetFromListByObjAndProperty(List<StyleTarget> stylablePropsList, String objName, String propName) {
    for (StyleTarget target in stylablePropsList) {
        if ( (target.targetObject == objName) && (target.targetProperty == propName) ) {
            return target;
        }
    }
    return null;   //TODO: THROW EXCEPTION IF NOT IN LIST
}


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Considers color values of 'transparent', empty (i.e., ''), and 'none' to all be
* equivalent and coerces them to a standard value of 'none'; for all other color strings
* passed into this method, the original value is retained as the return value.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
String ensureStandardNoneColor(String colorToStandarize) {
    colorToStandarize = colorToStandarize.trim().toLowerCase();
    if ((colorToStandarize == '') || (colorToStandarize == 'transparent')) {
        return 'none';
    } else {
        return colorToStandarize;
    }
}


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Simplify and standardize storage of line information Line begin/end (X,Y) pairs
* (i.e., start/end points). Essentially just a struct at this time, but that could
* change in the future.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Line {
    num x1  = 0.0;
    num y1  = 0.0;
    num x2  = 0.0;
    num y2  = 0.0;

    Line.zeros();
    Line(this.x1, this.y1, this.x2, this.y2);
}


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Simplify and standardize storage of RGB Color information used throughout framework.
* Chose to omit "setters" (and valid range testing) to lighten up the objects slightly.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Color {
    int R   = 0;
    int G   = 0;
    int B   = 0;

    static final int minValue = 0;
    static final int maxValue = 255;

    ///Returns [true] if all color channel values (R/G/B) are zero valued, else [false].
    bool isBlack() {
        return (((R == minValue) && (G == minValue) && (B == minValue)) ? true : false);
    }

    ///Returns [true] if all color channel values (R/G/B) are "max" valued (i.e., int 255), else [false].
    bool isWhite() {
        return ((R == maxValue) && (G == maxValue) && (B == maxValue));
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Adjust the [R],[G],[B] color stored herein by the amount of "shifting" (per color channel) as
    * specified in [shiftColorByInt] parameter, which defaults to a reasonable visual diff.
    *
    * Pass a negative value to make a color "darker" and a positive one for "lighter"
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
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



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Our off-page CSS style calculations will return colors (in Chrome/Dartium) in the
    * form: "rgb(255, 255, 255)".
    * Parse that String and load our Color object [R],[G],[B] values from it.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
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
    final string spacesConst = "                                 ";
    String  insetPretty = "";
    bool    alignT = false;
    bool    alignR = false;
    bool    alignB = false;
    bool    alignL = false;
    bool    sizing = false;

    Dynamic naForNull(var value) {
        return (value == null ? 'n/a' : value);
    }

    void writeLine(var valueToWrite) {
        if (getBrowserType() == 'chrome') {
            print(valueToWrite);
        } else {
            window.console.log(valueToWrite);
        }
    }

    itemsToLog.forEach( (toLog) {
        if (toLog is String) {
            switch(toLog) {
                case 'LINE1': {toLog = SeparatorLine1; break;}
                case 'LINE2': {toLog = SeparatorLine2; break;}
                case 'LINE3': {toLog = SeparatorLine3; break;}
                case 'LINE4': {toLog = SeparatorLine4; break;}
            }

            writeLine(toLog);

        } else {
            /*
            ═══════════════════════════════════════════════════════════════════════════════════════
            Any custom handling of Widgets and such here...
            ═══════════════════════════════════════════════════════════════════════════════════════
            */
            if (toLog is Widget) {
                insetPretty = spacesConst.substring(1,toLog.typeName.length + 4); //smart indent

                alignT = !((toLog.align.T.objToAlignTo == null) && (toLog.align.T.dimension == eSides.None));
                alignR = !((toLog.align.R.objToAlignTo == null) && (toLog.align.R.dimension == eSides.None));
                alignB = !((toLog.align.B.objToAlignTo == null) && (toLog.align.B.dimension == eSides.None));
                alignL = !((toLog.align.L.objToAlignTo == null) && (toLog.align.L.dimension == eSides.None));
                //sizing =

                writeLine ("(${toLog.typeName}) >> Identifying Data: instanceName='${toLog.instanceName}';  HierarchyPath='${toLog.hierarchyPath}';  Tag='${toLog.tag}';");
                writeLine ("${insetPretty}>> Current widgetState: ${eWidgetState.getCommaDelimNamesInVal(toLog.widgetState)};");
                writeLine ("${insetPretty}>> Geometry Data: (x, y)=(${toLog.x}, ${toLog.y});  (translateX, translateY)=(${toLog.translateX}, ${toLog.translateY});  (width, height)=(${toLog.width}, ${toLog.height});  (xAsClientX, yAsClientY)=(${toLog.xAsClientX}, ${toLog.yAsClientY});");
                writeLine ("${insetPretty}>> Aligned?  Top=${alignT};  align.Right=${alignR};  align.Bottom=${alignB};  align.Left=${alignL};");
                writeLine ("${insetPretty}>> sizeRules: (minWidth, MaxWidth)=(${(naForNull(toLog.sizeRules.minWidth))}, ${(naForNull(toLog.sizeRules.maxWidth))});  (minHeight, maxHeight)=(${(naForNull(toLog.sizeRules.minHeight))}, ${(naForNull(toLog.sizeRules.maxHeight))})");
                writeLine ("${insetPretty}>> Other Contraints: anchors=${eSides.getCommaDelimNamesInVal(toLog.anchors)};");

                if (toLog.hasParent) {
                    writeLine ("${insetPretty}>> PARENT Data: Owned Child Count=${toLog.parentWidget.getWidgetCount()}; Index of this object in parent WidgetList: ${toLog.parentWidget.indexOfWidget(toLog)};");
                }

            }

            //This line will produce an expandable "object>" reference in the console.
            //TODO: Dartium console not yet like Chromium/JS (this does not show as viewable, hierarchical, inspectable object yet:
            //writeLine(itemToLog);
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

