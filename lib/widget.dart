/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: Various enumerations

DESCRIPTION
These enumeration sets/objects should be named such that their intent/usage is rather obvious.
They are here for convenience, consistency, coding simplicity (and readability), and
centralization of common constants and their associated "names".

███████████████████████████████████████████████████████████████████████████████████████████
*/


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Notice that these enumerated "state" values are *additive* powers-of-two (0, 1, 2, 4, 8, ...)
* such that we can do bitwise operations and allow a [Widget] to be in multiple "states"
* simultaneously and test for each state independently.
*
* E.g., a widget can be both [Showing] and [Updating] at once.
*
* Widgets begin their existence in [Loading] state, and remain there until first shown
* (via [Widget.show] method), at which point state will transition to [Normal] *and* [Showing].
* If the widget is later hidden/shown, the [Showing] bit will flip off/on accordingly.
* During moving/sizing attempts, those corresponding bits will be "flipped" as needed also.
*
* [Updating] is a special state that can be set via [Widget.beginUpdate] and
* [Widget.endUpdate] to flag intentions for bulk-changes to Widget properties,
* and we can bypass expensive computations til "endUpdate" is executed.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class eWidgetState {
    static final int Unknown  = 0;
    static final int Normal   = 1;
    static final int Loading  = 2;
    static final int Showing  = 4;
    static final int Moving   = 8;
    static final int Sizing   = 16;
    static final int Updating = 32;

    static final Map Names = const {
        '0':'Unknown',
        '1':'Normal',
        '2':'Loading',
        '4':'Showing',
        '8':'Moving',
        '16':'Sizing',
        '32':'Updating'
    };

    static getCommaDelimNamesInVal(int intSides) {
        String _includedNames = '';

        Names.forEach( (nameItemKey, nameItemValue) {
            if ( (Math.parseInt(nameItemKey) & intSides) == Math.parseInt(nameItemKey))  {
                _includedNames = ((_includedNames == Names['0']) ? '' : _includedNames);  //Remove 'Unknown" if it is NOT the *only* "match"
                _includedNames = "${_includedNames}${(_includedNames.length > 0 ? ',' : '')}${nameItemValue}";
            }
        }); //...forEach

        return _includedNames;
    }



}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Enumeration of various Sides of a [Widget]. These enumerated values will be used
* when drawing borders, aligning widgets, and more. Shorthand aliases exist for each
* value too.
*
* Represent TRBL (Top/Right/Bottom/Left) "sides" of boxes, etc as powers of 2 (0, 1, 2, 4, 8).
* These values are *additive*, such that if all sides are specified, the value is "All"
* (all sides aligned to Client-Rect).
*
* Center(X/Y) is a "pseudo-side" (really a point representation — midpoint of LR or TB lines
* that form a side).
*
* ---
* ## Notational Caveats (currently):
* **TODO**: a Sides may also be discussed as Dimension for alignment; perhaps rename,
* since eSide not best for "CX", etc?
*
* Furthermore, at this time, the [Names] map does not include the verbose form of each enum.
* The jury is still out on whether to include them in the map and/or remove the individual
* variables to resolve this.  User-preferences for side-naming??  Input welcome.
*
* ---
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class eSides {
    static final int None     = 0;
    static final int Top      = 1;
    static final int Right    = 2;
    static final int Bottom   = 4;
    static final int Left     = 8;
    static final int All      = 15;  //not valid for Dimension usage (i.e., alignTo dimension)
    static final int CenterX  = 16;
    static final int CenterY  = 32;
    static final int T        = 1;
    static final int R        = 2;
    static final int B        = 4;
    static final int L        = 8;
    static final int CX       = 16;
    static final int CY       = 32;

    static final Map Names = const {
        '0':'None',
        '1':'T',
        '2':'R',
        '4':'B',
        '8':'L',
        '15':'ALL',
        '16':'CX',
        '32':'CY'
    };

    static getCommaDelimNamesInVal(int intSides) {
        String _includedNames = '';

        Names.forEach( (nameItemKey, nameItemValue) {
            if ( (Math.parseInt(nameItemKey) & intSides) == Math.parseInt(nameItemKey))  {
                _includedNames = ((_includedNames == Names['0']) ? '' : _includedNames);  //Remove 'None" if it is NOT the *only* "match"
                _includedNames = "${_includedNames}${(_includedNames.length > 0 ? ',' : '')}${nameItemValue}";
            }
        }); //...forEach

        return _includedNames;
    }

}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Enumeration of various "parts" of a [Widget].
*
* Variation in implementation and meaning-nuances come into play depending if a
* WidgetPart is being used in the context of:
*
*    1. [WidgetMetrics] — **Note:** see WidgetMetrics class documentation for info on how parts are arranged in Widget.
*    2. [WidgetBorders]
*
* E.g., note how the "WidgetBounds" (outer boundaries of a widget) and the widget's Margin
* are *very* similar concepts, and our implementation and usage reflects this.
* "WidgetBounds" linguistically makes more sense when describing the use of this
* enum in certain situations, where Margin is a more common term for the use in other areas.
*
* When talking about the "boundaries (bounds)" of a Widget or component of a Widget (*Metrics*),
* it is true that WidgetBounds coordinates would match the outermost portion of the
* Margin-region; thus, they are "equal" in that regard.
* But, conceptually, the term Margin refers to the entire (potentially, depending on margin-widths)
* region running from the outer boundaries of the Widget to the outer-edge of our outer-border.
*
* In the context of *Borders*, only a few of these widget parts has any associated
* rendered visuals; i.e., Line(s) that make up the borders. See the [LineCount] list
* (refer to source code for values)
* and notice that only Outer, Frame, and Inner WidgetParts (Borders) have any SVG Line(s)
* per side.  The other parts are "virtual" (e.g., margin/padding are just optional spacing
* per side).
*
* We will use the combination of eWidgetPart plus [eSides] (T, R, B, L) when working with
* objects and operations requiring such per-side granularity, e.g., Margin.Right, etc
*
* ---
* ## Alignment-related usage notes:
*
* Alignment will be immediately to the *outside* of specified Part.Side; i.e., if the left side
* of a Widget's ClientBounds rect is at position 100 and we align another widget's right side
* to that part, the right (aka, 'x2') coordinate of the aligned widget's WidgetBounds is to be 99.
*
*      pseudo-code example usage: Widget.Right(side).AlignTo(WidgetInstanceRef.WidgetPart.Side)
*
* ---
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class eWidgetPart {
    static final int None           = 0;
    static final int Margin         = 1;  //i.e., WidgetBounds from the perspective of Metrics
    static final int Outer          = 2;
    static final int Frame          = 3;
    static final int Inner          = 4;
    static final int Padding        = 5;
    static final int ClientBounds   = 6;

    //eWidgetPartNames : could cause "fragile" code... consider string uses elsewhere in code if changing these.
    static final List<String> Names = const [
        'None',
        'Margin',
        'Outer',
        'Frame',
        'Inner',
        'Padding',
        'ClientBounds'
    ];

    //the max# of SVG Line Element(s) used to draw a given part of widget
    static final List<int>    LineCount = const [0, 0, 2, 1, 2, 0, 0 ];
}



/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: MISC Widget-related CLASSES
Constraints (dimension / position Rules & limitations) are handled in part by the
next few classes.
███████████████████████████████████████████████████████████████████████████████████████████
*/


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Standard way to store and retrieve rules affecting [Widget] dynamics, like sizing
* and moving along given axis.  In addition, do we want to "capture" events?
*
* The [Widget] class uses this construct for its [Widget.isSizable] and
* [Widget.isMovable] properties, and the [widget.handleIsMovableIsSizableChanges] handler
* is "wired in" during the Widget's constructor initialization for both of these properties.
*
* When [x] or [y] values are set, we fire our [changeHandler] callback method, so that
* we can setup things like mouse handlers, cursor changes, and such that reference objects
* not otherwise available to use from within this class (e.g., SVG elements)
*
* A [Widget] instance will test these WidgetDynamics x/y properties (flags) during
* the [Widget.mouseDown] and [Widget.move] methods to make sure only those move/size
* attempts per [Widget.isSizable] and [Widget.isMovable] x/y rules are permitted.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class WidgetDynamics {
    bool _x         = false;
    bool _y         = false;
    bool useCapture = false;
    ChangeHandler changeHandler;

    bool get x    => _x;
    void set x(newX) {
        _x = newX;
        if (changeHandler != null) {changeHandler();}
    }

    bool get y    => _y;
    void set y(newY) {
        _y = newY;
        if (changeHandler != null) {changeHandler();}
    }

} //class WidgetDynamics



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Sizing Rules ("SizeRules") — with regards to allowable min/max width and/or height of a
* a [Widget] — are used when we wish to constrain Widget size during resize and/or resize
* attempts (as a result of the effect of [Widget.anchors].
*
* This class provides a standard way to store and retrieve sizing rules associated with Widgets.
* The [changeHandler] is a callback that is used by [Widget.handleSizeRuleChanges] in
* order to enforce these rules during any attempt to change [Widget.width] or [Widget.height].
* The callback is "wired in" to the Widget as part of the Widget's constructor / initialization
* process.
*
* Upon setting, axis-specific min-values must be <= to the corresponding max-values
* for that axis and are coerced into being so; likewise, maximums must be >= minimums.
*
* ## Possible Functionality Enhancement (if demand merits)
* Similar to how the functionality the [WidgetPosRules] currently provide,
* if use-cases justify, provide a callback for more "complex" sizing-rules and let the
* implementor provide for dynamic determination of min/max width/height.
* Compared to PosRules, this would additional logic of using the numeric values
* for minWidth/etc when no callback is provided.  Such an approach would allow for
* things like changing the size rules relative to other object dimensions or other
* objects' dimensions.
*
*     e.g., max-width = container's width - width of another object; though, this may be
*     handled already by a combination of Alignment and/or Position Constraints.
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class WidgetSizeRules {
    num _minWidth       = null;
    num _minHeight      = null;
    num _maxWidth       = null;    //null represents "Infinity" (i.e., no max)
    num _maxHeight      = null;    //null represents "Infinity" (i.e., no max)
    ChangeHandler  changeHandler;

    //TODO: THE GET MINIMUM W/H really need to be calculated (vs "20.0" value) such that bgRect/borders/etc "fit" within min (and client rect of zero w/h min)?
    num get minWidth    => (_minWidth == null ? 20.0 : _minWidth);
    void set minWidth(newVal) {
        if (_minWidth   == newVal) return;
        _minWidth = (_maxWidth != null) ? Math.min(newVal, _maxWidth) : newVal;
        if (changeHandler != null) {changeHandler();}
    }

    num get minHeight   =>  (_minHeight== null ? 20.0 : _minHeight);
    void set minHeight(newVal) {
        if (_minHeight  == newVal) return;
        _minHeight = (_maxHeight != null) ? Math.min(newVal, _maxHeight) : newVal;
        if (changeHandler != null) {changeHandler();}
    }

    num get maxWidth    =>  _maxWidth;
    void set maxWidth(newVal) {
        if (_maxWidth   == newVal) return;
        _maxWidth = Math.max(newVal, minWidth);
        if (changeHandler != null) {changeHandler();}
    }

    num get maxHeight   =>  _maxHeight;
    void set maxHeight(newVal) {
        if (_maxHeight  == newVal) return;
        _maxHeight = Math.max(newVal, minHeight);
        if (changeHandler != null) {changeHandler();}
    }

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    The following two methods test a proposed Width or Height against the constraints set
    forth within these sizing rules, and return properly constrained value.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    num getConstrainedWidth(num proposedVal) {
        num tempMax = (_maxWidth != null) ? Math.min(proposedVal, _maxWidth) : proposedVal;
        return Math.max(tempMax, minWidth);
    }

    num getConstrainedHeight(num proposedVal) {
        num tempMax = (_maxHeight != null) ? Math.min(proposedVal, _maxHeight) : proposedVal;
        return Math.max(tempMax, minHeight);
    }

} //WidgetSizeRules



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* "Position Rules (PosRules)" — with regards to allowable min/max coordinates of the
* T/R/B/L sides of a [Widget] — are used when we wish to constrain Widget positioning
* during movement, resize, and/or alignment attempts.
*
* The only parts that made sense for constraining (other than perhaps fringe-cases for
* center-point constraints) were the 4 sides;
* i.e., the top/left and bottom/right of a widget's bounds can be subject to constraint.
* This can be further boiled down to constraining the widget's min/max X & Y
* (top-left corner) position, and user can calc the rest.
*
* Due to the wide variety of possible positioning-constraints that could exist, we
* implement such rules via implementer-defined *callbacks per object-instance* of
* type [MouseConstraintEvent].
* Any provided callback must return a value (Min/Max X/Y depending on property) that a
* Widget will use (during Move method) to test positioning requests against.
*
* With callbacks, we can handle all sorts of positioning-rule forms, like:
*
*  1) simply limiting the Top/Left (X/Y) position within a specific fixed numeric range
*  (relative to its parent)
*
*  2) constrain position based on a referenced-object's part/dimension value.
*
*  3) more complex situations like setting a position relative to another object plus/minus
* some constant, etc.
*
* We pass [MouseEvent] data through to the callback method also, so implementor
* can have access to mouse position information if they care to. *Note:* this could
* easily be extended to pass other potentially useful data through
* in a custom event object.
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class WidgetPosRules {
    //list of PosRule objects.
    MouseConstraintEvent _minX;
    MouseConstraintEvent _maxX;
    MouseConstraintEvent _minY;
    MouseConstraintEvent _maxY;

    void set minX(MouseConstraintEvent callbackMethod) {_minX = callbackMethod;}
    num  getMinX(MouseNotifyEventObject objInitiator) => ((_minX != null) ? _minX(objInitiator) : null);

    void set maxX(MouseConstraintEvent callbackMethod) {_maxX = callbackMethod;}
    num  getMaxX(MouseNotifyEventObject objInitiator) => ((_maxX != null) ? _maxX(objInitiator) : null);

    void set minY(MouseConstraintEvent callbackMethod) {_minY = callbackMethod;}
    num  getMinY(MouseNotifyEventObject objInitiator) => ((_minY != null) ? _minY(objInitiator) : null);
    
    void set maxY(MouseConstraintEvent callbackMethod) {_maxY = callbackMethod;}
    num  getMaxY(MouseNotifyEventObject objInitiator) => ((_maxY != null) ? _maxY(objInitiator) : null);
} //WidgetPosRules





/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: BOUNDS AND WIDGET-METRICS CLASSES
███████████████████████████████████████████████████████████████████████████████████████████
*/


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Encapsulates standard storage and retrieval of bounding-information
* associated with Widgets, Canvas, etc.
*
* i.e., Left, Top, Right, Bottom (L,T,R,B or, a.k.a. x1,y1,x2,y2) and aliases for
* obtaining CenterX, CenterY (i.e., side-midpoints of CX,CY), and Width and Height
* from the provided LTRB information.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class ObjectBounds {
    num T = 0.0;
    num R = 0.0;
    num B = 0.0;
    num L = 0.0;

    num get Width   => R - L;

    num get Height  => B - T;

    ///Center-point along X-axis.
    num get CX      => ((R - L) / 2) + L;

    ///Center-point along Y-axis.
    num get CY      => ((B - T) / 2) + T;

    num operator [] (String part) => _getPart(part);

    num _getPart(String part) {
        switch (part) {
            case 'T':       return T;
            case 'R':       return R;
            case 'B':       return B;
            case 'L':       return L;
            case 'CX':      return CX;
            case 'CY':      return CY;
            case 'Width':   return Width;
            case 'Height':  return Height;
            default:        return null;  //fallthrough means invalid specification: throw??
        }
    }

}  //ObjectBounds class



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Keeps track of all the [ObjectBounds] — i.e., the bounding-rects — for each
* [eWidgetPart] sub-component of a [Widget] that forms a distinct boundary we may
* need to reference, with each bounding box being the *outside* of the
* respective rectangle as defined by each
* ObjectBounds Left, Top, Right, and Bottom coordinates (i.e., coordinates: x1,y1, x2,y2)
*
* The various bounds that describe a Widget are as follow, and we start with outside of
* the Margin (aka, WidgetBounds) and move inward:
*
*  * Margin/WidgetBounds:Widget's outer rect/bounding-box within which all sub-components of widget are rendered
*  * OuterBorder:        subtract Margin (width per side) from WidgetBounds to get bounds of OuterBorder
*  * Frame:              subtract Margin and OuterBorder from WidgetBounds to get bounds of Frame
*  * Inner:              ...
*  * Padding:            ... until finally reaching...
*  * ClientBounds:       the Container region for a Widget's Child-Widget(s)
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class WidgetMetrics {
    ObjectBounds Margin         = null;
    ObjectBounds Outer          = null;
    ObjectBounds Frame          = null;
    ObjectBounds Inner          = null;
    ObjectBounds Padding        = null;
    ObjectBounds ClientBounds   = null;

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    CONSTRUCTOR
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    WidgetMetrics() :
        Margin          = new ObjectBounds(),
        Outer           = new ObjectBounds(),
        Frame           = new ObjectBounds(),
        Inner           = new ObjectBounds(),
        Padding         = new ObjectBounds(),
        ClientBounds    = new ObjectBounds();


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Operator
        part : expects a valid value from the enumeration eWidgetPart (int)
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    ObjectBounds operator [] (int part) => _getPart(part);

    ObjectBounds _getPart(int part) {
        switch (part) {
            case eWidgetPart.Margin         : return Margin      ;
            case eWidgetPart.Outer          : return Outer       ;
            case eWidgetPart.Frame          : return Frame       ;
            case eWidgetPart.Inner          : return Inner       ;
            case eWidgetPart.Padding        : return Padding     ;
            case eWidgetPart.ClientBounds   : return ClientBounds;
            default                         : return null;          //fall-through means invalid specification: throw??
        }
    }

} //WidgetMetrics



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Each dimension of a [Widget] has an associated Alignment Specification.
*
* Alignment takes on one of two distinct variations (for any given side/dimension being aligned):
*
* 1) by default, if [objToAlignTo] *is not* specified (null), we wish to align a Widget's
* dimension to its parent Widget's specified ClientBounds (see: [Widget.getClientBounds] method).
* i.e.,  Widget.metrics.Margin (aka, WidgetBounds) or the bounds of the entire
* (viewable portion) of our application "canvas" (part showing in browser window).
*
*   e.g., Align (to our container's bounds; aka parent-clientwidget-bounds)...
*   here we align Top of this Widget to Top (per WidgetBounds) of its container:
*       Align.T = {Dimension:eSides.T}
*
* 2) if [objToAlignTo] *is* specified, we wish to align to a Sibling's Bounds as any of
* Sibling.Metrics.[eWidgetParts][AlignToPoint; i.e., LTRBCxCy]
*
*   e.g., Align (to Sibling value(s))...
*   here we align Right side  of this Widget to Left (per Frame bounds) of Sibling:
*       Align.R = {objToAlignTo:SiblingWidget1, Part:eWidgetPart.Frame, Dimension:eSides.L}
*
* ---
* When values potentially affecting alignment are set, we fire an optional callback method,
* so that we can setup things like mouse handlers, cursor changes, and such that
* reference objects not available to use from within this class (e.g., SVG elements)
*
* ---
* ## Notes:
* ### Crucial Note 1:
* Referenced sibling(s) to align to must be earlier in object-creation order
* (and thus, earlier in SVG nodelist)!
*
* ### Note 2: Default Values Discussion
* * objToAlignTo: null, which indicates use of a Widget's container for alignment.
* * widgetpart: Margin (aka, Widgetbounds).
* * dimension: none, which indicates no specific alignment to perform.
*
* ### Note 3:
* DimensionValue is *internal to object* only. This is a storage variable for holding
* calculated value, once obtained after computations, per Alignment specs.
*
* ---
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class AlignSpec {
    Widget          _objToAlignTo   = null;
    int             _part           = eWidgetPart.Margin;    //enumeration eWidgetPart (int); by default, Widget-boundary is the part being aligned to something
    int             _dimension      = eSides.None;           //enumeration eSides (int); the Side(of objToAlignTo if not null, or container side otherwise) to which we are aligning was Dimension.
    num             dimensionValue  = 0.0;
    ChangeHandler   changeHandler;

    AlignSpec() {
    }

    //helper
    void resetAlignSpec() {
        _objToAlignTo   = null;
        _part           = eWidgetPart.Margin;
        _dimension      = eSides.None;
        dimensionValue  = 0.0;
    }

    Widget get objToAlignTo => _objToAlignTo;
    void set objToAlignTo(newObj) {
        if ((newObj != null) && (newObj is! Widget)) {
            throw new InvalidTypeException('AlignSpec.objToAlignTo property invalid value: object being Aligned to not an instance of Widget.',  'Widget', newObj);
        }

        if ((newObj != null) && (_objToAlignTo != null) && (newObj.InstanceName == _objToAlignTo.instanceName)) return; //no change

        _objToAlignTo   = newObj;
        dimensionValue  = 0.0;
        if (changeHandler != null) {changeHandler();}
    }

    //Part : expects a valid value from the enumeration eWidgetPart (int)
    int  get part       => _part;
    void set part(int newPart) {
        if (newPart != _part) {
            _part           = newPart;
            dimensionValue  = 0.0;
            if (changeHandler != null) {changeHandler();}
        }
    }

    //Dimension : expects a valid value from the enumeration eSides (int)
    int  get dimension  => _dimension;
    void set dimension(int newDimension) {
        if (newDimension != _dimension) {
            _dimension      = newDimension;
            dimensionValue  = 0.0;
            if (changeHandler != null) {changeHandler();}
        }
    }


} //class AlignSpec



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* This class simply wraps up one [AlignSpec] object per align-able Dimension available
* to each [Widget].  The [Widget] exposes this as [Widget.align].  There should not be
* any need to instantiate this class outside of the Widget.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class WidgetAlignment {
    List<AlignSpec> alignSpecs;
    AlignSpec T     = null;
    AlignSpec R     = null;
    AlignSpec B     = null;
    AlignSpec L     = null;
    AlignSpec CX    = null;
    AlignSpec CY    = null;

    void clearAlignsOnAxisX() {
        R.resetAlignSpec();
        L.resetAlignSpec();
        CX.resetAlignSpec();
    }

    void clearAlignsOnAxisY() {
        T.resetAlignSpec();
        B.resetAlignSpec();
        CY.resetAlignSpec();
    }

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    CONSTRUCTOR
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    WidgetAlignment() :
        alignSpecs  = new List<AlignSpec>(),
        T   = new AlignSpec(),
        R   = new AlignSpec(),
        B   = new AlignSpec(),
        L   = new AlignSpec(),
        CX  = new AlignSpec(),
        CY  = new AlignSpec()
    {
        //Place references to our align specs into a list for easy iteration
        alignSpecs.add(T );
        alignSpecs.add(R );
        alignSpecs.add(B );
        alignSpecs.add(L );
        alignSpecs.add(CX);
        alignSpecs.add(CY);
    }

    AlignSpec operator [] (String part) => _getPart(part);

    AlignSpec _getPart(String part) {
        switch (part) {
            case 'T':   return T;
            case 'R':   return R;
            case 'B':   return B;
            case 'L':   return L;
            case 'CX':  return CX;
            case 'CY':  return CY;
        }
    }
}



