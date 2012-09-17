/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: MISC Visual-Constraints CLASSES applicable to Widgets.
E.g., sizing and movement constraints (i.e., dynamics), Alignment, etc.
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
* A [Widget] instance will test these DynamicsConstraint x/y properties (flags) during
* the [Widget.mouseDown] and [Widget.move] methods to make sure only those move/size
* attempts per [Widget.isSizable] and [Widget.isMovable] x/y rules are permitted.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class DynamicsConstraint {
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

} //class DynamicsConstraint



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
*       Align.R = {objToAlignTo:SiblingWidget1, Part:eWidgetPart.FRAME, Dimension:eSides.L}
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
    int             _part           = eWidgetPart.MARGIN;    //enumeration eWidgetPart (int); by default, Widget-boundary is the part being aligned to something
    int             _dimension      = eSides.NONE;           //enumeration eSides (int); the Side(of objToAlignTo if not null, or container side otherwise) to which we are aligning was Dimension.
    num             dimensionValue  = 0.0;
    ChangeHandler   changeHandler;

    AlignSpec() {
    }

    ///Helper method to quickly "reset" fields to their default values.
    void resetAlignSpec() {
        _objToAlignTo   = null;
        _part           = eWidgetPart.MARGIN;
        _dimension      = eSides.NONE;
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
    List<AlignSpec> alignSpecs  = new List<AlignSpec>();
    AlignSpec T     = new AlignSpec();
    AlignSpec R     = new AlignSpec();
    AlignSpec B     = new AlignSpec();
    AlignSpec L     = new AlignSpec();
    AlignSpec CX    = new AlignSpec();
    AlignSpec CY    = new AlignSpec();

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
    WidgetAlignment()
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