/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: BORDER-RELATED CLASSES and ENUMERATIONS

See comments on WidgetBorders class for how these classes fit together.
███████████████████████████████████████████████████████████████████████████████████████████
*/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* The available border styles are base on the [W3C border styles](http://www.w3.org/TR/CSS2/box.html#border-style-properties)
* for the most part, with the addition of Raised / Lowered (being a Windows/Delphi type style).
*
* Notice that None and Solid are the only applicable types for the Frame widget-part/border,
* as that is a single-line-per-side border part and is intended to be a solid-fill
* (when used).  The other styles apply to the Inner and Outer borders/widget-parts, since
* those implement a (potential) two-line-per-side ability (depending on style) in addition
* to the fact that is where these styles make the most visual sense.
*
* The EffectsLineCount array indicates how many strokes(lines) are used to create effect.
*
* ## CRITICAL NOTE:
* [WidgetBorderSide.borderStyleSpecs], a const map in [WidgetBorderSide] class, must be kept
* in-sync with this enumeration, such that indexing into borderStyleSpecs array for a given
* BorderStyle returns desired information.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class eBorderStyle {
    static final int None     = 0;
    static final int Solid    = 1;
    static final int Groove   = 2;
    static final int Ridge    = 3;
    static final int Outset   = 4;
    static final int Inset    = 5;
    static final int Double   = 6;  //a bit meaningless to us -- Solid with > 1px width achieves same thing essentially
    static final int Raised   = 7;  //virtual (non-CSS type)
    static final int Lowered  = 8;  //virtual (non-CSS type)

    static final List<String> Names = const ['none', 'solid', 'groove', 'ridge', 'outset', 'inset', 'double', 'raised', 'lowered' ];
    static final List<int>    EffectsLineCount = const [0, 1, 2, 2, 1, 1, 1, 2, 2 ];
}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* There exists one instance of this Class for each Side (T/R/B/L) of a [WidgetBorder].
*
* References to the SVG line element(s) applicable to the border side (if any) are also
* maintained within.
*
* ---
* ## Effects discussion:
* Certain [eBorderStyle] "effects" of raised, lowered, etc. can be applied to the inner/outer
* borders.  The effects are achieved by using two side-by-side lines with varied colors.
* In cases where we need two lines, there will be an Exterior-Facing-Line
* (relative to entire widget) and an Interior-facing line. Each ine will be of the same Width.
*
* Inner/Outer borders with potential standard "styles" have additional logic due to the
* possibility them being either a single-line or double-line border construct.
* Our predefined styles make the most sense with Widths of 1.0 or 2.0 stroke-width total,
* where double-line borders use 1.0 each for light/dark highlights to achieve effects.
* But, we allow user to choose wider effect if desired, and we halve the stroke-width
* of each line in a dual-line border style.
*
* Mid-point (mid-width) of Stroke-Width is used for calculations.
*
* ---
* ## borderStyleSpecs discussion:
* When drawing a "border" effect, there are two potential lines-per-border-side that
* comprise an effect; lets call the lines "exterior (e)" and "interior (i)", with exterior
* positioned closer to the outside (of object getting a border) than the interior line.
* Then, when coloring these lines, the coloration of the *top & left8 (TL) lines will be
* the same; and, the coloration for the *bottom & right* (BR) lines will be the same.
*
* For each TL and BR line-pair (e/i), the tone difference (if any) between e/i make
* us perceive 3D effects like an apparent "grooved" or "ridged" line.  And, when
* we view an object with a difference between TL and BR line-styles (if any), we
* further perceive an entire object to be raised or lowered relative to its surroundings.
*
* To simplify coloring of borders to achieve desired visual effects,
* the [borderStyleSpecs] array maintains color-offset values.
* Naming: TLe = TL(top & left)e(xterior), etc.
*
* Some effects use only 1-line per side to achieve their look,
* while others use two lines.  When only 1 line is used for effect, the "e" pair
* values are what matters.  The [eBorderStyle] determines how many lines,
* and thus line-pair values, will be used in drawing the border.
*
* NOTE: since our Primary/Secondary available SVG Line Elements are not the "exterior"
* and "interior" lines for the OUTER border like they are for the INNER border, we have
* additional logic to determine which SVG line is the "e" and "i".  See code for notes.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class WidgetBorderSide {
    int         borderType      = eWidgetPart.None;     //enumeration eWidgetPart (int); use as quick reference to what type of border this group of sides is for
    int         side            = eSides.None;          //enumeration eSides (int); quick ref so we know which side of border this side is on
    num         _width          = 0.0;
    String      opacity         = '1.0';                //Expects a decimal value between zero (transparent) and one (totally opaque).
    String      color           = 'black';
    int         _style          = eBorderStyle.None;    //enumeration eBorderStyle (int)
    SVGElement  lineElement1    = null;                 //reference to SVGLineElement
    SVGElement  lineElement2    = null;                 //reference to [optional] SVGLineElement for double-stroke border-types (effects)
    bool        isSpacingOnly   = false;                //true only for "virtual" borders (margin/padding)
    //String          effect          = '';                   //TODO: any "3D" filter look, etc.

    //Line begin/end (X,Y) pairs (start/finish); store line endpoints for respective SVG line elements
    Line        line1;
    Line        line2;


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Our specs are a "shift-from-black" matrix (see source-code for full details);
    * works for our non-black color-shifting also.
    * When starting with black, this yields standard Windows(Delphi)-like styling of each
    * border style.
    *
    * The only styles available to Frame are none/solid; and, the solid color here is just
    * a placeholder, as it does not alter the color a user specifies for a solid border.
    * See class comments for  details about how the other specs here work to create effects.
    *
    * ### Shift-Value notes:
    * The amount shifted from zero/black were based on these color's relative values, and
    * we apply the relative differences to each color-channel (R/G/B) when creating effect:
    *
    *   * 105 = 'dimgray'
    *   * 128 = 'gray'
    *   * 255 = 'white'
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    static final Map<String, Map<String, int>> borderStyleSpecs =
        const   {
            'none'      : const {'TLe':0,   'BRe':0,    'TLi':0,    'BRi':0     },
            'solid'     : const {'TLe':105, 'BRe':105,  'TLi':0,    'BRi':0     },
            'groove'    : const {'TLe':105, 'BRe':255,  'TLi':255,  'BRi':105   },
            'ridge'     : const {'TLe':255, 'BRe':105,  'TLi':105,  'BRi':255   },
            'outset'    : const {'TLe':255, 'BRe':105,  'TLi':0,    'BRi':0     },
            'inset'     : const {'TLe':105, 'BRe':255,  'TLi':0,    'BRi':0     },
            'double'    : const {'TLe':105, 'BRe':105,  'TLi':105,  'BRi':105   },
            'raised'    : const {'TLe':128, 'BRe':0,    'TLi':255,  'BRi':105   },
            'lowered'   : const {'TLe':105, 'BRe':255,  'TLi':0,    'BRi':128   }
        };


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Getters/Setters
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    num     get width   => _width;

    void    set width(num newWidth) {
        newWidth = (newWidth == null ? 0 : newWidth);
        if (!isSpacingOnly) {
            _width = ( (newWidth < 0 ) ? 0.0 : newWidth);  //Border must have non-negative width if it is a line
        } else {
            _width = newWidth;  //margins & padding can allow negative values
        }
    }

    //When calculating line-positions, stroke line-center will be adjusted by 1/2 its width when border uses just one line,
    //and when using two lines, the line-centers are at 1/4 and 3/4 of total border width. So, pass in 1, 2, or 3 to get adjuster.
    num     getStrokeInset(num quarterCount) => _width / 4.0 * quarterCount;


    int     get style   => _style;  //enumeration eBorderStyle (int)

    void    setStyle(String newStyle) {
        if ( (borderType == eWidgetPart.Margin) || (borderType == eWidgetPart.Padding)) return; //default of none is only possible value

        if ( (newStyle == null) || (newStyle == 'none') || (newStyle == '')) {
            _style = eBorderStyle.None;
            return;
        }

        //only valid styles for frame are solid or none; we eliminated none-condition already.
        if (borderType == eWidgetPart.Frame) {_style = eBorderStyle.Solid;}

        //we are working with (outer/inner); these are potentially double-lined-borders
        if (eBorderStyle.Names.indexOf(newStyle) > -1) {
           //set if we find in our enum
           _style = eBorderStyle.Names.indexOf(newStyle);

           return;
        }

        //any other untrapped border-style condition
        _style = eBorderStyle.None;
    } //setStyle



    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Call this method to update the SVG Line Element(s) based on our latest object property
    values that influence the SVG drawing.
    
    NOTE: stroke-linecap=("round" or "square") was REQUIRED in order to get final corner 
    "joins" correct without adjusting coordinates. Otherwise, you need to adjust final 
    coordinate to not inset (lengthwise) for stroke-width if bevel or no linejoin specified.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    void updateBorderLineElements() {
        String displayAttrValLine1  = ( ((_width != 0.0) && (opacity != '0.0') && (_style > eBorderStyle.None)) ? 'inherit' : 'none');
        String displayAttrValLine2  = ( ((_width != 0.0) && (opacity != '0.0') && (eBorderStyle.EffectsLineCount[_style] == 2)) ? 'inherit' : 'none');
        String colorValue1 = color;
        String colorValue2 = color;
        String sStyleName  = eBorderStyle.Names[_style];

        Color lineColor;
        lineColor = new Color.fromBrowserRBGString(colorValue1);

        //print ("BorderType =${eWidgetPart.Names[BorderType]} Style=${eBorderStyle.Names[_Style]} RGB=${LineColor.FormattedRGBString()} Width=${_Width} EffectsLineCount=${eBorderStyle.EffectsLineCount[_Style]} SplitWidth=${_Width / eBorderStyle.EffectsLineCount[_Style]}")  ;
        //any style other than "solid" indicates use of our predefined borderspecs (vs. color-coordinated-shifting-attempt); use BLACK color to obtain typical grey-scale Windows-like effects.
        if (_style > eBorderStyle.Solid) {
            if (eBorderStyle.EffectsLineCount[_style] == 2) {
                switch (side) {
                    case eSides.L   :
                    case eSides.T   : {lineColor.shiftColor(((borderType == eWidgetPart.Inner) ? borderStyleSpecs[sStyleName]['TLe'] : borderStyleSpecs[sStyleName]['TLi'])); break;}
                    case eSides.R   :
                    case eSides.B   : {lineColor.shiftColor(((borderType == eWidgetPart.Inner) ? borderStyleSpecs[sStyleName]['BRe'] : borderStyleSpecs[sStyleName]['BRi'])); break;}
                }
            } else {
                switch (side) {
                    case eSides.L   :
                    case eSides.T   : {lineColor.shiftColor(borderStyleSpecs[sStyleName]['TLe']); break;}
                    case eSides.R   :
                    case eSides.B   : {lineColor.shiftColor(borderStyleSpecs[sStyleName]['BRe']); break;}
                }
            }
            colorValue1 = lineColor.formattedRGBString();
        }

        setSVGAttributes(lineElement1, {
            'x1'            : line1.x1.toStringAsFixed(1),
            'y1'            : line1.y1.toStringAsFixed(1),
            'x2'            : line1.x2.toStringAsFixed(1),
            'y2'            : line1.y2.toStringAsFixed(1),
            'display'       : displayAttrValLine1,
            'fill'          : 'none',
            'stroke'        : colorValue1,
            'stroke-opacity': opacity,
            'stroke-linecap': 'round',  //TODO: here and Line2: Only the OUTER-MOST rendered border can be "rounded" without causing tiny "holes" in corners of borders inside of it, since inner-stroke-edge is squared (i.e., not a radius), since using lines (vs. rect).
            'stroke-width'  : '${(_width / eBorderStyle.EffectsLineCount[_style]).toString()}px'
            //'filter' -- see below notes about adding effect(s)
        });

        //TODO: if (Effect): Which side(s) to apply effect to? Should this be per-side, or move effect to border level?
        //    The following works for FireFox... and, no need for <use xlink:href="../resources/standard-filters.svg#Effect_3D"/> in SVG appcontainer doc. odd.
        //    line.attributes['filter'] = 'url(../resources/standard-filters.svg#Effect_3D)';
        //
        //    But, for Chrome browser, must define filter INSIDE our Application' container SVG Element
        //    (see: [Application.canvas] property and [Application] class dartdoc details), and then reference as follows:
        //    line.attributes['filter'] = 'url(#Effect_3D)';
        //    http://code.google.com/p/chromium/issues/detail?id=109212 -- BUG REPORT 2-23-2012 (I COMMENTED ON IT); Please "star" this in hopes it then gets fixed.

        if (eBorderStyle.EffectsLineCount[_style] < 2 ) {
            //We take time to set the display attribute only because there is a slight chance a style-change has occured where we went from line2 showing to not.
            if ( (borderType == eWidgetPart.Inner) || (borderType == eWidgetPart.Outer) ) {
                lineElement2.attributes['display'] = displayAttrValLine2;
            }
            return;
        }

        //restore color to original state prior to potential color-shifting.
        lineColor.loadFromRGBString(colorValue2);

        if (_style > eBorderStyle.Solid) {
            switch (side) {
                case eSides.L   :
                case eSides.T   : {lineColor.shiftColor(((borderType == eWidgetPart.Inner) ? borderStyleSpecs[sStyleName]['TLi'] : borderStyleSpecs[sStyleName]['TLe'])); break;}
                case eSides.R   :
                case eSides.B   : {lineColor.shiftColor(((borderType == eWidgetPart.Inner) ? borderStyleSpecs[sStyleName]['BRi'] : borderStyleSpecs[sStyleName]['BRe'])); break;}
            }
            colorValue2 = lineColor.formattedRGBString();
        }

        setSVGAttributes(lineElement2, {
            'x1'            : line2.x1.toStringAsFixed(1),
            'y1'            : line2.y1.toStringAsFixed(1),
            'x2'            : line2.x2.toStringAsFixed(1),
            'y2'            : line2.y2.toStringAsFixed(1),
            'display'       : displayAttrValLine2,
            'fill'          : 'none',
            'stroke'        : colorValue2,
            'stroke-opacity': opacity,
            'stroke-linecap': 'round',
            'stroke-width'  : '${(_width / eBorderStyle.EffectsLineCount[_style]).toString()}px'
        });

    } //..._UpdateBorderLineElement




    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CONSTRUCTORS
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Constructs a WidgetBorderSide object with appropriate SVG line element(s) required
    * by a border.
    *
    * ### Parameters
    *   * [eWidgetPart] borderType: denormalized information for convenience; enumeration value as [:int:].
    *   * [eSides] side: denormalized info; enumeration value as [:int:] indicating T/R/B/L.
    *   * [SVGElement] lineElement1: the SVG line element this side renders into.
    *   * (optional) [SVGElement] lineElement2: the SVG line element available to dual-line borders (inner/outer);
    *   optional parm on .line() constructor since frame only ever uses single line.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    WidgetBorderSide.line(this.borderType, this.side, this.lineElement1, [this.lineElement2] ) :
        line1 = new Line.zeros(),
        line2 = new Line.zeros()
    {
        isSpacingOnly   = false;
    }

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Constructs a WidgetBorderSide object for "spacing" type borders (i.e., margin / padding).
    * See .line constructor for parameter information.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    WidgetBorderSide.spacing(this.borderType, this.side) {
        isSpacingOnly   = true;
    }

} //class WidgetBorderSide




//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Encapsulates all four [WidgetBorderSide] objects (T/R/B/L) needed to fully define a single
* [borderType] within [WidgetBorders].
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class WidgetBorder {
    int                 borderType  = eWidgetPart.None;     //enumeration eWidgetPart (int); quick reference to what type of border this group of sides is for
    SVGElement          borderGroupElementRef   = null;     //the SVG Group hierarchically above the group of lines comprising all side(s) of a border
    WidgetBorderSide    T   = null;
    WidgetBorderSide    R   = null;
    WidgetBorderSide    B   = null;
    WidgetBorderSide    L   = null;

    //denorm from constructor scope for convenience
    String              _instanceNameAndType   = '';
    int                 _part   = eWidgetPart.None;         //enumeration eWidgetPart (int)

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Helper method with obvious intent
    Parameters:
    - side : expects a valid value from the enumeration eSides (int)
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _setLineID(SVGElement LineElement, int side, [strokeNumSuffix = '']) {
        LineElement.attributes = {
            'id'        : "${_instanceNameAndType}_Border_${eWidgetPart.Names[_part]}_${eSides.Names[side.toString()]}${strokeNumSuffix}",
            'display'   : 'inherit'
        };
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Get various stroke midpoints for T/L/B/R Line(s) per specified [bounds].
    * Assume each line is "W" wide. For single-line border-style border-line(s),
    * set mid-thickness-point of each line to W/2 inset from bounding rect.
    * For borders comprised of potentially two lines (inner/outer borders) and with a
    * two-line border-style (effect), each line will be W/2 thick, but the mid-thickness-point
    * of each line will be inset either W/4 or 3W/4 (i.e., parallel to each other, and taking
    * up W total width between them).
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    //TODO: assert() if bounding-rect is too small to hold defined border(s) of chosen width/style?
    //or, does it make sense to just not draw the portion that extends "off" the bounding-rect?
    //
    //NOTE: it is realized that the if/then logic considerations for EffectsLineCount = 0
    //should be separate (to avoid unnecessary calcs), but it made if structure overly complex.
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void updateBorderSideStrokeCoordinatesFromBounds(ObjectBounds bounds) {
        //get out of here if border has no lines
        if (eWidgetPart.LineCount[borderType] == 0) return;

        num tStrokeMidY =   0.0;
        num rStrokeMidX =   0.0;
        num bStrokeMidY =   0.0;
        num lStrokeMidX =   0.0;

        //Begin with our primary line, regardless of border line count; treat zero-line (none) like 1 for simplicity for now
        if (eBorderStyle.EffectsLineCount[T.style] <= 1) {
            //single-line border
            tStrokeMidY =   bounds.T + T.getStrokeInset(2.0);
        } else {
            //two-line border; must be either Inner or Outer border since only those types have double-line option
            tStrokeMidY =   bounds.T + ((borderType == eWidgetPart.Inner) ? T.getStrokeInset(1.0) : T.getStrokeInset(3.0));
        }

        if (eBorderStyle.EffectsLineCount[R.style] <= 1) {
            rStrokeMidX =   bounds.R - R.getStrokeInset(2.0);
        } else {
            rStrokeMidX =   bounds.R - ((borderType == eWidgetPart.Inner) ? R.getStrokeInset(1.0) : R.getStrokeInset(3.0));
        }

        if (eBorderStyle.EffectsLineCount[B.style] <= 1) {
            bStrokeMidY =   bounds.B - B.getStrokeInset(2.0);
        } else {
            bStrokeMidY =   bounds.B - ((borderType == eWidgetPart.Inner) ? B.getStrokeInset(1.0) : B.getStrokeInset(3.0));
        }

        if (eBorderStyle.EffectsLineCount[L.style] <= 1) {
            lStrokeMidX =   bounds.L + L.getStrokeInset(2.0);
        } else {
            lStrokeMidX =   bounds.L + ((borderType == eWidgetPart.Inner) ? L.getStrokeInset(1.0) : L.getStrokeInset(3.0));
        }

        //if Top side exists
        if (T.width > 0.0 ) {
            T.line1.x1 = lStrokeMidX;
            T.line1.y1 = tStrokeMidY;
            T.line1.x2 = rStrokeMidX;
            T.line1.y2 = tStrokeMidY;
        }

        //if Left side exists
        if (L.width > 0.0 ) {
            L.line1.x1 = lStrokeMidX;
            L.line1.y1 = tStrokeMidY;
            L.line1.x2 = lStrokeMidX;
            L.line1.y2 = bStrokeMidY;
        }

        //if Right side exists
        if (R.width > 0.0 ) {
            R.line1.x1 = rStrokeMidX;
            R.line1.y1 = tStrokeMidY;
            R.line1.x2 = rStrokeMidX;
            R.line1.y2 = bStrokeMidY;
        }

        //if Bottom side exists
        if (B.width > 0.0 ) {
            B.line1.x1 = lStrokeMidX;
            B.line1.y1 = bStrokeMidY;
            B.line1.x2 = rStrokeMidX;
            B.line1.y2 = bStrokeMidY;
        }

        if (eWidgetPart.LineCount[borderType] < 2) return;

        //two-line border; must be either Inner or Outer border since only those types have double-line option
        //NOTICE: This second line has the opposite offset adjustment as the first line
        tStrokeMidY =   bounds.T + ((borderType == eWidgetPart.Inner) ? T.getStrokeInset(3.0) : T.getStrokeInset(1.0));
        rStrokeMidX =   bounds.R - ((borderType == eWidgetPart.Inner) ? R.getStrokeInset(3.0) : R.getStrokeInset(1.0));
        bStrokeMidY =   bounds.B - ((borderType == eWidgetPart.Inner) ? B.getStrokeInset(3.0) : B.getStrokeInset(1.0));
        lStrokeMidX =   bounds.L + ((borderType == eWidgetPart.Inner) ? L.getStrokeInset(3.0) : L.getStrokeInset(1.0));

        //if Top side exists
        if (T.width > 0.0 ) {
            T.line2.x1 = lStrokeMidX;
            T.line2.y1 = tStrokeMidY;
            T.line2.x2 = rStrokeMidX;
            T.line2.y2 = tStrokeMidY;
        }

        //if Left side exists
        if (L.width > 0.0 ) {
            L.line2.x1 = lStrokeMidX;
            L.line2.y1 = tStrokeMidY;
            L.line2.x2 = lStrokeMidX;
            L.line2.y2 = bStrokeMidY;
        }

        //if Right side exists
        if (R.width > 0.0 ) {
            R.line2.x1 = rStrokeMidX;
            R.line2.y1 = tStrokeMidY;
            R.line2.x2 = rStrokeMidX;
            R.line2.y2 = bStrokeMidY;
        }

        //if Bottom side exists
        if (B.width > 0.0 ) {
            B.line2.x1 = lStrokeMidX;
            B.line2.y1 = bStrokeMidY;
            B.line2.x2 = rStrokeMidX;
            B.line2.y2 = bStrokeMidY;
        }

    }  //updateBorderSideStrokeCoordinatesFromBounds


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CONSTRUCTOR 1

    Parameters:

    InstanceNameAndType = this determines the svg-element-id value for the *group* that will
    hold all sides of the border; we append "_Border" to this value followed by the
    border subtype (part), e.g., "_Frame".  Furthermore, each side within the border subtype
    will further append _T/R/B/L (for respective side) to its own svg-element-id.

    part: enumeration eWidgetPart (int) : obvious. Pass it on to Sides for easy reference.
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    WidgetBorder.line1(String InstanceNameAndType, int part) :
        borderGroupElementRef   = new SVGElement.tag('g'),
        T   = new WidgetBorderSide.line(part, eSides.T, new SVGElement.tag('line') ),
        R   = new WidgetBorderSide.line(part, eSides.R, new SVGElement.tag('line') ),
        B   = new WidgetBorderSide.line(part, eSides.B, new SVGElement.tag('line') ),
        L   = new WidgetBorderSide.line(part, eSides.L, new SVGElement.tag('line') )
    {
        _instanceNameAndType = InstanceNameAndType;
        _part = part;

        //Assign attribute values to SVG elements created in constructor
        setSVGAttributes(borderGroupElementRef, {
            'id'        : "${InstanceNameAndType}_Border_${eWidgetPart.Names[part]}",
            'display'   : 'inherit'
        });

        _setLineID(T.lineElement1, eSides.T);
        _setLineID(R.lineElement1, eSides.R);
        _setLineID(B.lineElement1, eSides.B);
        _setLineID(L.lineElement1, eSides.L);


        //Place our lines within our group
        borderGroupElementRef.nodes.add(T.lineElement1);
        borderGroupElementRef.nodes.add(R.lineElement1);
        borderGroupElementRef.nodes.add(B.lineElement1);
        borderGroupElementRef.nodes.add(L.lineElement1);
        borderType = part;
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CONSTRUCTOR 2
    Very similar to constuctor 1, expect that we are creating TWO lines per side.
    This is done for inner/outer borders that depend on (potentially) using two parallel
    lines per side to create standard effects (BorderStyles).

    Parameters: see constructor 1, noting the fact we additionally extend the SVG ID
    value by "1" or "2"; e.g., _T_1 and _T_2 for Top primary and top secondary respectively.
    The PRIMARY line in dual-border setups is:
        * for OUTER borders, it is the inner-most line (abutting the Frame)
        * for INNER borders, it is the outer-most line (abutting the Frame)

    part: enumeration eWidgetPart (int) : we pass it on to Sides for easy reference.
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    WidgetBorder.line2(String InstanceNameAndType, int part) :
        borderGroupElementRef   = new SVGElement.tag('g'),
        T   = new WidgetBorderSide.line(part, eSides.T, new SVGElement.tag('line'), new SVGElement.tag('line') ),
        R   = new WidgetBorderSide.line(part, eSides.R, new SVGElement.tag('line'), new SVGElement.tag('line') ),
        B   = new WidgetBorderSide.line(part, eSides.B, new SVGElement.tag('line'), new SVGElement.tag('line') ),
        L   = new WidgetBorderSide.line(part, eSides.L, new SVGElement.tag('line'), new SVGElement.tag('line') )
    {
        _instanceNameAndType = InstanceNameAndType;
        _part = part;

        //Assign attribute values to SVG elements created in constructor
        setSVGAttributes(borderGroupElementRef, {
            'id'        : "${InstanceNameAndType}_Border_${eWidgetPart.Names[part]}",
            'display'   : 'inherit'
        });

        _setLineID(T.lineElement1, eSides.T, '1');
        _setLineID(R.lineElement1, eSides.R, '1');
        _setLineID(B.lineElement1, eSides.B, '1');
        _setLineID(L.lineElement1, eSides.L, '1');
        _setLineID(T.lineElement2, eSides.T, '2');
        _setLineID(R.lineElement2, eSides.R, '2');
        _setLineID(B.lineElement2, eSides.B, '2');
        _setLineID(L.lineElement2, eSides.L, '2');

        //Place our lines within our group
        borderGroupElementRef.nodes.add(T.lineElement1);
        borderGroupElementRef.nodes.add(T.lineElement2);
        borderGroupElementRef.nodes.add(R.lineElement1);
        borderGroupElementRef.nodes.add(R.lineElement2);
        borderGroupElementRef.nodes.add(B.lineElement1);
        borderGroupElementRef.nodes.add(B.lineElement2);
        borderGroupElementRef.nodes.add(L.lineElement1);
        borderGroupElementRef.nodes.add(L.lineElement2);
        borderType = part;
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CONSTRUCTOR 3

    This constructor is called for "borders" that are simply spacing: i.e., margin/padding

    part: enumeration eWidgetPart (int) : we pass it on to Sides for easy reference.
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    WidgetBorder.spacing(int part) :
        T   = new WidgetBorderSide.spacing(part, eSides.T ),
        R   = new WidgetBorderSide.spacing(part, eSides.R ),
        B   = new WidgetBorderSide.spacing(part, eSides.B ),
        L   = new WidgetBorderSide.spacing(part, eSides.L )
    {
        borderType = part;
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Operator
        side : expects a valid value from the enumeration eSides (int)
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    WidgetBorderSide operator [] (int side) => _getPart(side);

    WidgetBorderSide _getPart(int side) {
        switch (side) {
            case eSides.T   : return T;
            case eSides.R   : return R;
            case eSides.B   : return B;
            case eSides.L   : return L;
            default         : return null;  //fall-through means invalid specification: throw??
        }
    }

} //class WidgetBorder



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Class that encapsulates all the multiple border [WidgetBorder] parts that can be
* rendered for a [Widget]. Each WidgetBorder has four [WidgetBorderSide] objects within.
*
* ---
* # Preface
* Borders are a very substantial piece of functionality related to Visual-effects for all Widgets.
*
* What defines a Widget's look/feel and its resulting ClientRect (usable area inside
* those borders)? The interior-region is simple: it is just a (shaded) rectangular region.
* But, borders are complex if various types of look/feel are to be supported.
*
* E.g., appearances including:
*
*    * Visual Perceptions: Raised, Lowered, Grooved, Ridged per [eBorderStyle];
*    * Rounded (corners);
*    * Optional Side(s) and Thickness varying per side;
*    * Inner and Outer Borders comprised of the above list of options/considerations;
*    * A "frame" between inner and outer borders;
*    * Various effects applied to Border or its parts: (**TODO**) e.g., 3D look, transparency, gradients, shadow, glow, etc.;
*
* ---
* ## Border encapsulation
* Borders are encapsulated in a [Widget], via _borders member of type [WidgetBorders].
* Here are the Border-buildup classes and how they all fit together to make
* Widget Borders possible:
*
*    1. [WidgetBorderSide]: define aspects of each [eSides] of each border, including
*    the encapsulation of SVG Line element(s) needed to draw any visible borders.
*    2. [WidgetBorder]: class comprised of four [WidgetBorderSide] objects.
*    3. [WidgetBorders]: this class that includes all border types (widget-parts)
*    available to a Widget.
*    Margin is outermost "border"... Padding is innermost; see: [eWidgetPart]
*    and/or [WidgetMetrics] for further details.
*
* These various border classes combine to make the features discussed (above: Preface) possible.
*
* ---
* ## Notes
* Margin/Padding are "virtual" borders — just spacing regions (no drawing).
*
* ---
* ## See Also
* * [eWidgetPart]: for detailed discussion of the various border types.
* * [WidgetBorderSide]: for discussion of how positioning of border-lines is performed, etc.
*
* ---
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class WidgetBorders {
    ///Reference to the SVG Group hierarchically above the groups holding each border-subtype.
    SVGElement      allBordersSVGGroupElement   = null;

    WidgetBorder    Margin      = null;
    WidgetBorder    Outer       = null;
    WidgetBorder    Frame       = null;
    WidgetBorder    Inner       = null;
    WidgetBorder    Padding     = null;

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Constructor
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    WidgetBorders(String instanceNameAndType) :
        //NOTE: the following technique only works inside HTML docs (vs. SVG docs), as it is seen as "InnerHtml" and SVG docs don't like this!
        //AllBordersSVGGroupElement   = new SVGElement.svg('<g id="${InstanceNameAndType}_Borders" display="inherit"></g>'),  

        allBordersSVGGroupElement   = new SVGElement.tag('g'),
        Margin      = new WidgetBorder.spacing(eWidgetPart.Margin),
        Outer       = new WidgetBorder.line2(instanceNameAndType, eWidgetPart.Outer),
        Frame       = new WidgetBorder.line1(instanceNameAndType, eWidgetPart.Frame),
        Inner       = new WidgetBorder.line2(instanceNameAndType, eWidgetPart.Inner),
        Padding     = new WidgetBorder.spacing(eWidgetPart.Padding)
    {
        allBordersSVGGroupElement.attributes = {
            'id'        : "${instanceNameAndType}_Borders",
            'display'   : 'inherit'
        };

        //Place our sub-border groups within our overall borders-group
        allBordersSVGGroupElement.nodes.add(Outer.borderGroupElementRef);
        allBordersSVGGroupElement.nodes.add(Frame.borderGroupElementRef);
        allBordersSVGGroupElement.nodes.add(Inner.borderGroupElementRef);
    }

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Operator
        part : expects a valid value from the enumeration eWidgetPart (int)
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    WidgetBorder operator [] (int part) => _getPart(part);

    WidgetBorder _getPart(int part) {
        switch (part) {
            case eWidgetPart.Margin     : return Margin ;
            case eWidgetPart.Outer      : return Outer  ;
            case eWidgetPart.Frame      : return Frame  ;
            case eWidgetPart.Inner      : return Inner  ;
            case eWidgetPart.Padding    : return Padding;
            default                     : return null;      //fall-through means invalid specification: throw??
        }
    }

} //class WidgetBorders


/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: WIDGET-STYLING CLASSES
███████████████████████████████████████████████████████████████████████████████████████████
*/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* A [Widget] maintains a list of these style-able targets ('StyleTarget') in
* its _StylablePropertiesList.
* A Widget can have aspects of its visual presentation styled by CSS, including
* its background, frame, and inner & outer borders, via these targets.
*
* A Widget's [CSSTargetsMap] (exposed as [Widget.classesCSS] property) map *keys* correspond to
* [StyleTarget.targetObject] values; this allows us to determine which selector "class-names"
* (from Widget's classesCSS map-VALUES) will be applied to a targetObject in order to compute
* resulting, post-styled, calcValue for each TargetProperty.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class StyleTarget {

    /**
    * The logical visual sub-component of the Widget that we are styling (e.g., its Frame).
    */
    String  targetObject    = '';

    /**
    * Within a [targetObject], various TargetProperties can be affected by CSS values.
    * Within a targetObject, e.g., the border-style, border-width, and stroke-color properties may be
    * available for styling with CSS.
    *
    * **NOTE:** even though *SVG-specific* PropertyNames show in Chrome's object-inspector (debugger)
    * as non-hyphenated camelCase, our list and lookups must use hyphenated lower-case form
    * (at least for Chrome v18-23+) to get values.
    */
    String  targetProperty  = '';

    /**
    * In the absence of externally-provided (or determinable) value, this is what
    * the [calcValue] will apply to the [targetProperty]; i.e., these are logical
    * defaults for a Widget's styling.
    */
    String  defaultValue    = '';

    /**
    * The value to be assigned to the [targetProperty] as determined by applying
    * CSS class-selector(s), from matches in CSSTargetsMap, to a Widget's
    * [targetObject] / [targetProperty].
    */
    String  calcValue       = null;     //Calculated

    StyleTarget (this.targetObject, this.targetProperty, this.defaultValue);

} //class StyleTarget



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* A map of TargetObject names (KEY) and associated comma-delimited list of CSS Class Names selectors (VALUE)
* pairs that indicate what CSS classes are to be applied to a Widget's StyleTarget.TargetObject in order
* to affect the Calculated values for [StyleTarget.targetProperty] when we apply CSS rules to
* compute a "Styled" widget's values.
*
* The embedded [Map] object is exposed only via specialized methods for proper encapsulation and
* to prevent user from bypassing change-detection logic. Operations like adding to
* or removing from the comma-delim values string are done through methods that detect change
* while also ensuring proper formatting of this string.
*
* ## NOTE
* We must use the *non-comma-delimited equivalent* value (in [Application.getCSSPropertyValuesForClassNames])
* because of how the off-screen class-resolution expects it to be formatted.
* We use the [] operator to access this space-delimited version of value.
*
* ## See Also
* The notes accompanying the [StyleTarget] class help to better understand how this class
* fits into things.
*
* ---
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class CSSTargetsMap {

    /**
    * The "key" for this Map is TargetObject names (aligned with values in our StylablePropertiesList —
    * a list of [StyleTarget] objects).
    * The "value" portion of this Map holds our "AppliedSelectors" (comma-delim class-selectors)
    * to apply to target.
    */
    Map<String, String> _targetObjectsAndSelectors = null;

    /**
    * (optional) a callback method available to perform functionality when
    * CSS styling changes occur.  Useful for triggering Widget metrics recalcs / rendering updates.
    */
    ChangeHandler  changeHandler;

    //Constructor
    CSSTargetsMap();


    ///Easy way to start with fresh map without change-triggering.
    void initialize(Map fromMap) {
        _targetObjectsAndSelectors = new Map.from(fromMap);

        //remove any extraneous spaces
        for (String key in _targetObjectsAndSelectors.getKeys()) {
            _targetObjectsAndSelectors[key] = _targetObjectsAndSelectors[key].replaceAll(' ', '');
        }
    }


    ///Useful for debugging purposes.
    String getMapAsString() => _targetObjectsAndSelectors.toString();


    ///Clears the Map.
    void clear() {
        _targetObjectsAndSelectors.clear();
        if (changeHandler != null) {changeHandler();}
    }



    /**
    * Returns the value portion of map that contains any Class selector(s),
    * but as *space-delim* version which is critically important in off-screen
    * CSS calcs performed in [Application] object.
    */
    String operator [] (String key) => _getFormattedMapValue(key);

    String _getFormattedMapValue(String key) {
        String sTemp = _targetObjectsAndSelectors[key];
        return (sTemp != null ? _targetObjectsAndSelectors[key].replaceAll(',', ' ') : '');
    }



    ///Set the *entire* appliedSelectors value for a Stylable Target if the key exists; otherwise, ignore.
    void setClassSelectorsForTargetObjectName(String targetName, String appliedSelectors) {
        //remove any extraneous spaces
        appliedSelectors = appliedSelectors.replaceAll(' ', '');

        if (_targetObjectsAndSelectors.containsKey(targetName)) {
            _targetObjectsAndSelectors[targetName] = appliedSelectors;

            if (changeHandler != null) {changeHandler();}
        }
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Add selector(s) in [newSelectors] to an existing Map entry's (with key = [targetName])
    * list of class-selectors (comma-delim).
    *
    * If the key does not exists, ignore the request, as it would be meaningless for styling.
    * The added value(s) must remain unique in the appliedSelectors string.
    * If a change to value portion results from this request, fire the [changeHandler].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void addClassSelectorsForTargetObjectName(String targetName, String newSelectors) {
        if (!_targetObjectsAndSelectors.containsKey(targetName)) return;

        //remove any extraneous spaces
        newSelectors = newSelectors.replaceAll(' ', '');

        List<String> existingSelectorsAsList    = _targetObjectsAndSelectors[targetName].split(',');
        List<String> newSelectorsAsList         = newSelectors.split(',');
        List<String> addTheseSelectorsList      = new List<String>();
        bool hasChanged = false;

        for (String sSelector in newSelectorsAsList) {
            if (existingSelectorsAsList.indexOf(sSelector) == -1) {
                //our Selectors do not already include...
                hasChanged = true;
                addTheseSelectorsList.add(sSelector);
            }
        }

        if (!hasChanged) return;

        //add any newly-found selectors and convert this list back into a single comma-delim string value...
        existingSelectorsAsList.addAll(addTheseSelectorsList);

        StringBuffer sbTemp = new StringBuffer();
        int i = 0;
        for (String sSelector in existingSelectorsAsList) {
            if (i > 0) {sbTemp.add(',');}
            sbTemp.add(sSelector.trim());
            i++;
        }

        _targetObjectsAndSelectors[targetName] = sbTemp.toString();

        if (changeHandler != null) {changeHandler();}

    } //AddClassSelectorForTargetObjectName


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Remove selector(s) in [delSelectors] from an existing Map entry's (with key = [targetName])
    * list of class-selectors (comma-delim).
    * If the key does not exists, ignore the request, as it would be meaningless for styling.
    * If a change to value portion results from this request, fire the [changeHandler].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void removeClassSelectorsForTargetObjectName(String targetName, String delSelectors) {
        if (!_targetObjectsAndSelectors.containsKey(targetName)) return;

        //remove any extraneous spaces
        delSelectors = delSelectors.replaceAll(' ', '');

        List<String> existingSelectorsAsList    = _targetObjectsAndSelectors[targetName].split(',');
        List<String> delSelectorsAsList         = delSelectors.split(',');

        bool hasChanged = false;

        for (String sSelector in delSelectorsAsList) {
            if (existingSelectorsAsList.indexOf(sSelector) > -1) {
                //found one to remove...
                hasChanged = true;
                existingSelectorsAsList.removeRange(existingSelectorsAsList.indexOf(sSelector), 1);
            }
        }

        if (!hasChanged) return;

        //convert any values remaining in our list back into a single comma-delim string value...
        StringBuffer sbTemp = new StringBuffer();
        int i = 0;
        for (String sSelector in existingSelectorsAsList) {
            if (i > 0) {sbTemp.add(',');}
            sbTemp.add(sSelector.trim());
            i++;
        }

        _targetObjectsAndSelectors[targetName] = sbTemp.toString();

        if (changeHandler != null) {changeHandler();}

    } //RemoveClassSelectorsForTargetObjectName


} //class CSSTargetsMap


/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: EVENT-HANDLING CLASSES
███████████████████████████████████████████████████████████████████████████████████████████
*/



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Centralize the storage of event-callback handlers assigned to various [Widget] events.
* Custom event-processing (user provided) code is accessible via these callbacks, and
* this is what makes for highly-extensible event-based programs using Widgets.
* These callbacks will include types like, e.g.,:
*
*    * [NotifyEvent] — the most generic event handler type.
*    * [MouseNotifyEvent] — a more specific event handler for mouse-related activities.
*
* Within a [Widget] or other class that implements events, an instance of this
* EventsProcessor class (named "on") exists, like [Widget.on].
*
* Then, similar to native Dart event handling, our Widget can use the notation:
*
*     Widget.on.eventNameHere = handler           ...to assign a handler.
*     Widget.on.eventNameHere(new eventobject())  ...to fire assigned event.
*
* *Note:* syntactic sugar of eventNameHere.add/remove(handler) has not been implemented.
*
* Assigning *null* to a handler removes a handler and replaces with reference to an empty-method;
* this takes the place of having to always test for null prior to attempting callback-firing,
* but if this turns out to have a performance penalty (since all code creating and passing
* a "new" event notification object), the approach can be re-examined.
*
* ---
* ## Discussion
* ### Events Overview
* Events are simply properties whose values are functions to execute when something occurs.
* These events are surfaced in a [Widget] and/or child-classes where appropriate.
* When implemented in sub-classes, the event method *may* need to call
* inherited event method code (i.e., via "super") as part of their own event-processing,
* or they may completely override, depending on needs.
*
* ### Event Flow (in Widget Implementation)
* There are two distinct category of events within widgets:
*
*    1. those events which closely parallel "native" (browser / SVG HTML DOM) events and
* interact via those native events; e.g., [Widget.onClick]
*    2. completely custom Widget-specific events; e.g., [Widget.onShow]
*
* The first category of events will be discussed in detail here, and the second category
* is a simplified version of the same, but without the SVG-native-event interaction.
*
* When SVG elements are created as part of a Widget, native-SVG-event-handlers are created
* on some of those SVG Elements,  e.g.:
*
*     someSvgGroupElement.on.click.add(mouseClick)
*
* ...where 'mouseClick' is the standard widget-class method [Widget.mouseClick] .
* This directs the native SVG event-handlers to execute a standard Widget method when an
* SVG event occurs — *thus effectively moving further event-processing control into the
* Widget*.
*
* Once the Widget's internal standard event handler has been triggered (e.g., mouseClick),
* it in turn will execute any standard/default processing within that method while also
* dispatching the event, at the appropriate point within the standard processing, via the
* optionally-defined user-provided callback(s) that have been assigned to the
* associated "on(EventNameHere)" properties. E.g., within the [Widget.mouseClick] event
* code, we process any potential user-assigned click event code via:
*
*     _on.mouseClick(new MouseNotifyEventObject(this, event));
*
* That call passes a reference to the firing-Widget via "this", and passes on native [MouseEvent]
* information via "event", to any user-assigned mouse-click event-handler method.
*
* ## See Also
*    * [W3C SVG Native Events Reference](http://www.w3.org/TR/SVG/interact.html#SVGEvents) —
* enumerates the most common events we will need for interacting with our SVG Widgets.
*    * [Dart Language Event Listener List specification](http://api.dartlang.org/docs/continuous/dart_html/EventListenerList.html) —
* for comparison purposes.
*    * [Mozilla Developer Reference to DOM element.addEventListener](https://developer.mozilla.org/en-US/docs/DOM/element.addEventListener) —
* discusses things like "capture" (of events) and how the optional useCapture parameter in .on.add/remove(handler, [useCapture])
* works.  Essentially, useCapture can be summarized as follows:
*
*     useCapture = false (default): events fire from from inner-most element-handler (under pointer position) outward
*
*     useCapture = true: fires from outer-widgets (under pointer position) inward
*
* ---
* ## Pending Potential Enhancement (TODO)
* There is a somewhat high probability that this class will be extended to include a [List<>]
* of EventOptionObjects, where each option has a pre-set *internal* method callback
* for change-handling... whereby we can "wire" appropriate SVG objects (or *unwire* if null).
*
* ---
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class EventsProcessor {
    //An empty method that satisfies return requirements (method signature)
    void _nullEvent(NotifyEventObject eventObj) {return;}

    //An empty method that satisfies return requirements (method signature)
    void _nullMouseEvent(MouseNotifyEventObject eventObj) {return;}

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    CUSTOM WIDGET-CLASS event hooks (i.e., NOT truly native to browser interaction)
    This batch of event-pointers is used for callbacks-hooks from within our Widget's
    various routines.

    TODO: IMPLEMENT
    NotifyEvent         _onResize           = null;
    NotifyEvent         _onScroll           = null;
    NotifyEvent         _onZoom             = null;
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    NotifyEvent         _onAlign            = null;
    NotifyEvent         _onHide             = null;
    MouseNotifyEvent    _onMove             = null;
    NotifyEvent         _onBeforeShow       = null;
    NotifyEvent         _onShow             = null;

    ///Widget-specific event fired toward end of [Widget.reAlign] method when an alignment operation occurs.
    NotifyEvent         get align               => (_onAlign == null) ? _nullEvent : _onAlign;
    void set align(NotifyEvent handler)         {_onAlign = handler;}

    ///Widget-specific event fired at the beginning of the [Widget.show] method, prior to making widget visible.
    NotifyEvent         get beforeShow          => (_onBeforeShow == null) ? _nullEvent : _onBeforeShow;
    void set beforeShow(NotifyEvent handler)    {_onBeforeShow = handler;}

    ///Widget-specific event fired toward the end of the [Widget.hide] method, just before [Widget.widgetState] omits [eWidgetState.Showing].
    NotifyEvent         get hide                => (_onHide == null) ? _nullEvent : _onHide;
    void set hide(NotifyEvent handler)          {_onHide = handler;}

    ///Widget-specific event fired during the [Widget.mouseMove] method, when Widget movement is allowed and has occurred.
    MouseNotifyEvent    get move                => (_onMove == null) ? _nullMouseEvent : _onMove;
    void set move(MouseNotifyEvent handler)     {_onMove = handler;}

    ///Widget-specific event fired toward the end of the [Widget.show] method, just before [Widget.widgetState] includes [eWidgetState.Showing].
    NotifyEvent         get show                => (_onShow == null) ? _nullEvent : _onShow;
    void set show(NotifyEvent handler)          {_onShow = handler;}

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    "NATIVE" event hooks (i.e., native, or closely related, to browser interaction)
    This batch of event-pointers is used for callbacks-hooks; we pass native MouseEvent
    data to callbacks, along with this instance (i.e., "sender" object-initiating-event).
    Our class's default event-handlers (e.g., MouseClick, MouseDown) will call any
    respective user-assigned _OnMouseClick(), _OnMouseDown() event logic at an appropriate
    time from within these default handlers (e.g., before or after we do internal processing).
    Some of these events may be split into "beforeEvent" and "afterEvent" in the future,
    if implementation requirements (especially in sub-classes) merit.

    TODO: IMPLEMENT
    NotifyEvent         _onFocus            = null;
    NotifyEvent         _onLoseFocus        = null;
    MouseNotifyEvent    _onMouseOver        = null;
    MouseNotifyEvent    _onMouseOut         = null;
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    MouseNotifyEvent    _onMouseClick       = null;
    MouseNotifyEvent    _onMouseDown        = null;
    MouseNotifyEvent    _onMouseMove        = null;
    MouseNotifyEvent    _onMouseUp          = null;

    MouseNotifyEvent    get mouseClick              => (_onMouseClick == null) ? _nullMouseEvent : _onMouseClick;
    void set mouseClick(MouseNotifyEvent handler)   {_onMouseClick = handler;}

    MouseNotifyEvent    get mouseDown               => (_onMouseDown == null) ? _nullMouseEvent : _onMouseDown;
    void set mouseDown(MouseNotifyEvent handler)    {_onMouseDown = handler;}

    ///Native event fired during the [Widget.mouseMove] method, when *any* mouse-movement action has occurred over a widget,
    ///regardless of whether the Widget has moved (contrast to the [move] event).
    MouseNotifyEvent    get mouseMove               => (_onMouseMove == null) ? _nullMouseEvent : _onMouseMove;
    void set mouseMove(MouseNotifyEvent handler)    {_onMouseMove = handler;}

    MouseNotifyEvent    get mouseUp                 => (_onMouseUp == null) ? _nullMouseEvent : _onMouseUp;
    void set mouseUp(MouseNotifyEvent handler)      {_onMouseUp = handler;}

} //EventsProcessor



/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: HtmlFO Class
███████████████████████████████████████████████████████████████████████████████████████████
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* An [HtmlFO] encapsulates an HTML Body/Div structure inside an SVG foreignObject and
* allows interaction with Div Element's contents ("innerHTML") via our exposed
* [innerHTML] property.
*
* This class implements provisions for setting [scrollOverflow] preferences to either
* display scrollbars (to allow access to overflow) or simply hide any overflow.
*
* **Critical Note:** See [dart issue 2977: must "wrap" SVG doc in HTML doc to work!](http://code.google.com/p/dart/issues/detail?id=2977)
* I.e., for now, this bug is a blocking bug preventing standalone SVG docs using this
* Class (and classes that implement it, like the HtmlWidget) from working.
*
* ## Discussion and Reason for this Class
* Put bluntly, *SVG text-handling (as of SVG v1.x) is just too darn tough*, since we
* would have to perform *manual* font-metrics calcs (width of each char), then
* calc line-widths, and manually split multi-line text, etc. etc.
*
* *If and when* SVG Version 2.0 comes along with simpler text-handling, we can consider native
* SVG implementation instead of this embedded (HTML) foreign-object approach for text.
*
* If demand merits, we can do the calcs for text internally and replace the FO approach.
*
* HTML Element(s) within a FO are accessible from the Dart-code in outside SVG
* (see project samples directory, Sample 1 for technique).
* TODO: Confirm that the FO can include script references and execute JS and/or Dart from within FO, independent of outer SVG.
*
* ## See Also
*    * [HtmlWidget] is the specialized [Widget] subclass that embeds the [HtmlFO] within it.
*    * [IFrameFO] is similar, but allows loading HTML content from a URL.
*
* ---
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class HtmlFO {
    //These variables obtain their value during createFOStructure
    Widget              _ptrWidget              = null;
    SVGElement          _ptrSVGElementForFO     = null;
    String              _idOfSVGElementForFO    = '';
    bool                _scrollOverflow         = false;  //default to hidden (vs. scroll) of overflow; i.e., clip any visual overflow

    //these hold refs to our created elements, and inner content
    SVGForeignObjectElement _foElementRef       = null;
    Element             _htmlBodyObj            = null;
    Element             _htmlDivObj             = null;
    String              _innerHTMLMarkup        = '';


    //accessors
    SVGElement      get svgFO                   => _foElementRef;
    Element         get htmlBody                => _htmlBodyObj;
    Element         get htmlDiv                 => _htmlDivObj;

    bool            get scrollOverflow          => _scrollOverflow;
    void            set scrollOverflow(bool isOverflowScrollable) {_scrollOverflow = isOverflowScrollable;}

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    innerHTML:
    TODO: NOTE -- issues with setting innerHTML if Widget/subclass not "showing".
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    String          get innerHTML               =>  _innerHTMLMarkup;
    void            set innerHTML(String newHTML) {
        _innerHTMLMarkup        = newHTML;
        _htmlDivObj.innerHTML   = _innerHTMLMarkup;      //TODO: FLAKY YET: SEE DART ISSUE 2977 -- must "wrap" SVG doc in HTML doc to work!
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Creates the following FO / HTML structure within the [Widget] specified by [widget] parameter,
    * within the Widget's client-region (i.e., [Widget.clientSVGElement]).
    *
    *     <foreignObject x="10" y="10" width="100" height="150">  //NOTE: Metrics filled in later
    *         <body>
    *             <div>Contents of this DIV are set via the [innerHTML] property</div>
    *         </body>
    *     </foreignObject>
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void createFOStructure(Widget widget, String innerHTMLMarkup) {
        _ptrWidget              = widget;
        _ptrSVGElementForFO     = widget.clientSVGElement;
        _idOfSVGElementForFO    = _ptrSVGElementForFO.attributes['id'];
        _innerHTMLMarkup        = innerHTMLMarkup;

        _foElementRef.attributes = {
            'display'       : 'inherit',
            //'pointer-events': 'none',   //we want all events to "pass through" this overlay   //TODO: ALLOW SETTING THIS FOR INTERACTIVE HTML CONTROLS SUPPORT
            'id'            : "${_idOfSVGElementForFO}_ContainerFO"
        };

        //TODO: create head/style and allow passing in of stylesheet. default to our outer stylesheet (for placeholder)

        _htmlBodyObj.attributes = {
            'id'            : "${_idOfSVGElementForFO}_ContainerFOBody",
            'style'         : 'border:0; padding:0; margin:0;'   //_ApplicationObject.DefaultFont.Style -- NOTE: TODO: PASS STYLE/Class VALUE(S)
        };

        _htmlDivObj.attributes = {
            'id'            : "${_idOfSVGElementForFO}_ContainerFODiv"
        };

        _htmlDivObj.innerHTML = _innerHTMLMarkup;
        _htmlBodyObj.nodes.add(_htmlDivObj);
        _foElementRef.nodes.add(_htmlBodyObj);

        _ptrSVGElementForFO.nodes.add(_foElementRef);
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Update position and sizing information...
    * See the source-code for important algorithmic notes regarding
    * why we compute the FO position the way we do.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void updateFOMetrics() {
        //trap for strange-order of calls that could try to execute this prior to avail.
        if (_ptrWidget == null) return;

        num    widgetTranslateX = _ptrWidget.translateX;
        num    widgetTranslateY = _ptrWidget.translateY;

        String L       = (_ptrWidget.getClientBounds().L + widgetTranslateX).toString();
        String T       = (_ptrWidget.getClientBounds().T + widgetTranslateY).toString();
        String Width   = _ptrWidget.getClientBounds().Width.toString();
        String Height  = _ptrWidget.getClientBounds().Height.toString();

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Algorithmic note:
        (in Webkit at least) the repaint-region of a *translated* ForeignObject (FO) is not
        calculated / updated properly within an SVG (group), apparently.
        The workaround solution is to essentially "undo"/"reverse" the positional translate
        values of the FO's container SVG G (group) element by:

            1)  applying transform attribute to FO element with opposite value of G's translated
                position.
            2)  adding the G's transform-translate values to X/Y values (origin) of the FO.\
                This was performed above when initializing the L/T values.

        This essentially, in a hacked way, establishes a new clipping-region for the FO --
        something that should have been automatically handled by Webkit I believe.

        TODO: Still need to see if *scale* is affected similarly.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        setSVGAttributes(_foElementRef, {
            'x'             : L,
            'y'             : T,
            'width'         : Width,
            'height'        : Height,
            'transform' : 'translate(${(-widgetTranslateX)},${(-widgetTranslateY)})'
        });

        //Set our div to be "clipped"; allow user to choose hidden or scroll for overflow
        setElementAttributes(_htmlDivObj, {
            'style'         : 'overflow:${(_scrollOverflow ? "auto" : "hidden")}; width:${Width}px; height:${Height}px;'   //TODO: pass in hidden or scroll (overflow) X/Y
        });
    }  //UpdateFOMetrics


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * **Note:** after construction, [createFOStructure] will need called, and the
    * [updateFOMetrics] will need to be called during [Widget] alignment.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    HtmlFO() :
        _foElementRef   = new SVGElement.tag('foreignObject'),
        _htmlBodyObj    = new BodyElement(),
        _htmlDivObj     = new DivElement();

} //HtmlFO



/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: Widget Class
███████████████████████████████████████████████████████████████████████████████████████████
*/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* This establishes the base class from which all other Widgets used in an [Application]
* will be derived — it is a visual SVG/Dart-based UI "component" or "control".
* A substantial piece of functionality related
* to the positioning/sizing for all Widgets is implemented in this base class, as are
* rather robust borders, plus movement/sizing abilities as well as visual constraints
* and event-handling abilities.
*
* Although objects can be instantiated directly from this Class, more specialized derived
* components will exist.  The Widget class is the basic building block for other components.
* E.g., a "slider" control is nothing more than a buildup of widgets; buttons are specialized
* widgets, etc.
*
* ---
* ## How our Widget is "Expressed" (in SVG)
* ### In Outline-Form
* Here is an outline of the resulting SVG structure (see textual discussion that follows), and
* keep in mind the apparent *Z-order* will be: first-subitem-per-level is the
* "back-most" (deepest) in that level:
*
*     <g> _entireGroupSVGElement
*         <rect> _BgRectSVGElement
*         <g> _borders.allBordersSVGGroupElement (aka, bordersSVGGroupElement)
*             <g> _borders.Outer
*                 <line> T1,T2 - i.e., top side primary line and secondary line
*                 <line> R1,R2 - i.e., right side ...
*                 <line> B1,B2 - i.e., bottom side ...
*                 <line> L1,L2 - i.e., left side ...
*             <g> _borders.Frame
*                 <line> T (note: only one line per side possible for "frame" border)
*                 <line> R
*                 <line> B
*                 <line> L
*             <g> _borders.Inner
*                 <line> T1,T2 - i.e., top side primary line and secondary line
*                 <line> R1,R2 - i.e., right side ...
*                 <line> B1,B2 - i.e., bottom side ...
*                 <line> L1,L2 - i.e., left side ...
*         <svg> _clientSVGElement
*             (optional) <g> _entireGroupSVGElement for hierarchically-contained widget1
*             (optional) <g> _entireGroupSVGElement for hierarchically-contained widget2
*             (optional) <g> _entireGroupSVGElement for hierarchically-contained widget3
*             ...
*         <rect> _selectionRect
*
* ### Textual discussion
*
* All SVG related to a Widget is contained within a single SVG Group ("g") element
* (_entireGroupSVGElement).
*
* SVG <g> elements have the advantage of *transform* operations on their entire contents,
* which we will use for moving (via translate transform) and potentially for zooming and
* rotating (via transform scale (x,y) and rotate(deg,cx,cy)).  Groups may also provide
* ideal targets for events.
*
* A widget is initially positioned with the X/Y values on the <g> tag, and any movement
* of the widget is reflected in the translate(x,y) value applied to that <g> tag; such
* translation can be positive or negative along either axis.
*
* Translated widget positions are cumulative/additive down through any hierarchy of widgets.
* I.e., a child-widget's position and/or translation is relative to its parent's X/Y position.
*
* Within this entire group container, we create a background rect. It will be furthest
* back in the Z-order.
*
* Next, our border group holds all sub-borders (WidgetParts of Outer, Frame, Inner) as well as the
* lines that are used to draw each individual border part.
*
* Next, we ALWAYS append an "empty" <svg> element (_clientSVGElement) at the penultimate
* position within group for holding any (future) child Widget(s); this is done for
* consistency sake and simplicity -- such that any attempt to add child Widgets
* (or Widget subclasses) has a predictable target element available.
*
* The ClientBounds <svg> (_clientSVGElement) will be sized and positioned within the widget
* after calculating insets from its parent <svg> bounds.  I.e., inset distance from outside
* must include (height/width adjustments) for any of border's:
*     margin, outer border, frame, inner border, padding.
*
* Any child widgets simply repeat the entire structure outlined above (i.e., this becomes
* a repetitive/recursive pattern within our SVG document).
*
* ---
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Widget {

    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Private variables
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    MISC INTERNAL-ONLY FULLY PRIVATE VARIABLES
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */

    //reference to Application instance (set in Constructor)
    Application         _applicationObject  = null;

    WidgetBorders       _borders            = null;

    //working variable object for outer bounds; instance created in constructor
    ObjectBounds        _containerBounds    = null;

    //track whether this widget is "selected"; made class-wide variable in case we want to examine elsewhere than mouse-down
    bool                _isSelected         = false;

    //These Translate values track the distance a widget has been translated from their orig position via move() method.
    num                 _translateX = 0.0;
    num                 _translateY = 0.0;

    //TODO: for future implementation
    num                 _scaleX     = 1.0;
    num                 _scaleY     = 1.0;
    num                 _rotateDeg  = 0.0;

    //when a dragging-move operation is underway, these variables track starting (mouse) coordinates that offsets are calc'd from
    //initially set on mousedown, but updated with each subsequently processed mousemove (to be "new" start position before next event)
    num                 _dragStartX = 0.0;
    num                 _dragStartY = 0.0;

//TODO: IF we want to "abort" a move... need to implement a two-phase tracking (i.e., have Start values remain ORIG pos until done).
//    num _DragLastX  = 0;
//    num _DragLastY  = 0;


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    List of Widget references (i.e., object pointers) to any Widgets owned by this Widget.
    Any child Widget that has a Parent will call a method on this Widget to add/remove
    itself from this list during Widget Construction/Destruction.
    Note: destroying a Widget destroys all Child-Widget references herein; references held
    by this list will be cleared in the process.

    This _widgetsList shall be inaccessible (directly) to the public.
    [Widget.addWidget] is used to interact with this list.
    There is no need for a *public* 'Widget.removeWidget' method, since the Widget
    destructor [destroy] will handle any required cleanup in parentWidget (if exists),
    plus the destructor method calls the [Application.removeWidget] recursively to delete any "owned" Widgets.

    Because each object inserted into this list has (obviously) passed validation in the
    Widget constructor, we can count on the uniqueness of each [Widget.instanceName] in this
    list.

    NOTE: each widget has to exist in Application-level WidgetsList, but for speed concerns,
    we do not test this condition herein; again, if a widget constructor finished, this
    condition has to have been met already.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    List<Widget>        _widgetsList    = null;


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    This group of variables gets their values from CSS Styling applied to the Widget.
    These are essentially just quick-accessors.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    String              _fillColor              = 'none';   //'none', 'transparent', '' each indicate no-fill
    String              _fillOpacity            = '0.0';    //fill not showing by default

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    If CSS styles (classesCSS) have been modified since a RePaint occurred,
    (e.g., after a [beginUpdate] and prior to [endUpdate]), store that knowledge here.
    Use this info to optimize repaints by avoiding unnecessary CSS related recalcs.
    The RePaint method resets this to false at completion.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    bool                _cssChangedSinceRepaint     = true;


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Protected variables - interaction with private vars are through accessor methods
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Variables exposed as READ-ONLY properties via "getters"
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    String              _instanceName           = '';       //must be Unique to entire application
    String              _typeName               = 'Widget'; //set in constructor; sub-classes pass as constructor parm.
    bool                _hasParent              = false;
    String              _hierarchyPath          = '';       //Unique throughout application. "(0:n)[ParentInstanceName,]InstanceName"

    //Widget's inner rect/bounding-box available to CHILD objects x1,y1,x2,y2 (i.e., this Widget's Bounds less space for margin, border(s), padding)
    //This is an object-reference to the SVGElement we created during the Widget initialization process
    SVGElement          _clientSVGElement       = null;

    //Widget's placeholder selection-rect; hidden unless "selected"
    SVGElement          _selectionRect          = null;

    //IF exists, _ParentWidget holds a reference to our ParentWidget (must be a Widget or subclass of)
    //that "owns" this one, if any. "Owner" in implementation hierarchy. Otherwise null
    Widget              _parentWidget           = null;

    //IF exists, stores quick reference to SVGElement in which this Widget's generated-SVG element(s) reside (i.e., hierarchically embedded)
    //Default SVG-materialization target-element shall be on our global Canvas, unless we have a parent widget (see Create method)
    SVGElement          _parentSVGElement       = null;

    //TODO: Expose via property for subclasses? Or, is BeginUpdate/EndUpdate enough?
    int                 _widgetState            = eWidgetState.Loading;     //enumeration eWidgetState (int); additive/multi-state

    //reference to the group (SVG "g" element) this ENTIRE Widget's SVG will be rendered into; aka 'EntireGroupSVGElement' as public property
    SVGGElement         _entireGroupSVGElement  = null;
    String              _entireGroupName        = '';

    //reference to the background (SVG "rect") element used for "fill"
    SVGRectElement      _bgRectSVGElement       = null;


    //Event handler...
    EventsProcessor     _on     = null;
    EventsProcessor get on      => _on;

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    IsMovable/IsSizable properties: simply expose a reference to our embedded WidgetDynamics.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    WidgetDynamics get isSizable    => _isSizable;
    WidgetDynamics get isMovable    => _isMovable;

    //a shortcut to resulting value for whether ANY "selection"-related action is enabled for this Widget (i.e., movable/sizable);
    bool                _isSelectable    = true;

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Variables exposed as READ-WRITE properties via "getters" and "setters"

    These properties can generally be set after Constructor (i.e., "Create()" by another name)
    has run and prior to Show(); post-Show() changes to these values will generally
    trigger appropriate visual updates unless noted otherwise.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    _WidgetMetrics : stores bounds information for Widget.

    Widget size and position, along with Border(s) specifications, influence these Metrics.
    Constraints and directives for position, size, alignment, constraints, anchors can
    further effect the calculation of these metrics.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    WidgetMetrics       _widgetMetrics      = null;

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Various constraints and positioning directives that can effect metrics.
    See their respective Class definitions for documentation.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    WidgetAlignment     _align              = null;
    WidgetSizeRules     _sizeRules          = null;
    WidgetPosRules      _posRules           = null;

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Anchors are used to fix edge positions relative to container side(s)
    This property makes use of the additive nature of eSides (powers-of-two) for bitwise
    determination if a particular side is anchored.
    These are of type enumeration eSides (int); values are additive (combined) for multi-side
    anchoring abilities with one property.

    TODO: implement anchor center(s) ability in alignment code
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    int             _anchors            = eSides.None;

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    These further affect visual behavior.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */

    //List of StyleTarget instances. These stylable targets can have CSS Class-Selector(s) applied to them via our classesCSS property.
    List<StyleTarget>   _stylablePropertiesList = null;

    num             _y                  = 0.0;
    num             _x                  = 0.0;
    num             _width              = 20.0;
    num             _height             = 20.0;
    String          _caption            = '';       //Caption will be displayed, where appropriate, on sub-classes that implement this
    bool            _enabled            = true;
    bool            _visible            = false;
    String          _tag                = '';       //Common field for developer convenience.  Delphi developers will be familiar with uses; we extended to String vs just Int.
    bool            _tabStop            = false;    //Is Widget in the TabOrder (t/f)?
    num             _tabOrder           = 0;        //Integer makes most sense, but any number will do for <> comparisons
    bool            _showHint           = false;
    int             _hintPause          = 1000;


    //Can this item be moved with the mouse? (via mousedown/mousemove/mouseup)?
    //TODO: MoveTarget (what group in widget) to detect moves on?  Also, should Alignment be cleared if moved?
    WidgetDynamics      _isMovable          = null;

    //Can this item be resized with the mouse? (via mousedown/mousemove/mouseup)?
    WidgetDynamics     _isSizable           = null;

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    TODO-REF#1: THE FOLLOWING VARIABLES ARE HERE TO WORKAROUND AN ISSUE IN DART:
        http://code.google.com/p/dart/issues/detail?id=144

    We use the approach from here as a workaround:
        http://japhr.blogspot.com/2012/03/really-really-removing-event-handlers.html

    Basically, just create pointers to our event methods and add/remove (.on.) these instead
    of direct method references.   NOTE: set the values in the constructor!
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    var mouseDownHandler;
    var mouseClickHandler;
    var mouseMoveHandler;
    var mouseUpHandler;


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Public variables/accessors.
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    //Closely related to _StylablePropertiesList in that this Map's VALUES contain CSS Class-Selector(s) to apply to
    //the list's TargetObject(s) with same value as this Map's KEYS. Interact with the Map via the CSSTargetsMap class methods.
    //Widget uses familiar CSS-based styling.
    //Instead of implementing a host of exposed properties and methods for setting various visual-aspects
    //of our SVG objects, we rely on external CSS stylesheet styles to obtain values used for
    //styling elements of our widgets; e.g., filling the background, setting side color(s) and width(s).
    CSSTargetsMap    classesCSS         = null;

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    VARIOUS CONSTANTS  :TODO -- IF this will increase mem-efficiency/speed, move literals here
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */

    //our CSS-stylable targets (and, the default class-selector-values to match)
    static final String sWBase          = 'Widget_Base';
    static final String sWFrame         = 'Widget_Frame';
    static final String sWOuter         = 'Widget_BorderOuter';
    static final String sWInner         = 'Widget_BorderInner';

    static final Map<String, String> mapInitialClassesCSS    = const {
        'Widget_Base'       :'Widget_Base',
        'Widget_Frame'      :'Widget_Frame',
        'Widget_BorderOuter':'Widget_BorderOuter',
        'Widget_BorderInner':'Widget_BorderInner'
    };


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: PRIVILEGED METHODS (publicly visible accessors to our protected members)
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    READ ONLY values will ONLY have "getters" without corresponding "setters"
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */


    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Each Widget must have an appropriate (component) [typeName].
    * This value is set inside the constructor; this is read-only accessor.
    * Sub-classes must set set appropriately in constructor (via _typeName parm).
    * Along with [instanceName], this value is used to form unique
    * SVG-element identifiers (i.e., "id" attribute values).
    *
    * TODO: Will "mirrors" typeMirror be available for this? .simpleType (as in dartdocs)?
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    String      get instanceName            => _instanceName;


    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Each Widget must have an appropriate (component) [typeName].
    * This value is set in the constructor.
    * Along with [instanceName], this value is used to form unique
    * SVG-element identifiers (i.e., "id" attribute values).
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    String      get typeName                => _typeName;


    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * [hierarchyPath] of the [parentWidget] + '_' + this widget's [instanceName].
    *
    * So, as widget-nesting-depth grows, this string grows to include all instanceNames
    * appearing (hierarchically) "above" it.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    String      get hierarchyPath           => _hierarchyPath;

    ///When [false] this Widget instance resides directly on our [Application.canvas], otherwise it is a child of [parentWidget]
    bool        get hasParent               => _hasParent;

    String      get caption                 => _caption  ;
    bool        get enabled                 => _enabled  ;
    bool        get showHint                => _showHint ;
    num         get translateX              => _translateX ;
    num         get translateY              => _translateY ;
    SVGElement  get parentSVGElement        => _parentSVGElement;
    SVGElement  get clientSVGElement        => _clientSVGElement;
    SVGElement  get selectionRect           => _selectionRect;
    String      get entireGroupName         => _entireGroupName;
    SVGGElement get entireGroupSVGElement   => _entireGroupSVGElement;
    SVGGElement get bordersSVGGroupElement  => _borders.allBordersSVGGroupElement;
    Widget      get parentWidget            => _parentWidget;

    ///See: [eWidgetState] for details.
    int         get widgetState             => _widgetState;    //enumeration eWidgetState (int);


    //Setting ApplicationObject post-creation could have really bad implications. Prevented.
    ///Reference to [Application] object specified during constructor.
    Application get applicationObject       => _applicationObject;

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Sizing rules "setting" is handled in SizeRules class and a callback intercepts
    any changes and fires
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    WidgetSizeRules get sizeRules           => _sizeRules;

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Widget's Positioning rules / constraints...
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    WidgetPosRules get posRules             => _posRules;


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Misc
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    String      get tag                     =>  _tag ;
    void        set tag(String newTag)      {_tag = newTag;}


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Tab stops and tab-ordering properties...

    TODO: We will likely need to update our list of tabstops that are ordered by TabOrder,
    when either of these properties is altered.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    bool        get tabStop                 => _tabStop;
    void        set tabStop(bool isTabStop) {
        if (_tabStop != isTabStop) {
            _tabStop = isTabStop;
        }
    }

    num         get tabOrder                => _tabOrder;
    void        set tabOrder(num tabOrder) {
        if (_tabOrder != tabOrder) {
            _tabOrder = tabOrder;
        }
    }


    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Essentially an alias for testing the state of, or executing, [show] / [hide].
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    bool        get visible                 => _visible;
    void        set visible(bool isVisible) {
        if (_visible == isVisible) {
            return;  //no need to do anything further if no change
        }

        _visible = isVisible;

        if (_visible) {show();} else {hide();}
    }

    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Convenience Method with obvious intent.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    void toggleVisibility() {
        if (_visible) {hide();} else {show();}
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Note:  Changes to the following property values can affect bounds-calcs
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */

    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Alignment directives are a .
    * Widget alignment (positional-constraint) capabilities are rather substantial,
    * and much widget functionality relies on these values to determine positioning
    * of widgets relative to other widgets and/or relative to the window-bounds, etc.
    * Alignment options (and/or [anchors]) can be set in such a way that Widgets will
    * "auto-move/stretch" as their container changes, as they are moved (with mouse),
    * and as siblings they are aligned to move or change dimensions.
    *
    * Setting of values is done via [align] sub-properties, each of which is of type
    * [AlignSpec].  E.g., `myWidget.align.T.dimension = eSides.T;` to indicate that the top
    * of a Widget is to be aligned to the top of its [parentWidget] during the [reAlign]
    * procedure.
    *
    * **Recommendation:** Implement a [beginUpdate] ... [endUpdate] block around code that
    * performs changes of multiple alignment properties
    * (to prevent excessive recalculations, repaints, etc).
    *
    * ### See Also
    *   * [anchors]
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    WidgetAlignment     get align           => _align;


    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Return a reference to Widget's Metrics information. This accessor exists primarily
    * for obtaining positioning/bounds information about this Widget, via the various
    * [ObjectBounds] objects contained within [WidgetMetrics], by other widgets or external
    * code that require such information perform alignment tasks or such.
    * E.g., `myWidget.metrics.Margin.L` will return the widget's left margin position.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    WidgetMetrics       get metrics         => _widgetMetrics;


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Widget's X and Y-axis position within the coordinate space defined by the widget's container
    (i.e., not *canvas* coordinates, unless widget has no parent)

    We return most up-to-date X and Y value from the Margin(WidgetBounds) L/T respectively,
    since original "X" and "Y" may not be as relevant
    (due to effect of align/anchors/posrules/translate/etc.)
    ═══════════════════════════════════════════════════════════════════════════════════════
    */

    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * X coordinate value in the Cartesian plane and the left-most bounds of Widget.
    *
    * Coordinate system is relative to the origin of the SVG <svg> element
    * into which a Widget is rendered — i.e., within the [clientSVGElement] of the [parentWidget],
    * or within [Application.canvas] bounds for top-level widgets residing directly on that canvas.
    *
    * Note that alignment ([align]) properties, [anchors] values, and [sizeRules], etc can
    * affect (override) position / sizing values.
    *
    * See related properties: [y], [width], and [height].
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    num     get x       => _widgetMetrics.Margin.L;
    void    set x(num newX) {
        if (_x != newX) {
            _x = newX;
            if (_visible) {
                rePaint();
            }
        }
    }



    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Y coordinate value in the Cartesian plane and the Top-most bounds of Widget.
    *
    * *See: [x] for further discussion.*
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    num     get y       => _widgetMetrics.Margin.T;
    void    set y(num newY) {
        if (_y != newY) {
            _y = newY;
            if (_visible) {
                rePaint();
            }
        }
    }



    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Width of Widget.
    *
    * *See: [x] for further discussion.*
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    num     get width   => _widgetMetrics.Margin.Width;
    void    set width(num newWidth) {
        //Ensure our new value remains within any Sizing contraints.
        newWidth    = _sizeRules.getConstrainedWidth(newWidth);

        if (_width != newWidth) {
            _width = newWidth;
            if (_visible) {
                rePaint();
            }
        }
    }



    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Height of Widget.
    *
    * *See: [x] for further discussion.*
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    num     get height  => _widgetMetrics.Margin.Height;
    void    set height(num newHeight) {
        //Ensure our new value remains within any Sizing contraints.
        newHeight = _sizeRules.getConstrainedHeight(newHeight);

        if (_height != newHeight) {
            _height = newHeight;
            if (_visible) {
                rePaint();
            }
        }
    }


    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Convenience method for setting all bounds-specifiers at once ([x],[y],[width],[height]).
    * Each metric is set via its "setter" to enforce any logic therein.
    *
    * *See: [x] for further discussion.*
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    void setBounds(num newX, num newY, num newWidth, num newHeight) {
        x = newX;
        y = newY;
        width = newWidth;
        height = newHeight;
    }


    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Provide easy access to a "clientX" version of a Widget's [x] coordinates.
    * The window.pageXOffset values compensate for scroll-position (browser horizontal scrollbar pos).
    * TODO: These clientX/Y values appear in need of refresh immediately after construction if any "align" spec forced move from original x/y pos.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    num get xAsClientX  =>  (_hasParent ? (_parentWidget.getClientBounds().L) + _parentWidget.translateX  : 0.0)
                            + _x + _translateX + _applicationObject.marginLeft    - window.pageXOffset;

    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Provide easy access to a "clientY" version of a Widget's [y] coordinates.
    * The window.pageYOffset values compensate for scroll-position (browser vertical scrollbar pos).
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    num get yAsClientY  =>  (_hasParent ? (_parentWidget.getClientBounds().T) + _parentWidget.translateY  : 0.0)
                            + _y + _translateY + _applicationObject.marginTop     - window.pageYOffset;



    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Anchors are a special type of constraint that is designed to fix Side(s) of a Widget
    * in a particular location relative to the [parentWidget.clientSVGElement] bounds
    * (i.e., our container's bounds) when a Widget is resized or otherwise aligned (per
    * [align] specifications).
    *
    * These anchors will be honored during resizing of widgets. Note that anchors used in
    * combination with [align] values only make sense when one side of a Widget is
    * subject to an [align] directive and its *opposite* side is not (that opposite side
    * could be anchored).
    *
    * Anchors rely on an enumerated type [eSides] whose integer values are additive
    * in such a way that, within this single integer [anchors] property, it is possible to
    * specify multiple anchor-sides.
    * E.g., both the top *and* left side of the widget could be anchored.
    *
    * ### See Also
    *   * [align] for more about alignment specifications.
    *   * [eSides] for more information about the additive nature of this type's values.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    int get anchors     => _anchors;
    void    set anchors(newAnchors) {
        if (_anchors != newAnchors) {
            _anchors = newAnchors;
            if (_visible) {
                rePaint();
            }
        }
    }



    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: RENDERING AND STYLING-RELATED METHODS
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Centralizes the "repainting" of the Widget.  Includes logic to bypass repaints while
    * inside a [beginUpdate] ... [endUpdate] block.  Also only re-calculates any CSS-sourced
    * visual properties if a CSS change has been detected since last [rePaint] operation.
    *
    * ### See Also
    *   * [rePaintFull]
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void rePaint() {
        if ( (_widgetState & eWidgetState.Updating) == eWidgetState.Updating) return;  //bypass during mass-updates

        if (_cssChangedSinceRepaint) {
            _updateStylePropertiesListValuesFromCSS();
            _applyStylesToWidgetParts();
        }
        reAlign();

        //reset flag, so we can trap any further CSS changes
        _cssChangedSinceRepaint = false;
    } //...RePaint


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Force the re-calculation of any CSS-sourced visual properties, followed by a
    * "repainting" of the Widget. Currently not used internally anywhere.
    *
    * ### See Also
    *   * [rePaint]
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void rePaintFull() {
        _cssChangedSinceRepaint = true;
        rePaint();
        //TODO : Remove Updating from _widgetState if it exists?
    }

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Populate list with stylable targets applicable to this Widget.

    AT THIS TIME, CSS can only be used to style the entire border-part (group) at once, which is fine,
    since you can layer CSS Classes up such that if you wish to affect a change on one minor component
    of a widget-part (e.g., the Frame's right-border color), you can do so by simply setting up a
    CSS class-selector like "FrameRightBorderColor {border-right: 1px solid red}", and include this
    selector on the Frame-target by setting classesCSS(sWFrame) = "$sWFrame, FrameRightBorderColor"

    ULTIMATELY, if there is a need (due to speed or such) to have more "direct" access to updating a
    single, or narror group of, value(s), our part-naming convention could come into play (see below)
    and we could include in our stylable properties list any "targetable" subsets, like "Widget_Base_Background")

    Stylable Part Naming Convention for "id" attributes (i.e., the "TargetObject"):
        InstanceName_Component_SubComponent[_SubComponent][_SubComponent]...

        e.g.,: InstanceName_Widget_BorderType_BorderSubComponent_Side/Path[stroke#]... which results in...
        e.g.,: InstanceName_Widget_BorderOuter_Outer_Left2

    HOW THESE ARE USED:  see CSSTargetsMap class comments.
    Our classesCSS (instance of CSSTargetsMap), maintains a comma-delim list of CSS Selector "classes"
    to apply to target objects in our stylable-properties-list.

    PER-SIDE property ENUMERATIONS are included because, even if a property like "margin" is specified in CSS,
    we need to return the calculated value PER-SIDE (for our internal drawing routines).

    NOTE: Sub-classes must extend this function to apply/calc CSS to any applicable SVG elements owned by a derived Widget
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _loadStylablePropertiesList() {

        void addObjToList(TargetObject, TargetProperty, [DefaultValue = '0']) {
            _stylablePropertiesList.add(new StyleTarget(TargetObject, TargetProperty, DefaultValue));
        }

        //TODO: stroke-linecap by part?

        /*
        GROUP 1:
        Begin with properties that are styled by applying Base Widget class-selector(s); notice that for this group, we could have used
        a single group, and thus a single call to retrieve "Base" and "Frame" styling, since the CSS Properties used for each do not conflict/overlap.
        But, since we could end up using properties like "filter" for both for widget background and its frame, separation was chosen.
        */
        addObjToList(sWBase, 'margin-top'          , '0'      );
        addObjToList(sWBase, 'margin-right'        , '0'      );
        addObjToList(sWBase, 'margin-bottom'       , '0'      );
        addObjToList(sWBase, 'margin-left'         , '0'      );
        addObjToList(sWBase, 'padding-top'         , '0'      );
        addObjToList(sWBase, 'padding-right'       , '0'      );
        addObjToList(sWBase, 'padding-bottom'      , '0'      );
        addObjToList(sWBase, 'padding-left'        , '0'      );
        addObjToList(sWBase, 'fill'                , 'black'  );
        addObjToList(sWBase, 'fill-opacity'        , '0.0'    );

        addObjToList(sWFrame, 'border-top-style'    , 'none'   );
        addObjToList(sWFrame, 'border-right-style'  , 'none'   );
        addObjToList(sWFrame, 'border-bottom-style' , 'none'   );
        addObjToList(sWFrame, 'border-left-style'   , 'none'   );
        addObjToList(sWFrame, 'border-top-width'    , '0'      );
        addObjToList(sWFrame, 'border-right-width'  , '0'      );
        addObjToList(sWFrame, 'border-bottom-width' , '0'      );
        addObjToList(sWFrame, 'border-left-width'   , '0'      );
        addObjToList(sWFrame, 'border-top-color'    , '0'      );
        addObjToList(sWFrame, 'border-right-color'  , '0'      );
        addObjToList(sWFrame, 'border-bottom-color' , '0'      );
        addObjToList(sWFrame, 'border-left-color'   , '0'      );
        addObjToList(sWFrame, 'stroke-opacity'      , '1.0'    );

        /*
        GROUP 2: properties that are styled by applying Outer-Border class-selector(s)
        NOTE:   Border-STYLE(s) are at end of each group and must remain there. The GetCSS... routine processes this array in order,
                and when it reaches the style attribute(s), it performs lookups on width-value(s) to determine border-type (our
                enumerated internal "type").
        */
        addObjToList(sWOuter, 'border-top-style'     , 'none'   );
        addObjToList(sWOuter, 'border-right-style'   , 'none'   );
        addObjToList(sWOuter, 'border-bottom-style'  , 'none'   );
        addObjToList(sWOuter, 'border-left-style'    , 'none'   );
        addObjToList(sWOuter, 'border-top-width'     , '0'      );
        addObjToList(sWOuter, 'border-right-width'   , '0'      );
        addObjToList(sWOuter, 'border-bottom-width'  , '0'      );
        addObjToList(sWOuter, 'border-left-width'    , '0'      );
        addObjToList(sWOuter, 'border-top-color'     , '0'      );
        addObjToList(sWOuter, 'border-right-color'   , '0'      );
        addObjToList(sWOuter, 'border-bottom-color'  , '0'      );
        addObjToList(sWOuter, 'border-left-color'    , '0'      );
        addObjToList(sWOuter, 'stroke-opacity'       , '0.0'    );

        //Group3: properties that are styled by applying Inner-Border class-selector(s)
        addObjToList(sWInner, 'border-top-style'     , 'none'   );
        addObjToList(sWInner, 'border-right-style'   , 'none'   );
        addObjToList(sWInner, 'border-bottom-style'  , 'none'   );
        addObjToList(sWInner, 'border-left-style'    , 'none'   );
        addObjToList(sWInner, 'border-top-width'     , '0'      );
        addObjToList(sWInner, 'border-right-width'   , '0'      );
        addObjToList(sWInner, 'border-bottom-width'  , '0'      );
        addObjToList(sWInner, 'border-left-width'    , '0'      );
        addObjToList(sWInner, 'border-top-color'     , '0'      );
        addObjToList(sWInner, 'border-right-color'   , '0'      );
        addObjToList(sWInner, 'border-bottom-color'  , '0'      );
        addObjToList(sWInner, 'border-left-color'    , '0'      );
        addObjToList(sWInner, 'stroke-opacity'       , '0.0'    );

        //Group[n]...  added in subclasses

    } //..._loadStylablePropertiesList



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Call the method that will perform an off-screen computation by applying any CSS-class-selectors
    as they apply to our standard Widget base/border elements.

    See: _loadStylablePropertiesList (for more related comments)

    NOTE: Sub-classes must extend this function to apply/calc CSS to any applicable SVG elements owned by a derived Widget

    TODO: Address pseudo-SELECTORS (HOVER, etc) via ONLY CSS
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _updateStylePropertiesListValuesFromCSS() {
        _applicationObject.trace(8, this);

        //Widget_Base, Widget_Frame,Widget_BorderOuter, Widget_BorderInner
        _applicationObject.getCSSPropertyValuesForClassNames(sWBase,  classesCSS[sWBase],  _stylablePropertiesList);
        _applicationObject.getCSSPropertyValuesForClassNames(sWFrame, classesCSS[sWFrame], _stylablePropertiesList);
        _applicationObject.getCSSPropertyValuesForClassNames(sWOuter, classesCSS[sWOuter], _stylablePropertiesList);
        _applicationObject.getCSSPropertyValuesForClassNames(sWInner, classesCSS[sWInner], _stylablePropertiesList);
    } //_updateStylePropertiesListValuesFromCSS



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Values are derived from our CSS calculations, and stored in _StylablePropertiesList, are moved to
    appropriate internal variables.

    NOTES:
        The ORDER of updating our Widget values matters.
        Style-setting relies on us already having set the border-width values, since we
        support two border-style values not defined by standard CSS.

    PER-SIDE property ENUMERATIONS are examined because, even if a property like "margin" is specified in CSS,
    we need to return the calculated value PER-SIDE (for our internal drawing routines).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _applyStylesToWidgetParts() {
        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        a method to simplify life a bit...
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        String obtainStyleCalcValue(String objName, String propName) {
            return  getStyleTargetFromListByObjAndProperty(_stylablePropertiesList, objName, propName).calcValue;
        }


        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Fill, Margin, and Padding...
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _fillColor              = ensureStandardNoneColor(obtainStyleCalcValue(sWBase, 'fill'));
        _fillOpacity            = ((_fillColor == 'none') ? '0.0' : obtainStyleCalcValue(sWBase, 'fill-opacity'));
        _borders.Margin.T.width = Math.parseInt(obtainStyleCalcValue(sWBase, 'margin-top'    ));
        _borders.Margin.R.width = Math.parseInt(obtainStyleCalcValue(sWBase, 'margin-right'  ));
        _borders.Margin.B.width = Math.parseInt(obtainStyleCalcValue(sWBase, 'margin-bottom' ));
        _borders.Margin.L.width = Math.parseInt(obtainStyleCalcValue(sWBase, 'margin-left'   ));
        _borders.Padding.T.width= Math.parseInt(obtainStyleCalcValue(sWBase, 'padding-top'   ));
        _borders.Padding.R.width= Math.parseInt(obtainStyleCalcValue(sWBase, 'padding-right' ));
        _borders.Padding.B.width= Math.parseInt(obtainStyleCalcValue(sWBase, 'padding-bottom'));
        _borders.Padding.L.width= Math.parseInt(obtainStyleCalcValue(sWBase, 'padding-left'  ));


        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Frame, Outer, Inner: each use CSS prop values similarly
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        void applyStylesToWidgetPart(WidgetBorder bPart, String objName) {
            String  sTemp       = '';

            //workaround for issue with non-100%-zoom-factor-getcomputedstyle returning bogus non-INT values!
            int getProperWidthValues(String potentialDecimalWidth) {
                int decIndex    = potentialDecimalWidth.indexOf('.');

                if (decIndex > -1) {
                    potentialDecimalWidth = potentialDecimalWidth.substring(0, decIndex);
                    return Math.parseInt(potentialDecimalWidth) + 1;  //add one for "ceiling" effect
                } else {
                    return Math.parseInt(potentialDecimalWidth);
                }
            }

            bPart.T.width       = getProperWidthValues(obtainStyleCalcValue(objName,  'border-top-width'       ));
            bPart.R.width       = getProperWidthValues(obtainStyleCalcValue(objName,  'border-right-width'     ));
            bPart.B.width       = getProperWidthValues(obtainStyleCalcValue(objName,  'border-bottom-width'    ));
            bPart.L.width       = getProperWidthValues(obtainStyleCalcValue(objName,  'border-left-width'      ));

            bPart.T.color       = ensureStandardNoneColor(obtainStyleCalcValue(objName,  'border-top-color'    ));
            bPart.R.color       = ensureStandardNoneColor(obtainStyleCalcValue(objName,  'border-right-color'  ));
            bPart.B.color       = ensureStandardNoneColor(obtainStyleCalcValue(objName,  'border-bottom-color' ));
            bPart.L.color       = ensureStandardNoneColor(obtainStyleCalcValue(objName,  'border-left-color'   ));

            sTemp   = obtainStyleCalcValue(objName, 'stroke-opacity' );
            bPart.T.opacity     = ((bPart.T.color == 'none') ? '0.0' : sTemp);
            bPart.R.opacity     = ((bPart.R.color == 'none') ? '0.0' : sTemp);
            bPart.B.opacity     = ((bPart.B.color == 'none') ? '0.0' : sTemp);
            bPart.L.opacity     = ((bPart.L.color == 'none') ? '0.0' : sTemp);

            //only valid styles for frame are solid or none.
            bPart.T.setStyle(obtainStyleCalcValue(objName, 'border-top-style'   ) );
            bPart.R.setStyle(obtainStyleCalcValue(objName, 'border-right-style' ) );
            bPart.B.setStyle(obtainStyleCalcValue(objName, 'border-bottom-style') );
            bPart.L.setStyle(obtainStyleCalcValue(objName, 'border-left-style'  ) );
        }

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Frame, Outer, Inner processing
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        applyStylesToWidgetPart(_borders.Frame, sWFrame);
        applyStylesToWidgetPart(_borders.Outer, sWOuter);
        applyStylesToWidgetPart(_borders.Inner, sWInner);

    } //_applyStylesToWidgetParts




    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Method that consolidates the visual updates to all aspects of our Widget.  
    This is called from ReAlign() when any changes to Widget properties/state will affect 
    the background, border(s), or selection-rect position.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void renderBordersAndBackground() {

        ObjectBounds ptrBoundsForBgRect      = _widgetMetrics.Inner;

        /*  transform="translate(x,y), scale(scalex,scaley)"...
            Need to translate inversely-proportionate to the scale in order to keep the x/y of the SVG tag at same
            visual position after scaling.  Also, consider: do we want top-left corner to remain stationary, or center-point?
            TODO: implement translate for positioning post-scale(other than 1, 1)...
            TODO: handle any rotations too
        */
        _entireGroupSVGElement.attributes['transform'] =
            'translate(${((_hasParent ? _parentWidget.getClientBounds().L : 0 ) + _translateX)},${((_hasParent ? _parentWidget.getClientBounds().T : 0 ) + _translateY)}), scale(1,1)';

        setSVGAttributes(_bgRectSVGElement, {
            'x'             : (ptrBoundsForBgRect.L).toString(),
            'y'             : (ptrBoundsForBgRect.T).toString(),
            'width'         : (ptrBoundsForBgRect.Width).toString(),
            'height'        : (ptrBoundsForBgRect.Height).toString(),
            'fill'          : _fillColor,
            'fill-opacity'  : _fillOpacity,
            'stroke'        : 'none',
            'stroke-width'  : '0'
        });

        //Keep our (potentially-displayed) selection-indicator-rect updated
        ObjectBounds ptrBoundsForSelectRect      = _widgetMetrics.Margin;
        setSVGAttributes(_selectionRect, {
            'x'             : (ptrBoundsForSelectRect.L).toString(),
            'y'             : (ptrBoundsForSelectRect.T).toString(),
            'width'         : (ptrBoundsForSelectRect.Width).toString(),
            'height'        : (ptrBoundsForSelectRect.Height).toString(),
        });


        _borders.Outer.updateBorderSideStrokeCoordinatesFromBounds(_widgetMetrics.Outer);
        _borders.Frame.updateBorderSideStrokeCoordinatesFromBounds(_widgetMetrics.Frame);
        _borders.Inner.updateBorderSideStrokeCoordinatesFromBounds(_widgetMetrics.Inner);

        _borders[eWidgetPart.Frame].T.updateBorderLineElements();
        _borders[eWidgetPart.Frame].R.updateBorderLineElements();
        _borders[eWidgetPart.Frame].B.updateBorderLineElements();
        _borders[eWidgetPart.Frame].L.updateBorderLineElements();
        _borders[eWidgetPart.Outer].T.updateBorderLineElements();
        _borders[eWidgetPart.Outer].R.updateBorderLineElements();
        _borders[eWidgetPart.Outer].B.updateBorderLineElements();
        _borders[eWidgetPart.Outer].L.updateBorderLineElements();
        _borders[eWidgetPart.Inner].T.updateBorderLineElements();
        _borders[eWidgetPart.Inner].R.updateBorderLineElements();
        _borders[eWidgetPart.Inner].B.updateBorderLineElements();
        _borders[eWidgetPart.Inner].L.updateBorderLineElements();

    } //...renderBordersAndBackground




    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Metrics / Bounds Calcs / Realignment Logic...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    This method is called when any change occurs that could affect Widget's "Metrics" property;
    in particular, a ReAlign operation has the potential to alter these Metrics (bounds info).

    Re-alignment happens when directives for position, size, alignment, constraints, anchors, etc
    are manipulated. This is not encapsulated in the Metrics class(es) because we needed easy
    access to Border information as well.
    Metrics keep track of bounding-rects (via side positions) for each component of a Widget
    that forms a distinct boundary, with each bounding box being the *outside* of the respective component.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    bool _updateWidgetMetrics() {
        ObjectBounds ptrWidgetBounds = _widgetMetrics.Margin;

        //Pre-calc the R,B,CX,CY (unaligned) values for quick reference later
        num mTempR      = _x + _width;
        num mTempB      = _y + _height;
        num mTempAdjCX  = _width / 2;
        num mTempAdjCY  = _height / 2;

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Get values, either from sibling Widgets this one is aligned to, or from container bounds.
        Separated out for better scope-control.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        void acquireReferencedAlignValues() {

            //Get index for quick access during compares; get value each time this method is called since value could change as
            //sibling widgets (earlier in parent's widgets-create-order) can be removed or moved in a way that affects this index.
            int     thisWidgetIndexInParent     = (_hasParent ? _parentWidget.indexOfWidget(this) : _applicationObject.indexOfWidget(this));
            int     siblingWidgetIndexInParent  = -1;
            bool    goodSibling     = false;
            String  alignToDimName  = '';
            num     translationAdj  = 0.0;

            //"top level" Widgets reside on our "Canvas".  Use that to get info if no Widget as parent.
            if (_hasParent) {
                _containerBounds = _parentWidget.getClientBounds();
            } else {
                _containerBounds = _applicationObject.canvasBounds;
            }

            _align.alignSpecs.forEach( (objAlignPart) {
            
                if ((objAlignPart.objToAlignTo != null) && (objAlignPart.dimension > eSides.None)) {
                    //If Aligning to a Sibling presumably... verify validity and acquire value if valid.

                    //make sure referenced widget is earlier in SVG node list than THIS widget.
                    //this implies both our object and sibling have same parent SVG element for starters..
                    if (objAlignPart.objToAlignTo.parentSVGElement != _parentSVGElement) {
                        throw new Exception('(acquireReferencedAlignValues)  ${objAlignPart.objToAlignTo.instanceName} not a direct Sibling of ${_instanceName}.' );
                    }

                    siblingWidgetIndexInParent = (_hasParent ? _parentWidget.indexOfWidget(objAlignPart.objToAlignTo) : _applicationObject.indexOfWidget(objAlignPart.objToAlignTo));

                    goodSibling = ((siblingWidgetIndexInParent < thisWidgetIndexInParent));

                    if (goodSibling) {
                        //Use our convenience arrays to get index into appropriate Part.Dim name
                        alignToDimName = eSides.Names[objAlignPart.dimension.toString()];

                        //if sibling being aligned to has had its position translated, we need to take that into account when aligning to it.
                        translationAdj = ( ('R,L,CX'.contains(alignToDimName)) ? objAlignPart.objToAlignTo.translateX: objAlignPart.objToAlignTo.translateY);

                        //our widget part's dimension value depends on the bounds-subcomponent value from the Widget we are aligned to (e.g., it's Margin.Left value)
                        objAlignPart.dimensionValue = (objAlignPart.objToAlignTo.metrics[objAlignPart.part][alignToDimName]) + translationAdj;

                        //Trace will include Widget data followed immediately by AlignSpec info
                        if (_applicationObject.trace(2)) {
                            logToConsole([
                                'LINE2',
                                TracingDefs['2'].tracePointDesc,
                                'LINE3',
                                this,
                                'LINE5',
                                "  (AlignSpec) referenced Widget's dimension = ${alignToDimName}; referenced Widget's part = ${eWidgetPart.Names[objAlignPart.part]}; referenced value = ${objAlignPart.dimensionValue};",
                                'LINE4',
                                'Referenced Widget (objToAlignTo) follows:',
                                objAlignPart.objToAlignTo,
                                'LINE2'
                            ]);
                        }

                    } else {
                        throw new Exception('(acquireReferencedAlignValues)  ${objAlignPart.objToAlignTo.instanceName} not a Sibling of ${_instanceName} in previous SVG Nodes.' );
                    }
                } else {
                    switch (objAlignPart.dimension) {
                        case eSides.R:
                            objAlignPart.dimensionValue = _containerBounds.R - _containerBounds.L;
                            break;
                        case eSides.L:
                            objAlignPart.dimensionValue = 0;
                            break;
                        case eSides.T:
                            objAlignPart.dimensionValue = 0;
                            break;
                        case eSides.B:
                            objAlignPart.dimensionValue = _containerBounds.B - _containerBounds.T;
                            break;
                        case eSides.CX:
                            objAlignPart.dimensionValue = _containerBounds.CX;
                            break;
                        case eSides.CY:
                            objAlignPart.dimensionValue = _containerBounds.CY;
                            break;
                        default:
                            objAlignPart.dimensionValue = 0;
                    }
                }
            }); //...forEach
        } //...AcquireReferencedSiblingValues



        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        We move from "outside" (outer-most boundary) to "inside" when performing bounds-calcs.
        When this method is first called, the outermost bounds Margin(WidgetBounds) has been computed.
        Then, we move toward ClientBounds (inner-most bounds) one layer at a time.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        void calcBounds() {

            /*
            ═══════════════════════════════════════════════════════════════════════════════════════
            Helper method. Both parms must be a valid eWidgetPart enumeration value (int)
            ═══════════════════════════════════════════════════════════════════════════════════════
            */
            void _calcSingleBounds(int boundsType, int prevBoundsType) {
                ObjectBounds ptrCurrBounds = _widgetMetrics[boundsType];
                ObjectBounds ptrPrevBounds = _widgetMetrics[prevBoundsType];

                ptrCurrBounds.T = ptrPrevBounds.T + ((_borders[prevBoundsType].T != null) ? _borders[prevBoundsType].T.width : 0 );
                ptrCurrBounds.R = ptrPrevBounds.R - ((_borders[prevBoundsType].R != null) ? _borders[prevBoundsType].R.width : 0 );
                ptrCurrBounds.B = ptrPrevBounds.B - ((_borders[prevBoundsType].B != null) ? _borders[prevBoundsType].B.width : 0 );
                ptrCurrBounds.L = ptrPrevBounds.L + ((_borders[prevBoundsType].L != null) ? _borders[prevBoundsType].L.width : 0 );
            }

            _calcSingleBounds(eWidgetPart.Outer,        eWidgetPart.Margin);
            _calcSingleBounds(eWidgetPart.Frame,        eWidgetPart.Outer);
            _calcSingleBounds(eWidgetPart.Inner,        eWidgetPart.Frame);
            _calcSingleBounds(eWidgetPart.Padding,      eWidgetPart.Inner);
            _calcSingleBounds(eWidgetPart.ClientBounds, eWidgetPart.Padding);
        } //...calcBounds



        acquireReferencedAlignValues();

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        X-Axis alignment code...
        Centering overrides others...
        If centered on an axis, other alignments along that axis make little sense.
        Likewise, anchors make zero sense on the same axis, as they would make the midpoint inaccurate.
        E.g., if aligned to center of X (CX), any alignment of right/left are ignored as this centering overrides.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        if (_align.CX.dimension != eSides.None) {
            ptrWidgetBounds.L   = _align.CX.dimensionValue - mTempAdjCX;
            ptrWidgetBounds.R   = _align.CX.dimensionValue + mTempAdjCX;
        } else {
            //handle right/left alignment:
            //are both sides NOT aligned to anything?
            if ((_align.L.dimension == eSides.None) && (_align.R.dimension == eSides.None)) {
                ptrWidgetBounds.L = _x;
                ptrWidgetBounds.R = mTempR;
            } else {
                if (_align.L.dimension != eSides.None) {
                    //Left align specified (right may be too...)
                    ptrWidgetBounds.L = _align.L.dimensionValue;

                    //anchors only make sense when one side is aligned and its opposite side is not... holds other side at specified position
                    if ( (_anchors & eSides.R) == eSides.R) {
                        ptrWidgetBounds.R = Math.max((ptrWidgetBounds.L + _width + 1), mTempR);  //prevent negative width
                    } else {
                        //see if Right align exists (since it is not mutually exclusive of Left align decision tree we are in)...
                        if (_align.R.dimension != eSides.None) {
                            ptrWidgetBounds.R = _align.R.dimensionValue;
                        } else {
                            ptrWidgetBounds.R = ptrWidgetBounds.L + _width;
                        }
                    }
                } else {
                    //some right alignment without any left alignment...
                    ptrWidgetBounds.R = _align.R.dimensionValue;

                    //anchors only make sense when one side is aligned and its opposite side is not... holds other side at specified position
                    if ( (_anchors & eSides.L) == eSides.L) {
                        ptrWidgetBounds.L = Math.min((ptrWidgetBounds.R - _width - 1), _x);  //prevent negative width
                    } else {
                        ptrWidgetBounds.L = ptrWidgetBounds.R - _width;
                    }
                }
            }
        } //...x-Axis alignment code...



        //Y-Axis alignment code...
        if (_align.CY.dimension != eSides.None) {
            ptrWidgetBounds.T   = _align.CY.dimensionValue - mTempAdjCY;
            ptrWidgetBounds.B   = _align.CY.dimensionValue + mTempAdjCY;
        } else {
            //handle top/bottom alignment
            //are both sides NOT aligned to anything?
            if ((_align.T.dimension == eSides.None) && (_align.B.dimension == eSides.None)) {
                ptrWidgetBounds.T = _y;
                ptrWidgetBounds.B = mTempB;
            } else {
                if (_align.T.dimension != eSides.None) {
                    //Top align specified (bottom may be too...)
                    ptrWidgetBounds.T = _align.T.dimensionValue;

                    //anchors only make sense when one side is aligned and its opposite side is not... holds other side at specified position
                    if ( (_anchors & eSides.B) == eSides.B) {
                        ptrWidgetBounds.B = Math.max((ptrWidgetBounds.T + _height + 1), mTempB);  //prevent negative Height
                    } else {
                        //see if Bottom align exists (since it is not mutually exclusive of Top align decision tree we are in)...
                        if (_align.B.dimension != eSides.None) {
                            ptrWidgetBounds.B = _align.B.dimensionValue;
                        } else {
                            ptrWidgetBounds.B = ptrWidgetBounds.T + _height;
                        }
                    }
                } else {
                    //some Bottom alignment without any Top alignment...
                    ptrWidgetBounds.B = _align.B.dimensionValue;

                    //anchors only make sense when one side is aligned and its opposite side is not... holds other side at specified position
                    if ( (_anchors & eSides.T) == eSides.T) {
                        ptrWidgetBounds.T = Math.min((ptrWidgetBounds.B - _height - 1), _y);  //prevent negative Height
                    } else {
                        ptrWidgetBounds.T = ptrWidgetBounds.B - _height;
                    }
                }
            }
        }  //...y-Axis alignment code...

        calcBounds();
    } //... _updateWidgetMetrics.




    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * If a widget's position has changed by way of movement, and thus altered the position of
    * the bounds of the Widget, any sibling widgets may have their bounds and/or position
    * affected *if* they aligned to this widget's bounds.
    *
    * This method finds any affected siblings and triggers realignment for them as needed.
    *
    * TODO: optimization required
    *
    * ### See Also
    *   * [align]
    *   * [reAlign]
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void reAlignSiblings() {
        _applicationObject.trace(3, this);

        Widget ptrWidget = null;
        int countWidgets = 0;

        int thisWidgetIndexInParent = (_hasParent ? _parentWidget.indexOfWidget(this) : _applicationObject.indexOfWidget(this));
        int tempSiblingCount        = (_hasParent ? (_parentWidget.getWidgetCount() - 1) : _applicationObject.getTopLevelWidgetsCount(thisWidgetIndexInParent));

        //if there are no potentially-aligned siblings, no need to continue
        if (tempSiblingCount == 0 ) return;

        var handle = _applicationObject.canvas.suspendRedraw(5000);

        if (_hasParent) {
            for (int i = thisWidgetIndexInParent + 1; i < tempSiblingCount; i++) {
                _parentWidget.getWidgetByIndex(i).reAlign();
            }
        } else {
            //We are aligning top-level sibling widgets
            countWidgets = _applicationObject.getWidgetCount();
            for (int i = thisWidgetIndexInParent + 1; i < countWidgets; i++) {
                ptrWidget = _applicationObject.getWidgetByIndex(i);
                if (!ptrWidget.hasParent) {
                    ptrWidget.reAlign();
                }
            }
        }

        //Performance optimization -- we can redraw now.
        _applicationObject.canvas.unsuspendRedraw(handle);
    } //...reAlignSiblings()



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * If a widget's [metrics] are changing by way of setting a property that could alter any
    * [ObjectBounds] values, any "owned" (child widgets) may have their bounds and/or
    * position affected. E.g., changes to [x], [y], [width], [height], [align], and [anchors]
    * can all have an effect on alignment and positioning.
    *
    * This method is recursive such that it traverses the owned-widgets hierarchy in order
    * to properly realign them all.
    *
    * ### See Also
    *   * [align]
    *   * [reAlignSiblings]
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void reAlign([int currentDepth = 0]) {

        //prevent superfluous recalculations if we are in a bulk-update state
        if ( (_widgetState & eWidgetState.Updating) == eWidgetState.Updating) return;

        int depth = ( (currentDepth == 0) ? 1 : currentDepth + 1);
        int tempChildCount = getWidgetCount();

        //Performance optimization -- don't redraw until necessary! This seems to nest OK (in recursive calls to ReAlign()
        //This makes a HUGE difference in rendering times!  Much like Delphi's BeginUpdate / EndUpdate abilities.
        var handle = _applicationObject.canvas.suspendRedraw(5000);

        _updateWidgetMetrics();   //Needed by any cascading re-alignments that call ReAlign;

        renderBordersAndBackground();

        //Call any descendant-specific realignment code (if there is any). See Placeholder extendedRealign() below...
        //By default there is an empty placeholder for extendedRealign(); child controls (e.g., Text / Foreign-Object)
        //may implement code needed to properly realign any self-created elements.
        extendedRealign();

        //Cascade to "owned" (child) widgets now... i.e., if this widget holds other widgets, they will need realigned since
        //their coordinate system is based on a translation (transform=translate(x,y)) within their containers translation, etc. (TODO: VISUAL DOC!)
        if (tempChildCount > 0) {
            if (depth == 1) {
                for (int i = 0; i < tempChildCount; i++) {
                    _widgetsList[i].reAlign(depth);
                }
            }
        }


        //Cascade alignment via any user assigned event-listener method, but prevent a recursive-events mess by confirming level...
        if (depth == 1) {
            _on.align(new NotifyEventObject(this));
        }

        //Performance optimization -- we can redraw now.
        _applicationObject.canvas.unsuspendRedraw(handle);
    } //...ReAlign()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Descendant-specific realignment code (if there is any). Called during move().
    This empty placeholder for extendedRealign() can be overridden in child controls
    (e.g., Text / Foreign-Object) that may implement code needed to properly realign
    any self-created elements (i.e., non-widget elements).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void extendedRealign() {
        _applicationObject.trace(1, this);
    }



    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Callback handlers...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    handleIsMovableIsSizableChanges (callback fired from _IsMovable/_IsSizable changehandler)

    If a widget is neither movable nor sizable along either axis, remove the event listener
    (mousedown) that would allow either dynamic.
    Otherwise, setup necessary mousedown event-listener on Widget's SVG group, which will
    handle further setup of mousemove, mouseup listeners when a dynamic event triggers it.

    We change default cursor over the Widget to "move" type; the "move" cursor was intentionally
    chosen here because if both movable and sizable are set, the property set last will dictate
    which cursor appears on hover (thus, unpredictable); we can alter cursor during Move to
    be appropriate one, since at that point we know the user's intention.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void handleIsMovableIsSizableChanges() {
        if ((!_isSizable.x) && (!_isSizable.y) && (!_isMovable.x) && (!_isMovable.y)) {
            _borders.allBordersSVGGroupElement.on.mouseDown.remove(mouseDownHandler);
            _entireGroupSVGElement.attributes['cursor'] = 'default';
            _isSelectable = false;
            return;
        }

        _borders.allBordersSVGGroupElement.attributes['cursor'] = 'move';
        _borders.allBordersSVGGroupElement.on.mouseDown.add(mouseDownHandler);
        _isSelectable = true;
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    handleAlignmentChanges (callback fired from _Align changehandler)

    Any changes to alignment specification implies a need to perform realignments and
    update visuals.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void handleAlignmentChanges() {
        if (_visible) {
            rePaint();
        }
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    handleCSSChanges (callback fired from classesCSS changehandler)

    Any changes to CSS specifications could affect visual stying as well as imply
    a need to perform realignments and such (if CSS was used to affect metrics, e.g.,
    by altering border-widths).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void handleCSSChanges() {
        _cssChangedSinceRepaint = true;

        _applicationObject.trace(4, this);
        _applicationObject.trace(4, ">> _cssChangedSinceRepaint=${_cssChangedSinceRepaint}  _visible=${_visible}");

        if (_visible) {
            rePaint();
        }
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    handleSizeRuleChanges (callback fired from _SizeRules changehandler)

    Any changes to sizing specification MAY imply a need to perform realignments and
    update visuals. Although the code at first glance may appear to do nothing,
    we are using Width/Height "setters" to catch catch any changes to Sizing constraints.
    See set Width and set Height methods; this should all make sense then.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void handleSizeRuleChanges() {
        if (_visible) {
            width = _width;
            height= _height;
        }
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Default Event processing methods.
    These are "extended" via associated, assignable, user-defined On(Event) callbacks.
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    By default, we make a mouse-click event available for the whole Widget.
    The border-region mouse-handling will override this, but the "center" of the Widget
    will remain clickable (for buttons).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void mouseClick(MouseEvent event) {
        //Process any potential user-assigned click event code
        _on.mouseClick(new MouseNotifyEventObject(this, event));
    } //MouseClick



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    When any UI interaction is initiated with the left-mouse button being depressed, this
    event code fires. Determine intention based on further examination of simultaneously
    depressed key(s).

    Additional depressed-key meanings:
        ALT: indicates resize attempt
        SHIFT: indicates multi-select mode

    ═══════════════════════════════════════════════════════════════════════════════════════
    "Select" / "Multi-Select" notes:
    "Selection(s)" are maintained by within a list property on our Application object.
    The mousedown action will "select" the currently clicked-on widget. In non-shift-key mode,
    we simply set this widget as the only selected Widget.

    If shift-key is depressed, we are in multi-select mode, and we add to our existing selection(s)
    (or remve from, if an already-selected widget is shift-clicked again). The application
    list-managment routine includes logic to prevent effective "doubling+" of a selection,
    by making sure that hierarchically-owned selections are removed automatically.
    See notes in Application(class).AddWidgetToSelection(method) for more details.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void mouseDown(MouseEvent event) {
        event.stopPropagation();

        //if no options exist that allow "selecting", get out of here (i.e., no aspect of Widget is movable/sizable)
        if (!_isSelectable) {_isSelected = false; return;}

        //if the ALT key is down when the MouseDown occurs, we are attempting to start a resize.
        bool isSizingAttempt    = (event.altKey);
        bool isMovingAttempt    = !isSizingAttempt;
        bool isMultiSelect      = (event.shiftKey);

        //clear any existing selection if not in multi-select mode
        if (!isMultiSelect) {_applicationObject.clearWidgetSelection();}

        _isSelected = ((!isMultiSelect) || (_applicationObject.addWidgetToSelection(this)));

        //Trace to dump selected Widget(s) info...
        if (_applicationObject.trace(5)) {
            logToConsole([
                'LINE2',
                TracingDefs['5'].tracePointDesc,
                'LINE3'
            ]);
            _applicationObject.selectedWidgetsList.forEach( (widg) {logToConsole(["SelectedWidgetsList[item] = ${widg.instanceName}"]); });
        }

        //Don't allow the initiation of a move or resize on a non-selected item. This prevents double-move of "owned" (unselectable)
        if (!_isSelected) return;

        //Process any potential user-assigned OnMouseDown event code
        _on.mouseDown(new MouseNotifyEventObject(this, event));

        //TODO: CLEANER WAY?  This is a hack to address how there is no easy way to detect if a user left the "stage" (i.e., took mouse outside browser/canvas),
        //thus leaving potentially hanging event listeners.
        _applicationObject.canvas.on.mouseMove.remove(mouseMoveHandler);
        _applicationObject.canvas.on.mouseUp.remove(mouseUpHandler);

        //get out of here if not a valid action on this widget widget.
        if (isMovingAttempt && (!_isMovable.x) && (!_isMovable.y) ) return;
        if (isSizingAttempt && (!_isSizable.x) && (!_isSizable.y) ) return;

        _dragStartX = event.clientX;
        _dragStartY = event.clientY;

        //if we are moving a Widget, and it is movable along an axis that would make alignments along that axis meaningless, clear alignment that would no longer be meaningful
        if (isMovingAttempt) {
            _widgetState = _widgetState + ( ( (_widgetState & eWidgetState.Moving) == eWidgetState.Moving) ? 0 : eWidgetState.Moving);

            if (_isMovable.x) {
                _x = _widgetMetrics.Margin.L;   //our Widget's Left-most Bounds
                _align.clearAlignsOnAxisX();  //if we want something to remain aligned "relative" after moving, bypass this line.  TODO??
            }

            if (_isMovable.y) {
                _y = _widgetMetrics.Margin.T;   //our Widget's Top-most Bounds
                _align.clearAlignsOnAxisY();
             }

            //Widget shall be more transparent during movement
            _entireGroupSVGElement.attributes['opacity'] = '0.7';
        } else {
            _widgetState = _widgetState + ( ( (_widgetState & eWidgetState.Sizing) == eWidgetState.Sizing) ? 0 : eWidgetState.Sizing);

            //Border shall be more transparent during movement
            _borders.allBordersSVGGroupElement.attributes['opacity'] = '0.6';
        }

        //Although mousedown is trapped on particular Widget, we need to trap mousemove/mouseup events
        //all over since user can move mouse quicker than event-loop-cycle, and thus the cursor-pos
        //and associated events can fall somewhere outside of widget, but are still ours to handle.
        _applicationObject.canvas.on.mouseMove.add(mouseMoveHandler);
        _applicationObject.canvas.on.mouseUp.add(mouseUpHandler);
    } //... MouseDown()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    We could be tracking mouse movements for either:
        1) a widget being moved, or
        2) a widget being resized

    The mouseDown event code determines which of these two scenarios we are currently in,
    and has set the widget state accordingly.  Furthermore, we may be in a multi-selected
    move operation.

    Quirks & Behavior Notes:
    Chrome changes the cursor to text-select during movement whereas FF works just fine.
    There is no easy 'fix' for this.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void mouseMove(MouseEvent event) {
        event.stopPropagation();
        _applicationObject.trace(6, this);

        //Get difference in position since last processed mousemove (or initial mousedown)...
        num offsetX = event.clientX - _dragStartX;
        num offsetY = event.clientY - _dragStartY;

        //Latest coordinates become new "start" pos...
        _dragStartX = event.clientX;
        _dragStartY = event.clientY;

        //Update position or sizing...
        if ( (_widgetState & eWidgetState.Moving) == eWidgetState.Moving) {
            move(offsetX, offsetY, event);

            //Process any potential user-assigned code to trigger upon move
            _on.move(new MouseNotifyEventObject(this, event));

            //If multi-select (shift key) was used prior/during move-initiation, move all selected by the same amount...
            //Note: the called Move() method will only move those whose constrains allow.
            if (event.shiftKey) {
                _applicationObject.selectedWidgetsList.forEach( (widgetToMove) {
                    //prevent double-move of this widget (since, it CAN be in the "selected" list)
                    if (widgetToMove.instanceName != _instanceName) {
                        widgetToMove.move(offsetX, offsetY);
                    }
                });
            }
        } else {
            //Adjust Width/Heigh via "setter" so as to enforce our SizeRules and force repaint
            width    = _width   + offsetX;
            height   = _height  + offsetY;
        }

        //Process any potential user-assigned event code to run on ANY mousemove (not just a Widget "move")
        _on.mouseMove(new MouseNotifyEventObject(this, event));

        //Need to make sure any subclass-implmented alignment occurs for THIS widget
        extendedRealign();

        //Handle any potentially-affected sibling alignments : TODO: Optimize!!
        reAlignSiblings();

    } //... mouseMove()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    When a MouseUp event is detected, we have detected the end of either:
        1) a widget being moved, or
        2) a widget being resized

    The MouseDown event code determines which of these two scenarios we are currently in,
    and has set the widget state accordingly.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void mouseUp(MouseEvent event) {
        //test for null because we programatically call MouseUp to abort Move() that would otherwise violate PosRules
        if (event != null) {event.stopPropagation();}

        _applicationObject.canvas.on.mouseMove.remove(mouseMoveHandler);
        _applicationObject.canvas.on.mouseUp.remove(mouseUpHandler);

        //Process any potential user-assigned event code to occur on mouse up
        _on.mouseUp(new MouseNotifyEventObject(this, event));

        //Restore opacity after movement/sizing (if Move, entire widget effects applied, otherwise just border);
        //TODO: Get values from CSS -- Application-wide setting.
        if ( (_widgetState & eWidgetState.Moving) == eWidgetState.Moving) {
            _entireGroupSVGElement.attributes['opacity'] = '1.0';
            _widgetState = _widgetState - eWidgetState.Moving;
        } else {
            _borders.allBordersSVGGroupElement.attributes['opacity'] = '1.0';
            _widgetState = _widgetState - ( ( (_widgetState & eWidgetState.Sizing) == eWidgetState.Sizing) ? 0 : eWidgetState.Sizing);
        }
    } //... mouseUp()


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    BEGIN: Other misc methods
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Move Widget a specified distance along the X and/or Y axes according to the
    * values in [shiftX] and [shiftY] respectively *if* allowed per any constraints imposed
    * on this widget (see: [isMovable]).  Negative values for X/Y shift values move
    * Widget Left and Up respectively, while positive values move Right and Down respectively.
    * [MouseEvent] information is optionally passed in via [event] parameter.
    *
    * As compared to [reAlign], moving does not incur issues of *internal* realignment;
    * i.e., any owned child-widgets are moved in conjunction with this widget since they belong
    * to SVG child node(s) whose coordinate systems are *relative* to this widget's coordinate system,
    * and during a [move] operation, this widget's coordinate system remains internally static
    * since we are simply using an SVG 'transform=translate' to accomplish a visual "shift"
    * of position of the entire Widget relative to *its* parent-SVG-container.
    *
    * Since [move] is just doing a *translation of position* for the entire widget and its contents,
    * this does mean that alignment bounds will be changing for any *siblings* that align to
    * this widget; as such, executing [reAlignSiblings] will be necessary after a move
    * (if any siblings exist and are aligned to one or more bounds of *this* Widget). If the
    * [move] method was called internally via [mouseMove], the call to [reAlignSiblings] has
    * been handled already in that method.
    *
    * When testing whether a the cursor is "over" our widget (in range) during movement, if [event] is null,
    * we're performing a programmatic move, so cursor-pos is irrelevant.  Next, we only test
    * "over" on a per-axis basis, so as to mimic most Windows(tm) applications that allow moving
    * things like a scrollbar even if you slip off the trackbar a bit or whatever.
    *
    * ## NOTES:
    * The logic (in this method), for acceptProposedX/Y, checks to see if the proposed new position is within
    * bounds returned by [posRules] min/max callbacks; notice that it *also* includes an examination
    * of the [shiftX] and [shiftY] values.  This is done to accommodate the condition where a Widget is
    * already positioned in a location that is not within the specified min/max values, and
    * *if* is out of range, we allow it to move only *toward* a location that would be within
    * our constrained location.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void move(num shiftX, num shiftY, [MouseEvent event]) {
        final num closeEnough = 50.0; //a little "slack" for a bit stickier edge during moves in case mouse gets out infront of event processor a bit
        num proposedTranslateX  = _translateX + shiftX;
        num proposedTranslateY  = _translateY + shiftY;
        num proposedX           = _x + proposedTranslateX;
        num proposedY           = _y + proposedTranslateY;

        if ((_isMovable.x) && (shiftX != 0.0)) {
            bool isCursorInWidgetRangeX = (event == null) ||
                ((event.clientX >= (xAsClientX - (shiftX > 0 ? 0 : closeEnough))) && (event.clientX <= (xAsClientX + _width + (shiftX < 0 ? 0 : closeEnough))));

            num minX                = _posRules.getMinX(new MouseNotifyEventObject(this, event));
            bool acceptProposedX    = ((minX == null) ? true : ((proposedX >= minX) || (shiftX > 0)));
            num maxX                = _posRules.getMaxX(new MouseNotifyEventObject(this, event));
            acceptProposedX         = acceptProposedX && ((maxX == null) ? true : ((proposedX <= maxX) || (shiftX < 0)));

            _applicationObject.trace(7, this);
            _applicationObject.trace(7, "  >> isCursorInWidgetRangeX = ${isCursorInWidgetRangeX};  acceptProposedX = ${acceptProposedX};  xAsClientX = ${xAsClientX};  event.clientX = ${event.clientX};");

            if  (acceptProposedX && isCursorInWidgetRangeX) {
                _translateX = proposedTranslateX;
            }
        }

        if ((_isMovable.y) && (shiftY != 0.0)) {
            bool isCursorInWidgetRangeY = (event == null) ||
                ((event.clientY >= (yAsClientY - (shiftY > 0 ? 0 : closeEnough))) && (event.clientY <= (yAsClientY + _height + (shiftY < 0 ? 0 : closeEnough))));

            num minY                = _posRules.getMinY(new MouseNotifyEventObject(this, event));
            bool acceptProposedY    = ((minY == null) ? true : ((proposedY >= minY) || (shiftY > 0)));
            num maxY                = _posRules.getMaxY(new MouseNotifyEventObject(this, event));
            acceptProposedY         = acceptProposedY && ((maxY == null) ? true : ((proposedY <= maxY) || (shiftY < 0)));
            if  (acceptProposedY && isCursorInWidgetRangeY) {
                _translateY = proposedTranslateY;
            }
        }

        _entireGroupSVGElement.attributes['transform'] =
             'translate(${((_hasParent ? _parentWidget.getClientBounds().L : 0 ) + _translateX)},${((_hasParent ? _parentWidget.getClientBounds().T : 0 ) + _translateY)}), scale(1,1)';

    } //... move()



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Call beginUpdate prior to initiating mass property changes.
    *
    * beginUpdate/endUpdate exist to prevent superfluous, and potentially "expensive",
    * realignments and visual updates such during bulk property-changes.
    *
    * ## See Also
    *    * [endUpdate] — the other half of the beginUpdate/endUpdate sequence.
    *    * [eWidgetState] — offers further insight into various states.
    *
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void beginUpdate() {
        if ( (_widgetState & eWidgetState.Updating) == eWidgetState.Updating) return;       //already in Updating state

        _widgetState = _widgetState + eWidgetState.Updating;
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Call endUpdate to signal the end of mass property changes;
    * endUpdate will then start the visual recalc / repaint sequence and apply outstanding
    * changes.
    *
    * beginUpdate/endUpdate exist to prevent superfluous, and potentially "expensive",
    * realignments and visual updates such during bulk property-changes.
    *
    * ## See Also
    *    * [beginUpdate] — the other half of the beginUpdate/endUpdate sequence.
    *    * [eWidgetState] — offers further insight into various states.
    *
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void endUpdate() {
        if ( !( (_widgetState & eWidgetState.Updating) == eWidgetState.Updating) ) return;  //already not in Updating state

        _widgetState = _widgetState - eWidgetState.Updating;
        rePaint();
    }



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    The following are various helper-functions for accessing Widget-List information that
    would otherwise be private.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */

    /**
    * Quick access to the value of private _widgetsList.length;
    */
    int getWidgetCount() {
        return _widgetsList.length;
    }

    /**
    * Return the [Widget] reference stored in private _widgetsList at [indexOfObjectToGet].
    */
    Widget getWidgetByIndex(int indexOfObjectToGet) {
        return _widgetsList[indexOfObjectToGet];
    }

    /**
    * Return the index of the [widgetToLocateInList] stored in private _widgetsList.
    */
    int indexOfWidget(Widget widgetToLocateInList) {
        return _widgetsList.indexOf(widgetToLocateInList);
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Adds [Widget] instance reference specified in the [widgetToAdd] parameter
    * to our private _widgetsList.
    *
    * Unlike [Application.addWidget] method, this addWidget method does not need to test the
    * added Widget instanceName for uniqueness and type-checking. Each Widget has *already*
    * passed such tests (during construction) and has completed the [Application.addWidget]
    * processing.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void addWidget(Widget widgetToAdd) {
        _widgetsList.add(widgetToAdd);
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * If a given [instanceNameToRemove] exists in our object's private _widgetsList,
    * remove it.
    *
    * This method is called from [Widget.destroy] — i.e., our destructor — **by the
    * hierarchically "owned" Widget being destroyed (i.e., a child of this widget)**.
    * This list is intentionally *private*, as there could be substantial negative
    * consequences for calling this from outside Widgets themselves.
    *
    * Basically, this provides a way for a to-be-deleted "owned"/child widget to remove
    * itself from its parent Widget's _widgetsList when it is destroyed.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void _removeWidget(String childInstanceNameToRemove) {
        int indexToRemove = indexOfInstanceName(_widgetsList, childInstanceNameToRemove);

        if (indexToRemove > -1) {
            _widgetsList.removeRange(indexToRemove, 1);
        }
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Convenience method that returns reference to [Widget.metrics.ClientBounds] object.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    ObjectBounds getClientBounds() {
        return _widgetMetrics.ClientBounds;
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Make the Widget visible to user.
    *
    * Sets attributes on the Widget's [entireGroupSVGElement] — i.e., the outermost visual
    * SVG container object within which all renderable visual objects for the Widget are
    * hierarchically contained — such that the Widget is "Showing". The [widgetState] is
    * updated to include [eWidgetState.Showing].
    *
    * Event hooks exist herein for [Widget.on.beforeShow] and [Widget.on.show].
    *
    * When method *first* shows Widget content, the [widgetState] is transitioned
    * out of [eWidgetState.Loading] and into [eWidgetState.Normal].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void show() {
        //call any user-provided method that fires before our standard show
        _on.beforeShow(new NotifyEventObject(this));

        setSVGAttributes(_entireGroupSVGElement, {
            'display'       : 'inherit',
            'visibility'    : 'visible'
        });

        _visible = true;

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        During initial loading, make sure the Repaint does full CSS-recalcs and such.
        Otherwise, property-change routines or EndUpdate should have handled this if needed.
        Also, if initial show, transition our state from loading to normal.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        if ( (_widgetState & eWidgetState.Loading) == eWidgetState.Loading) {
            //set flag to force RePaint to include CSS recalcs
            _cssChangedSinceRepaint = true;
            rePaint();

            _widgetState = _widgetState - eWidgetState.Loading;
            _widgetState = _widgetState + eWidgetState.Normal;
        }

        //call any user-provided method
        _on.show(new NotifyEventObject(this));

        _widgetState = _widgetState + ( ( (_widgetState & eWidgetState.Showing) == eWidgetState.Showing) ? 0 : eWidgetState.Showing);
    } //...Show()



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Essentially the opposite of [show]. Likewise, the [widgetState] is
    * updated to omit [eWidgetState.Showing].
    *
    * Event hooks exist herein for [Widget.on.hide].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void hide() {
        _entireGroupSVGElement.attributes['display'] = 'none';

        _visible = false;

        //Call any user-method to occur when Widget is hidden.  This is perfect place to prep for re-alignment, etc.
        _on.hide(new NotifyEventObject(this));

        _widgetState = _widgetState - ( ( (_widgetState & eWidgetState.Showing) == eWidgetState.Showing) ? 0 : eWidgetState.Showing);

    } //...hide()



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    When first setting up and instantiating a widget, this is executed.
    Essentially, we just moved some chunks of logic out of constructor into here.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _create() {

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Start building the svg structure for the widget now...
        Create the SVG group (g element) with unique name based on per InstanceName and TypeName
        This will hold entire Widget's graphical contents

        Note: the _entireGroupSVGElement is created in a "hidden" visibility state as opposed to
        using display:none due to the fact that Webkit will crash (aw-snap) if this element
        is not part of the rendering tree when various initial operations are performed on it
        (e.g., especially in sub-classes that add an FO with DOM objects).
        Remember, the SVG default state of the display attribute is "inherit", as it will be here.
        Once this wideget is "shown" (via show()), we can rely just on using the cascading
        visual inheritance of disply:inherit/none without a problem.
        TODO: Test the above assertion with post-show-DOM-mods-to-FO-contained-objects yet.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _entireGroupName       = "${_instanceName}_${_typeName}";
        _entireGroupSVGElement = new SVGElement.tag('g');
        _entireGroupSVGElement.attributes = {
            'id': _entireGroupName,
            'visibility'    : 'hidden'
             //,  'pointer-events' : 'none'  //TODO?  And, enable as appropriate on show()
        };

        _parentSVGElement.nodes.add(_entireGroupSVGElement);
        _entireGroupSVGElement.on.click.add(mouseClickHandler);

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        We create a separate "Fill" element (rect) in case a fill (color) is specified via our Color property.
        This will always be the first element in our Widget's group since we want its z-order to be behind other elements.
        This rect will have stroke-width of zero/transparent.
        Note: rect will ultimately be sized such that only inner-region of Widget (i.e., all but margin) will have a fill-color.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _bgRectSVGElement = new SVGElement.tag('rect');
        _bgRectSVGElement.attributes = {
            'id'        : '${_entireGroupName}_Background',
            'display'   : 'inherit'
        };
        _entireGroupSVGElement.nodes.add(_bgRectSVGElement);

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Append our embedded group for the borders so we can easily add events to *all*
        border-types at once (for resize/etc).
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _entireGroupSVGElement.nodes.add(_borders.allBordersSVGGroupElement);


        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Embed the svg element that will hold all Client (i.e., Child) Widgets;
        this will always be last child (node) in a Widget's group
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _clientSVGElement = new SVGElement.tag('svg');
        _clientSVGElement.attributes = {'id' : '${_entireGroupName}_ClientSVG'};
        _entireGroupSVGElement.nodes.add(_clientSVGElement);


        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Embed a rect element be shown only when a widget is "selected".
        As with entire group element, start this one out as hidden (vs. display:none);
        the Application class addWidgetToSelection routine will make visible, and the app's
        un-select routine(s) will then use display:none (again, this is to make sure the
        selection rect is part of the rendering-tree initially; avoids aw-snap! errors)
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _selectionRect = new SVGElement.tag('rect');
        _selectionRect.attributes = {
            'id'            : '${_entireGroupName}_SelectionRect',
            'class'         : 'SelectedWidget',
            'pointer-events': 'none',   //we want all events to "pass through" this overlay
            'visibility'    : 'hidden'
        };
        _entireGroupSVGElement.nodes.add(_selectionRect);


        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Grab defaults from app-level; can be overriden per instance if needed.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        _showHint   = _applicationObject.showHint;
        _hintPause  = _applicationObject.hintPause;

    } //...Create()


    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * DESTRUCTOR
    *
    * To fully remove a [Widget] from an [Application], the implementor must:
    *
    *    1. call [destroy]
    *    2. set the destroyed-Widget reference to [null]
    *
    * This destructor also recursively removes any "owned" widgets as part of this process.
    * References to this Widget and its hierarchically-owned Widgets are removed
    * from the [Application.widgetList].
    *
    * In addition, we null our owned-widget references so (theoretically) the Dart VM can
    * perform GC on those objects and all the objects they created.
    * Finally, we also remove this Widget from this widget's [parentWidget]'s private
    * owned-widgets-list (_widgetsList).
    *
    * Note: although the Browser and Dart VM will have to perform proper Garbage Collection (GC)
    * to truly "free" memory, this destroy method should take care of cleaning up the
    * SVG DOM element(s), and any other references that have been created by the widget,
    * to so enable effective GC.
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    void destroy([int currentDepth = 0]) {
        //This will cause a recursive call to Destroy on any owned widgets as needed.
        _widgetsList.forEach( (widget) {
            widget.destroy(currentDepth + 1);
            widget = null;
        });

        //removing our SVG G (group) should blast all child SVG objects.
        //TODO: is this truly good enough for browser to effectively GC?
        _entireGroupSVGElement.remove();

        //clear reference to *this* Widget in our parentWidget's list of "owned" widgets.
        //Only needed on first level (not in recursion-descended destructors)
        if (currentDepth == 0)  {
            if (_parentWidget != null) {
                _parentWidget._removeWidget(_instanceName);
            }
        }

        //clear references to this widget at app-level
        _applicationObject.removeWidget(_instanceName);
    }



    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * Constructs an Widget object after performing required validations.
    * Creates various owned-objects, initializes various properties, adds itself to
    * the [Application.widgetsList], creates the initial SVG structures used by the Widget,
    * and wires-up some standard event-handlers in preparation for use.
    *
    * ### Parameters
    *    * [String] instanceName: arbitrary name assigned by user to this Widget instance (e.g., "myWidget").
    *    * [Application] appInstance: reference to required Application instance.
    *    * [Widget] parentInstance: (optional) the Widget which hierarchically owns this one.
    * A null value will create a Widget without a parent (i.e. a Widget that
    * resides directly on our "canvas" at the highest level).
    *    * [String] typeName: used for various identification purposes (in SVG constructs, etc.)
    *
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    Widget(String instanceName, Application appInstance, [Widget parentInstance = null, String typeName = 'Widget']) :
        //CREATE THE PLETHORA OF EMBEDDED CLASSES A WIDGET USES...
        _isMovable      = new WidgetDynamics(),
        _isSizable      = new WidgetDynamics(),
        _sizeRules      = new WidgetSizeRules(),
        _posRules       = new WidgetPosRules(),
        _containerBounds= new ObjectBounds(),
        _borders        = new WidgetBorders("${instanceName}_${typeName}"),
        _widgetMetrics  = new WidgetMetrics(),
        _align          = new WidgetAlignment(),
        _on             = new EventsProcessor(),

        //Create list to track Widgets owned by this Widget
        _widgetsList    = new List<Widget>(),

        //Create list to hold our CSS-Stylable properties.  Subclasses will add entries to this.
        _stylablePropertiesList     = new List<StyleTarget>(),

        classesCSS      = new CSSTargetsMap()

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    body of constructor starts here...
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    {
        _instanceName       = instanceName;
        _typeName           = typeName;

        if (appInstance is! Application) {
            throw new InvalidTypeException('_InstanceName (Widget) Constructor : appInstance creation parameter is not an instance of Application.',  'Application', appInstance);
        }

        _applicationObject  = appInstance;

        /*
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        InstanceName uniqueness is enforced at the Application level.
        Add our Instance to application object; test for any violation of unique name constraint.
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        */
        try {
            //set member property before AddWidget, or InstanceName will be non-existence during add!
            _applicationObject.addWidget(this);
        }
        catch (e) {
            if (e is UniqueConstraintException) {
                throw new Exception("${e} \n Attempt to create new Widget instance (of Type: ${_typeName} with duplicate InstanceName: ${_instanceName})");
            }
            else {
                print ("${e}");
                throw new Exception('${_instanceName} Severe error while setting InstanceName');
            }
        } //catch

        //Test validity of parent, if specified, and raise exception if specified parent obj not proper type
        if ((parentInstance != null) && (parentInstance is! Widget)) {
            throw new InvalidTypeException('(${_instanceName}) Invalid Widget Constructor: specified Parent-Instance value is neither null nor an instance of Widget.',  '[Widget]', parentInstance);
        }

        if (parentInstance != null) {
            _parentWidget       = parentInstance;
            _hasParent          = true;
            _parentSVGElement   = _parentWidget.clientSVGElement;
            _parentWidget.addWidget(this);
            _hierarchyPath      = "${_parentWidget.hierarchyPath},${_instanceName}";
        } else {
            _parentSVGElement   = _applicationObject.canvas;
            _hierarchyPath      = "${_instanceName}";
        }


        /*
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        TODO-REF#1: SEARCH ABOVE FOR DESCRIPTION; This is dart-issue 144 workaround.
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        */
        mouseDownHandler    = mouseDown;
        mouseClickHandler   = mouseClick;
        mouseMoveHandler    = mouseMove;
        mouseUpHandler      = mouseUp;


        //Create initial values for CSS-to-Stylable-targets map
        //Indexed on CSS-stylable targets name; initial/default class-selector-values use same name.
        classesCSS.initialize(mapInitialClassesCSS);

        //Setup our CSS "stylable targets"
        _loadStylablePropertiesList();

        //Time to make the default SVG objects we'll be using to render a Widget.
        _create();


        /*
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        setup callbacks required by these objects...
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        */
        _isMovable.changeHandler    = handleIsMovableIsSizableChanges;
        _isSizable.changeHandler    = handleIsMovableIsSizableChanges;
        _sizeRules.changeHandler    = handleSizeRuleChanges;
        classesCSS.changeHandler    = handleCSSChanges;

        _align.alignSpecs.forEach( (objAlignPart) {
            objAlignPart.changeHandler = handleAlignmentChanges;
        });

    } //constructor

} //class Widget


/* HOLDING AREA FOR CODE THOUGHTS...
    //Cursor changes to reflect state centralized here.
    switch (_WidgetState) {
        case eWidgetState.Moving:
            mGroupElementRef.attributes['cursor'] = 'move';
            break;
        case eWidgetState.Sizing:
            mGroupElementRef.attributes['cursor'] = 'e-resize'; //TODO: Need to know which side(s) are involved!
            break;
        default:
            mGroupElementRef.attributes['cursor'] = 'default';
    }
*/
