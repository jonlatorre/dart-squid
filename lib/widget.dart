/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: Widget Class
This is the primary UI Component in this framework.  The "base" control.
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
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    This group of variables obtains/requires values directly from constructor parameters...
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */

    String          _instanceName       = '';
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Each Widget must have a unique, across entire [Application] [instanceName].
    * This value is set inside the constructor; this is read-only accessor.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    String          get instanceName    => _instanceName;


    //Setting ApplicationObject post-creation could have really bad implications. Prevented.
    Application     _applicationObject  = null;
    ///Reference to [Application] object specified during constructor.
    Application get applicationObject   => _applicationObject;


    Widget          _parentWidget       = null;
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * (optional / null-able) This value is set in the constructor.
    * IF non-null, this Widget has a [ParentWidget] that is a Widget (or subclass thereof)
    * that "owns" this one. The Owner's SVG structure appears hiearchically "above", and
    * contains within it, this Widget's SVG rendering elements.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    Widget          get parentWidget    => _parentWidget;


    String          _typeName           = 'Widget';
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Each Widget must have an appropriate (component) [typeName].
    * This value is set in the constructor; sub-classes pass via constructor parm.
    * Along with [instanceName], this value is used to form unique
    * SVG-element identifiers (i.e., element "id" attribute values).
    *
    * TODO: Will "mirrors" typeMirror be available for this? .simpleType or Object.runtimeType (as in dartdocs)?
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    String          get typeName        => _typeName;

    //Object is created in constructor due to need to pass this's [instanceName] along for border-SVG-element "id" attributes.
    WidgetBorders   _borders            = null;



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    And now, everything else...

    Variables exposed as READ-WRITE properties (via "getters" and "setters") are to be set
    after Widget constructor has finished and prior to Show() when possible (for speed);
    post-Show() property-changes often trigger visual updates unless noted otherwise.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */

    bool            _hasParent          = false;    //denormalized result of test for parent
    ///When [false] this Widget instance resides directly on our [Application.canvas], otherwise it is a child of [parentWidget].
    bool            get hasParent       => _hasParent;


    String          _hierarchyPath      = '';
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * [parentWidget.hierarchyPath] + '_' + this widget's [instanceName].
    *
    * So, as widget-nesting-depth grows, this string grows to include all instanceNames
    * appearing (hierarchically) "above" it. It will be unique throughout application
    * with a value of: `(0:n)[ParentInstanceName,]InstanceName`
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    String          get hierarchyPath   => _hierarchyPath;


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
    List<Widget>    _widgetsList        = new List<Widget>();


    SVGElement      _clientSVGElement   = null;
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Reference to an SVGElement we created during the Widget initialization process that
    * is available as a container for any hierarchically "owned" (aka, "client") Widgets' SVG.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    SVGElement  get clientSVGElement        => _clientSVGElement;


    SVGElement      _selectionRect      = null;
    ///Widget's placeholder selection-rect; hidden unless Widget is currently "selected"
    SVGElement  get selectionRect           => _selectionRect;


    SVGElement      _parentSVGElement   = null;
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * If [hasParent], stores reference to [SVGElement] in which this Widget's generated-SVG
    * element(s) reside (i.e., hierarchically embedded); otherwise, our
    * default SVG-materialization target-element will be our [Application.canvas].
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    SVGElement      get parentSVGElement    => _parentSVGElement;


    //enumeration eWidgetState (int); additive/multi-state; beginUpdate/endUpdate methods use too.
    int             _widgetState            = eWidgetState.LOADING;
    ///See: [eWidgetState] for details.
    int             get widgetState         => _widgetState;


    SVGGElement     _entireGroupSVGElement  = null;
    ///Reference to the group (SVG "g" element) this ENTIRE Widget's SVG will be rendered into.
    SVGGElement get entireGroupSVGElement   => _entireGroupSVGElement;

    String          _entireGroupName        = '';
    ///This is the "id" attribute value applied to [entireGroupSVGElement].
    String          get entireGroupName     => _entireGroupName;

    ///Quick access to the SVG Group element into which *all* border SVG elements are rendered.
    SVGGElement get bordersSVGGroupElement  => _borders.allBordersSVGGroupElement;


    //(private) reference to the background (SVG "rect") element used for "fill"
    SVGRectElement  _bgRectSVGElement       = null;


    EventsProcessor     _on     = new EventsProcessor();
    ///Event handler.  See [EventsProcessor] for detailed discussion.
    EventsProcessor get on      => _on;


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    IsMovable/IsSizable properties:
    Can this Widget be moved/sized with the mouse? (via mousedown/mousemove/mouseup)?
    "Setting" is handled via embedded DynamicsConstraint object.

    TODO: consider the MoveTarget (what group in widget) to detect moves on?
    Also, should Alignment be cleared if moved?
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    DynamicsConstraint  _isMovable      = new DynamicsConstraint();
    DynamicsConstraint get isMovable    => _isMovable;

    DynamicsConstraint  _isSizable      = new DynamicsConstraint();
    DynamicsConstraint get isSizable    => _isSizable;

    //a shortcut to resulting value for whether ANY "selection"-related action is enabled for this Widget (i.e., movable/sizable);
    bool    _isSelectable   = true;

    //track whether this widget is "selected"; made class-wide variable in case we want to examine elsewhere than mouse-down
    bool    _isSelected     = false;


    num     _translateX = 0.0;
    ///The X-axis distance a widget has been translated from its original position via move() method.
    num     get translateX              => _translateX;

    num     _translateY = 0.0;
    ///The Y-axis distance a widget has been translated from its original position via move() method.
    num     get translateY              => _translateY;


//TODO: for future implementation
//    num     _scaleX     = 1.0;
//    num     _scaleY     = 1.0;
//    num     _rotateDeg  = 0.0;

    //when a dragging-move operation is underway, these variables track starting (mouse) coordinates that offsets are calc'd from
    //initially set on mousedown, but updated with each subsequently processed mousemove (to be "new" start position before next event)
    num     _dragStartX = 0.0;
    num     _dragStartY = 0.0;

//TODO: IF we want to "abort" / "undo" a move... implement a two-phase tracking (i.e., have Start values remain ORIG pos until done).
//    num     _DragLastX  = 0;
//    num     _DragLastY  = 0;


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Various constraints and positioning directives that can effect metrics.
    See their respective Class definitions for documentation.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */

    WidgetSizeRules     _sizeRules          = new WidgetSizeRules();
    ///Widget's Sizing rules / constraints. See [WidgetSizeRules] for details including how changes are intercepted and handled via callback method.
    WidgetSizeRules get sizeRules           => _sizeRules;


    WidgetPosRules      _posRules           = new WidgetPosRules();
    ///Widget's Positioning rules / constraints. See [WidgetPosRules] for details including how changes are intercepted and handled via callback method.
    WidgetPosRules get posRules             => _posRules;


    //List of StyleTarget instances. These stylable targets can have CSS Class-Selector(s) applied to them via our classesCSS property.
    List<StyleTarget>   _stylablePropertiesList =  new List<StyleTarget>();


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    VARIOUS CONSTANTS
    TODO: IF this will increase mem-efficiency/speed, move other literals here
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */

    ///A CSS-stylable targetObject name (and, the default class-selector-value to match) for "Base" properties.
    static const String W_BASE          = 'Widget_Base';
    ///A CSS-stylable targetObject name (and, the default class-selector-value to match) for "Frame" properties.
    static const String W_FRAME         = 'Widget_Frame';
    ///A CSS-stylable targetObject name (and, the default class-selector-value to match) for "Outer Border" properties.
    static const String W_OUTER         = 'Widget_BorderOuter';
    ///A CSS-stylable targetObject name (and, the default class-selector-value to match) for "Inner Border" properties.
    static const String W_INNER         = 'Widget_BorderInner';


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Define the CSS-stylable target objects/properties (and their default values) this
    * Widget implements.  These *constants* values are transferred, during constructor, into
    * the instance variable: `_stylablePropertiesList`.
    *
    * *At this time*, CSS can only be used to style the entire border-part (group) at once, which is fine,
    * since you can layer CSS Classes up such that if you wish to affect a change on one minor component
    * of a widget-part (e.g., the Frame's right-border color), you can do so by simply setting up a
    * CSS class-selector like `FrameRightBorderColor {border-right: 1px solid red}`, and include this
    * selector on the Frame-target by setting `classesCSS[W_FRAME] = "${W_FRAME}, FrameRightBorderColor"`
    *
    * *Ultimately*, if there is a need (due to speed or such) to have more "direct" access to updating a
    * single, or narrow group of, value(s), our part-naming convention could come into play (see below)
    * and we could include in our stylable properties list any "targetable" subsets,
    * like "Widget_Base_Background")
    *
    * Stylable Part Naming Convention for "id" attributes (i.e., the "TargetObject") on the
    * actual SVG element:
    *     InstanceName_Component_SubComponent[_SubComponent][_SubComponent]...
    *
    *     e.g.,: InstanceName_Widget_BorderType_BorderSubComponent_Side/Path[stroke#]... which results in...
    *     e.g.,: InstanceName_Widget_BorderOuter_Outer_Left2
    *
    * ## HOW THESE ARE USED:
    * See [StyleTarget] and [CSSTargetsMap] class comments for more details.
    *
    * The Widget's [classesCSS] (instance of CSSTargetsMap), maintains a comma-delim
    * string of CSS Selector "classes" to apply to target objects in our stylable-properties-list.
    *
    * *Per-side property enumerations* are included in this list because, even if a property
    * like "margin" is specified in CSS,
    * we need to return the calculated value **per-side** (for our internal drawing routines).
    *
    * NOTE: Sub-classes must extend upon this by providing their own list of additional
    * stylable parts to apply/calc CSS for (and, derived Widgets would have to apply the
    * resulting calculated values to any applicable SVG elements they own). As such, any
    * subclass must extend or override  [createWidgetCSSTargetsStylableProperties] to create
    * stylable properties for additional or alternative (respectively) lists similar to this one.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    static const List<ConstStyleTarget>  InitialStylableWidgetProperties = const [
        /*
        GROUP 1:
        Begin with properties that are styled by applying Base Widget class-selector(s); notice that for this group, we could have used
        a single group, and thus a single call to retrieve "Base" and "Frame" styling, since the CSS Properties used for each do not conflict/overlap.
        But, since we could end up using properties like "filter" for both for widget background and its frame, separation was chosen.
        */
        const ConstStyleTarget(W_BASE  , 'margin-top'          , '0'      ),
        const ConstStyleTarget(W_BASE  , 'margin-right'        , '0'      ),
        const ConstStyleTarget(W_BASE  , 'margin-bottom'       , '0'      ),
        const ConstStyleTarget(W_BASE  , 'margin-left'         , '0'      ),
        const ConstStyleTarget(W_BASE  , 'padding-top'         , '0'      ),
        const ConstStyleTarget(W_BASE  , 'padding-right'       , '0'      ),
        const ConstStyleTarget(W_BASE  , 'padding-bottom'      , '0'      ),
        const ConstStyleTarget(W_BASE  , 'padding-left'        , '0'      ),
        const ConstStyleTarget(W_BASE  , 'fill'                , 'black'  ),
        const ConstStyleTarget(W_BASE  , 'fill-opacity'        , '0.0'    ),

        const ConstStyleTarget(W_FRAME , 'border-top-style'    , 'none'   ),
        const ConstStyleTarget(W_FRAME , 'border-right-style'  , 'none'   ),
        const ConstStyleTarget(W_FRAME , 'border-bottom-style' , 'none'   ),
        const ConstStyleTarget(W_FRAME , 'border-left-style'   , 'none'   ),
        const ConstStyleTarget(W_FRAME , 'border-top-width'    , '0'      ),
        const ConstStyleTarget(W_FRAME , 'border-right-width'  , '0'      ),
        const ConstStyleTarget(W_FRAME , 'border-bottom-width' , '0'      ),
        const ConstStyleTarget(W_FRAME , 'border-left-width'   , '0'      ),
        const ConstStyleTarget(W_FRAME , 'border-top-color'    , '0'      ),
        const ConstStyleTarget(W_FRAME , 'border-right-color'  , '0'      ),
        const ConstStyleTarget(W_FRAME , 'border-bottom-color' , '0'      ),
        const ConstStyleTarget(W_FRAME , 'border-left-color'   , '0'      ),
        const ConstStyleTarget(W_FRAME , 'stroke-opacity'      , '1.0'    ),

        /*
        GROUP 2: properties that are styled by applying Outer-Border class-selector(s)
        NOTE:   Border-STYLE(s) are at end of each group and must remain there. The GetCSS... routine processes this array in order,
                and when it reaches the style attribute(s), it performs lookups on width-value(s) to determine border-type (our
                enumerated internal "type").
        */
        const ConstStyleTarget(W_OUTER , 'border-top-style'    , 'none'   ),
        const ConstStyleTarget(W_OUTER , 'border-right-style'  , 'none'   ),
        const ConstStyleTarget(W_OUTER , 'border-bottom-style' , 'none'   ),
        const ConstStyleTarget(W_OUTER , 'border-left-style'   , 'none'   ),
        const ConstStyleTarget(W_OUTER , 'border-top-width'    , '0'      ),
        const ConstStyleTarget(W_OUTER , 'border-right-width'  , '0'      ),
        const ConstStyleTarget(W_OUTER , 'border-bottom-width' , '0'      ),
        const ConstStyleTarget(W_OUTER , 'border-left-width'   , '0'      ),
        const ConstStyleTarget(W_OUTER , 'border-top-color'    , '0'      ),
        const ConstStyleTarget(W_OUTER , 'border-right-color'  , '0'      ),
        const ConstStyleTarget(W_OUTER , 'border-bottom-color' , '0'      ),
        const ConstStyleTarget(W_OUTER , 'border-left-color'   , '0'      ),
        const ConstStyleTarget(W_OUTER , 'stroke-opacity'      , '0.0'    ),

        //Group3: properties that are styled by applying Inner-Border class-selector(s)
        const ConstStyleTarget(W_INNER , 'border-top-style'    , 'none'   ),
        const ConstStyleTarget(W_INNER , 'border-right-style'  , 'none'   ),
        const ConstStyleTarget(W_INNER , 'border-bottom-style' , 'none'   ),
        const ConstStyleTarget(W_INNER , 'border-left-style'   , 'none'   ),
        const ConstStyleTarget(W_INNER , 'border-top-width'    , '0'      ),
        const ConstStyleTarget(W_INNER , 'border-right-width'  , '0'      ),
        const ConstStyleTarget(W_INNER , 'border-bottom-width' , '0'      ),
        const ConstStyleTarget(W_INNER , 'border-left-width'   , '0'      ),
        const ConstStyleTarget(W_INNER , 'border-top-color'    , '0'      ),
        const ConstStyleTarget(W_INNER , 'border-right-color'  , '0'      ),
        const ConstStyleTarget(W_INNER , 'border-bottom-color' , '0'      ),
        const ConstStyleTarget(W_INNER , 'border-left-color'   , '0'      ),
        const ConstStyleTarget(W_INNER , 'stroke-opacity'      , '0.0'    )

        //Group[n] (specialized/additional stylable targets can be added via subclasses)

        //TODO: stroke-linecap by part?
        //TODO: effect(s) by part?

    ]; //_listInitialStylableProperties



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Many aspects of a [Widget] can be styled using externally defined CSS rules.
    * E.g., filling the Widget background, setting border sides, color(s) and width(s), etc.
    * Although the CSS-stylable attributes are limited currently, quite a few
    * Widget visual attributes are supported.
    *
    * The default selector targets are defined in [createWidgetCssStyleTargets]
    *
    * This [CSSTargetsMap] maintains a Map of Class Names ("key" portion of Map) that
    * CSS *selectors* will be able to target and Style.
    * Multiple selectors can be used to style a given target (as one would expect from CSS),
    * and these selectors are maintained as a comma-delimited string within the "value" portion
    * of each Map row.
    *
    * ## How CSS Properties and Property Values relate to Widget Parts
    * Our Widget layout closely relates to the [CSS box-model](http://www.w3.org/TR/CSS2/box.html)
    * See the [WidgetMetrics] discussion of how the various [eWidgetPart] parts come together to
    * form the Widget.
    *
    * We use the following CSS properties, per Widget aspect...
    *
    * **NOTE: you must use a valid unit of measure (e.g., px, pt, em) after any sizes in
    * your Widget-styling CSS or sizes will be interpreted as zero!**  (TODO: Only tested with "px" so far.)
    * The getComputedStyle ==> getPropertyValue ==> yields *whole number values* (in px), but
    * *requires* a specified UOM in stylesheet.  **Numbers without UOM suffix yield zero!**
    *
    * ### Styling of "Widget_Base"target parts:
    *
    *    * **margin** : Distance to inset Outer border (from [parentSVGElement] bounding box);
    *        note that this can vary PER-SIDE.
    *    * **padding** : Distance to inset [clientSVGElement] from inner border; this can also
    *        vary PER-SIDE (e.g., padding-left)
    *    * **fill** : Widget's background color
    *    * **fill-opacity** : Widget's background opacity
    *
    * ### Styling of "Widget_Frame" target parts:
    *
    *    * **stroke-opacity** : "Frame" opacity (all sides will be the same opacity);
    *        border specifiers do not support opacity, so we use stroke-opacity for this.
    *    * **border** : "Frame" width *and* color (with frame side(s) being optional: just specify zero-width).
    *        Valid border sub-properties: ('border-top', 'border-right', 'border-bottom', 'border-left')
    *        Note: border properties were used (instead of stroke-width) since SVG stroke-width
    *        has no concept of "sides".
    *        **NOTE: you must specify a border-type for it to be drawn** (e.g., solid) or it will default to 'none/0px'
    *        even if you provide non-zero width.  E.g., choose 'border: 1px solid black;'
    *    * **border-style** : "Frame" stroke style.
    *        The *only supported style* is "solid" for "Frame", though our outer/inner borders support more styles.
    *
    *    * **border side-specifics** can be accessed via:
    *         'border-top-color', 'border-right-color', 'border-bottom-color', 'border-left-color' ('border-color')
    *         'border-top-style', 'border-right-style', 'border-bottom-style', 'border-left-style' ('border-style')
    *         'border-top-width', 'border-right-width', 'border-bottom-width', 'border-left-width' ('border-width')
    *
    * ### Styling of 'Widget__BorderOuter' and 'Widget__BorderInner' target parts:
    * The Widget has Outer/Inner borders that may be shown and styled.
    *
    *    * **stroke-opacity** : border opacity (all sides will be the same opacity)
    *    * **border** : border width *and* color *and* style.
    *        See notes above regarding styling of frame border-parts, since **inner/outer Widget borders
    *        support using the same CSS properties as the Widget frame**, with the additional
    *        support for a variety of border-styles.
    *        Most [CSS2 Standard Border Styles](http://www.w3.org/TR/CSS2/box.html#border-style-properties)
    *        are supported. See [eBorderStyle] enumerated types of border-styles we support.
    *
    * ---
    * ## Example CSS Class Selectors
    * Refer to the samples directory for both the dart code and the associated CSS file
    * used to style Widgets in a variety of ways.
    *
    * ## See Also
    *    * [Application.classesCSS] property for detailed comments regarding [Application] styling.
    *    * [createWidgetCssStyleTargets] for default values loaded during Widget construction.
    *    * [CSSTargetsMap] class
    *    * [StyleTarget] class
    *
    * ---
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    CSSTargetsMap    classesCSS         = new CSSTargetsMap();


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    "Fill" info is obtained from CSS Styling, but may also be manipulated directly
    within code to visually indicate movement, selection, etc
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    String              _fillColor              = 'none';   //'none', 'transparent', '' each indicate no-fill
    String              _fillOpacity            = '0.0';    //fill not showing by default


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    TODO: ISSUE 144: THE FOLLOWING VARIABLES ARE HERE TO WORKAROUND AN ISSUE IN DART:
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
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    TODO: implement fully.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    String      _caption                    = '';
    ///Caption (text) will be displayed, where appropriate, on sub-classes that implement abstract value.
    String      get caption                 => _caption;

    bool        _enabled                    = true;
    ///Not used yet.
    bool        get enabled                 => _enabled;

    bool        _showHint                   = false;
    ///Note used yet.
    bool        get showHint                => _showHint;


    int         _hintPause                  = 1000;


    String      _tag                        = '';
    ///Common field available to all widgets for developer convenience and arbitrary use. (a la Delphi)
    String      get tag                     =>  _tag ;
    void        set tag(String newTag)      {_tag = newTag;}


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Tab stops and tab-ordering properties...

    TODO: We will likely need to update our list of tabstops that are ordered by TabOrder,
    when either of these properties is altered.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    num         _tabOrder                   = 0;
    ///(not yet used) Is Widget in the TabOrder?
    bool        get tabStop                 => _tabStop;
    void        set tabStop(bool isTabStop) {
        if (_tabStop != isTabStop) {
            _tabStop = isTabStop;
        }
    }

    bool        _tabStop                    = false;
    ///(not yet used) Integer makes most sense, but any number will do for <> comparisons.
    num         get tabOrder                => _tabOrder;
    void        set tabOrder(num tabOrder) {
        if (_tabOrder != tabOrder) {
            _tabOrder = tabOrder;
        }
    }


    bool        _visible                    = false;
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

    WidgetAlignment     _align              = new WidgetAlignment();
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Widget alignment (positional-constraint) capabilities are rather substantial,
    * and much widget functionality relies on these values to determine positioning
    * of widgets relative to other widgets and/or relative to the window-bounds, etc.
    * Alignment options (and/or [anchors]) can be set in such a way that Widgets will
    * "auto-move/stretch" as their container changes, as they are moved (with mouse),
    * and as siblings they are aligned to move or change dimensions.
    *
    * Setting of values is done via [align] sub-properties, each of which is of type
    * [AlignSpec].  E.g., `myWidget.align.T.aspect = eAspects.T;` to indicate that the top
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


    WidgetMetrics       _widgetMetrics      = new WidgetMetrics();
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Return a reference to Widget's Metrics information. This accessor exists primarily
    * for obtaining positioning/bounds information about this Widget, via the various
    * [ObjectBounds] objects contained within [WidgetMetrics], by other widgets or external
    * code that require such information perform alignment tasks or such.
    * E.g., `myWidget.metrics.Margin.L` will return the widget's left margin position.
    *
    * Widget size and position, along with Border(s) specifications, influence these Metrics.
    * Constraints and directives for position, size, alignment, constraints, anchors can
    * have additional effects on the calculation of these metrics.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    WidgetMetrics       get metrics         => _widgetMetrics;


    num     _x          = 0.0;
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



    num     _y          = 0.0;
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



    num     _width      = 20.0;
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



    num     _height     = 20.0;
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


    int _anchors        = eAspects.NONE;
    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Anchors are a special type of constraint that is designed to fix side(s) of a Widget
    * in a particular location relative to the [parentWidget.clientSVGElement] bounds
    * (i.e., our container's bounds) when a Widget is resized or otherwise aligned (per
    * [align] specifications).
    *
    * These anchors will be honored during resizing of widgets. Note that anchors used in
    * combination with [align] values only make sense when one side of a Widget is
    * subject to an [align] directive and its *opposite* side is not (that opposite side
    * could be anchored).
    *
    * Anchors rely on an enumerated type [eAspects] whose integer values are additive
    * in such a way that, within this single integer [anchors] property, it is possible to
    * specify multiple anchor-sides.
    * E.g., both the top *and* left side of the widget could be anchored.
    *
    * TODO: implement anchor center(s) ability in alignment code.
    *
    * ### See Also
    *   * [align] for more about alignment specifications.
    *   * [eAspects] for more information about the additive nature of this type's values.
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
    BEGIN: Styling / Repainting / Metrics / Bounds Calcs / Realignment Logic...
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    BEGIN: APPLY STYLES METHOD(S)...
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪

    These are fired (via callbacks) from the [CSSTargetsMap] class when any changes to
    the CSS-class-selectors (applied to various Widget "target objects") are detected.
    The caller (various methods inside [CSSTargetsMap]) has already performed any required
    off-screen CSS computation by applying the latest class-selectors and using the
    [Application.getCSSPropertyValuesForClassNames] method to obtain values.

    Values derived from our CSS calculations are stored in [_StylablePropertiesList]
    and applied to appropriate internal variables and/or SVG part in these methods.

    See (for more related comments):
        [createWidgetCssStyleTargets] and
        [createWidgetCSSTargetsStylableProperties]

    NOTE: Sub-classes must provide additional methods for callbacks to apply CSS to
    any applicable SVG elements owned by a derived Widget

    TODO: Address pseudo-SELECTORS (HOVER, etc) via ONLY CSS

    Any changes to CSS specifications could affect visual stying as well as imply
    a need to perform realignments and such (if CSS was used to affect metrics, e.g.,
    by altering border-widths). So, when an object is [Visible], fire a repaint after
    applying any styling updates.
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Helper method to simplify life a bit...
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    String _obtainStyleCalcValue(String objName, String propName) {
        return  getStyleTargetFromListByObjAndProperty(_stylablePropertiesList, objName, propName).calcValue;
    }


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Widget Fill, Margin, and Padding...
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    void _applyStylesToWidgetBase(String targetObjectName) {

        _fillColor              = ensureStandardNoneColor(_obtainStyleCalcValue(targetObjectName, 'fill'));
        _fillOpacity            = ((_fillColor == 'none') ? '0.0' : _obtainStyleCalcValue(targetObjectName, 'fill-opacity'));
        _borders.Margin.T.width = int.parse(_obtainStyleCalcValue(targetObjectName, 'margin-top'    ));
        _borders.Margin.R.width = int.parse(_obtainStyleCalcValue(targetObjectName, 'margin-right'  ));
        _borders.Margin.B.width = int.parse(_obtainStyleCalcValue(targetObjectName, 'margin-bottom' ));
        _borders.Margin.L.width = int.parse(_obtainStyleCalcValue(targetObjectName, 'margin-left'   ));
        _borders.Padding.T.width= int.parse(_obtainStyleCalcValue(targetObjectName, 'padding-top'   ));
        _borders.Padding.R.width= int.parse(_obtainStyleCalcValue(targetObjectName, 'padding-right' ));
        _borders.Padding.B.width= int.parse(_obtainStyleCalcValue(targetObjectName, 'padding-bottom'));
        _borders.Padding.L.width= int.parse(_obtainStyleCalcValue(targetObjectName, 'padding-left'  ));

        if (_visible) {
             rePaint();
        }
    } //_applyStylesToWidgetBase



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    NOTES:
        The ORDER of updating our Widget values matters.
        Style-setting (via [setStyle] calls) relies on us already having set the
        *border-width values*, since we support two border-styles not defined by standard CSS
        (see "virtual" border types in [eBorderStyle]).

    PER-SIDE property ENUMERATIONS are examined because, even if a property like "margin"
    is specified in CSS, we need to return the calculated value PER-SIDE
    (for our internal drawing routines).
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _applyStylesToWidgetBorders(String targetObjectName) {

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Frame, Outer, Inner: each use CSS prop values similarly
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        void applyStylesToWidgetPart(WidgetBorder bPart) {
            String  sTemp       = '';

            //workaround for issue with non-100%-zoom-factor-getcomputedstyle returning bogus non-INT values!
            int getProperWidthValues(String potentialDecimalWidth) {
                int decIndex    = potentialDecimalWidth.indexOf('.');

                if (decIndex > -1) {
                    potentialDecimalWidth = potentialDecimalWidth.substring(0, decIndex);
                    return int.parse(potentialDecimalWidth) + 1;  //add one for "ceiling" effect
                } else {
                    return int.parse(potentialDecimalWidth);
                }
            }

            bPart.T.width       = getProperWidthValues(_obtainStyleCalcValue(targetObjectName,  'border-top-width'       ));
            bPart.R.width       = getProperWidthValues(_obtainStyleCalcValue(targetObjectName,  'border-right-width'     ));
            bPart.B.width       = getProperWidthValues(_obtainStyleCalcValue(targetObjectName,  'border-bottom-width'    ));
            bPart.L.width       = getProperWidthValues(_obtainStyleCalcValue(targetObjectName,  'border-left-width'      ));

            bPart.T.color       = ensureStandardNoneColor(_obtainStyleCalcValue(targetObjectName,  'border-top-color'    ));
            bPart.R.color       = ensureStandardNoneColor(_obtainStyleCalcValue(targetObjectName,  'border-right-color'  ));
            bPart.B.color       = ensureStandardNoneColor(_obtainStyleCalcValue(targetObjectName,  'border-bottom-color' ));
            bPart.L.color       = ensureStandardNoneColor(_obtainStyleCalcValue(targetObjectName,  'border-left-color'   ));

            sTemp   = _obtainStyleCalcValue(targetObjectName, 'stroke-opacity' );
            bPart.T.opacity     = ((bPart.T.color == 'none') ? '0.0' : sTemp);
            bPart.R.opacity     = ((bPart.R.color == 'none') ? '0.0' : sTemp);
            bPart.B.opacity     = ((bPart.B.color == 'none') ? '0.0' : sTemp);
            bPart.L.opacity     = ((bPart.L.color == 'none') ? '0.0' : sTemp);

            //only valid styles for frame are solid or none.
            bPart.T.setStyle(_obtainStyleCalcValue(targetObjectName, 'border-top-style'   ) );
            bPart.R.setStyle(_obtainStyleCalcValue(targetObjectName, 'border-right-style' ) );
            bPart.B.setStyle(_obtainStyleCalcValue(targetObjectName, 'border-bottom-style') );
            bPart.L.setStyle(_obtainStyleCalcValue(targetObjectName, 'border-left-style'  ) );
        }

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        Frame, Outer, Inner processing simply varies sub-component of Borders is being updated.
        ═══════════════════════════════════════════════════════════════════════════════════════
        */
        switch (targetObjectName) {
            case W_FRAME :
                applyStylesToWidgetPart(_borders.Frame);
                break;
            case W_OUTER :
                applyStylesToWidgetPart(_borders.Outer);
                break;
            case W_INNER :
                applyStylesToWidgetPart(_borders.Inner);
                break;
        }

        if (_visible) {
             rePaint();
        }

    } //_applyStylesToWidgetBorders



    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    END: ... APPLY STYLES METHOD(S)
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
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
            bool    goodSibling                 = false;
            String  alignToAspectName           = '';
            num     translationAdj              = 0.0;
            ObjectBounds    _containerBounds    = null;

            //"top level" Widgets reside on our "Canvas".  Use that to get info if no Widget as parent.
            if (_hasParent) {
                _containerBounds = _parentWidget.getClientBounds();
            } else {
                _containerBounds = _applicationObject.canvasBounds;
            }

            _align.alignSpecs.forEach( (objAlignPart) {
            
                if ((objAlignPart.objToAlignTo != null) && (objAlignPart.aspect > eAspects.NONE)) {
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
                        alignToAspectName = eAspects.ShortNames[objAlignPart.aspect.toString()];

                        //if sibling being aligned to has had its position translated, we need to take that into account when aligning to it.
                        translationAdj = ( ('R,L,CX'.contains(alignToAspectName)) ? objAlignPart.objToAlignTo.translateX: objAlignPart.objToAlignTo.translateY);

                        //our widget part's aspect value depends on the bounds-subcomponent value from the Widget we are aligned to (e.g., it's Margin.Left value)
                        objAlignPart.aspectValue = (objAlignPart.objToAlignTo.metrics[objAlignPart.part][alignToAspectName]) + translationAdj;

                        //Trace will include Widget data followed immediately by AlignSpec info
                        if (_applicationObject.trace(2)) {
                            logToConsole([
                                'LINE2',
                                TracingDefs['2'].tracePointDesc,
                                'LINE3',
                                this,
                                'LINE5',
                                "  (AlignSpec) referenced Widget's aspect = ${alignToAspectName}; referenced Widget's part = ${eWidgetPart.Names[objAlignPart.part]}; referenced value = ${objAlignPart.aspectValue};",
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
                    switch (objAlignPart.aspect) {
                        case eAspects.R:
                            objAlignPart.aspectValue = _containerBounds.R - _containerBounds.L;
                            break;
                        case eAspects.L:
                            objAlignPart.aspectValue = 0;
                            break;
                        case eAspects.T:
                            objAlignPart.aspectValue = 0;
                            break;
                        case eAspects.B:
                            objAlignPart.aspectValue = _containerBounds.B - _containerBounds.T;
                            break;
                        case eAspects.CX:
                            objAlignPart.aspectValue = _containerBounds.CX;
                            break;
                        case eAspects.CY:
                            objAlignPart.aspectValue = _containerBounds.CY;
                            break;
                        default:
                            objAlignPart.aspectValue = 0;
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

            _calcSingleBounds(eWidgetPart.OUTER,    eWidgetPart.MARGIN);
            _calcSingleBounds(eWidgetPart.FRAME,    eWidgetPart.OUTER);
            _calcSingleBounds(eWidgetPart.INNER,    eWidgetPart.FRAME);
            _calcSingleBounds(eWidgetPart.PADDING,  eWidgetPart.INNER);
            _calcSingleBounds(eWidgetPart.CLIENT,   eWidgetPart.PADDING);
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
        if (_align.CX.aspect != eAspects.NONE) {
            ptrWidgetBounds.L   = _align.CX.aspectValue - mTempAdjCX;
            ptrWidgetBounds.R   = _align.CX.aspectValue + mTempAdjCX;
        } else {
            //right/left alignment:
            //are both sides NOT aligned to anything?
            if ((_align.L.aspect == eAspects.NONE) && (_align.R.aspect == eAspects.NONE)) {
                ptrWidgetBounds.L = _x;
                ptrWidgetBounds.R = mTempR;
            } else {
                if (_align.L.aspect != eAspects.NONE) {
                    //Left align specified (right may be too...)
                    ptrWidgetBounds.L = _align.L.aspectValue;

                    //anchors only make sense when one side is aligned and its opposite side is not... holds other side at specified position
                    if ( (_anchors & eAspects.R) == eAspects.R) {
                        ptrWidgetBounds.R = Math.max((ptrWidgetBounds.L + _width + 1), mTempR);  //prevent negative width
                    } else {
                        //see if Right align exists (since it is not mutually exclusive of Left align decision tree we are in)...
                        if (_align.R.aspect != eAspects.NONE) {
                            ptrWidgetBounds.R = _align.R.aspectValue;
                        } else {
                            ptrWidgetBounds.R = ptrWidgetBounds.L + _width;
                        }
                    }
                } else {
                    //some right alignment without any left alignment...
                    ptrWidgetBounds.R = _align.R.aspectValue;

                    //anchors only make sense when one side is aligned and its opposite side is not... holds other side at specified position
                    if ( (_anchors & eAspects.L) == eAspects.L) {
                        ptrWidgetBounds.L = Math.min((ptrWidgetBounds.R - _width - 1), _x);  //prevent negative width
                    } else {
                        ptrWidgetBounds.L = ptrWidgetBounds.R - _width;
                    }
                }
            }
        } //...x-Axis alignment code...



        //Y-Axis alignment code...
        if (_align.CY.aspect != eAspects.NONE) {
            ptrWidgetBounds.T   = _align.CY.aspectValue - mTempAdjCY;
            ptrWidgetBounds.B   = _align.CY.aspectValue + mTempAdjCY;
        } else {
            //top/bottom alignment:
            //are both sides NOT aligned to anything?
            if ((_align.T.aspect == eAspects.NONE) && (_align.B.aspect == eAspects.NONE)) {
                ptrWidgetBounds.T = _y;
                ptrWidgetBounds.B = mTempB;
            } else {
                if (_align.T.aspect != eAspects.NONE) {
                    //Top align specified (bottom may be too...)
                    ptrWidgetBounds.T = _align.T.aspectValue;

                    //anchors only make sense when one side is aligned and its opposite side is not... holds other side at specified position
                    if ( (_anchors & eAspects.B) == eAspects.B) {
                        ptrWidgetBounds.B = Math.max((ptrWidgetBounds.T + _height + 1), mTempB);  //prevent negative Height
                    } else {
                        //see if Bottom align exists (since it is not mutually exclusive of Top align decision tree we are in)...
                        if (_align.B.aspect != eAspects.NONE) {
                            ptrWidgetBounds.B = _align.B.aspectValue;
                        } else {
                            ptrWidgetBounds.B = ptrWidgetBounds.T + _height;
                        }
                    }
                } else {
                    //some Bottom alignment without any Top alignment...
                    ptrWidgetBounds.B = _align.B.aspectValue;

                    //anchors only make sense when one side is aligned and its opposite side is not... holds other side at specified position
                    if ( (_anchors & eAspects.T) == eAspects.T) {
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
    * Centralizes the "repainting" of the Widget.  Includes logic to bypass repaints while
    * inside a [beginUpdate] ... [endUpdate] block.  Also only re-applies any CSS-sourced
    * visual property values if a CSS change has been detected since last [rePaint] operation.
    *
    * ### Parameters
    * [cssChangedSinceRepaint] should be passed [true] when outstanding CSS style-calculations
    * exist that need applied to various Widget Parts.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void rePaint([bool cssChangedSinceRepaint = false]) {
        if (eWidgetState.isUpdating(_widgetState))  return;  //bypass during mass-updates
        if (eWidgetState.isLoading(_widgetState))   return;  //bypass while in initial state

        reAlign();
    }



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
        if (eWidgetState.isUpdating(_widgetState)) return;

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


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Method that consolidates the visual updates to all aspects of our Widget.
    * Much of the real work is done via the [WidgetBorderSide.updateBorderLineElements] logic,
    * since so much of a Widget's styling has to do with the line elements that used to
    * draw the borders.
    *
    * This method is called from [reAlign] when any changes to Widget properties/state
    * will affect the background, border(s), or selection-rect position.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void renderBordersAndBackground() {

        ObjectBounds ptrBoundsForBgRect      = _widgetMetrics.Inner;

        /*
        ═══════════════════════════════════════════════════════════════════════════════════════
        NOTES regarding: transform="translate(x,y), scale(scalex,scaley)"...
        TODO: implement translate for positioning post-scale(other than 1, 1)...
        Need to translate inversely-proportionate to the scale in order to keep the x/y
        of the SVG tag at same visual position after scaling.
        Also, consider: do we want top-left corner to remain stationary, or center-point?
        TODO: handle any rotations too
        ═══════════════════════════════════════════════════════════════════════════════════════
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
        ObjectBounds ptrBoundsForSelectRect = _widgetMetrics.Margin;
        setSVGAttributes(_selectionRect, {
            'x'             : (ptrBoundsForSelectRect.L).toString(),
            'y'             : (ptrBoundsForSelectRect.T).toString(),
            'width'         : (ptrBoundsForSelectRect.Width).toString(),
            'height'        : (ptrBoundsForSelectRect.Height).toString(),
        });


        _borders.Outer.updateBorderSideStrokeCoordinatesFromBounds(_widgetMetrics.Outer);
        _borders.Frame.updateBorderSideStrokeCoordinatesFromBounds(_widgetMetrics.Frame);
        _borders.Inner.updateBorderSideStrokeCoordinatesFromBounds(_widgetMetrics.Inner);

        _borders[eWidgetPart.FRAME].T.updateBorderLineElements();
        _borders[eWidgetPart.FRAME].R.updateBorderLineElements();
        _borders[eWidgetPart.FRAME].B.updateBorderLineElements();
        _borders[eWidgetPart.FRAME].L.updateBorderLineElements();
        _borders[eWidgetPart.OUTER].T.updateBorderLineElements();
        _borders[eWidgetPart.OUTER].R.updateBorderLineElements();
        _borders[eWidgetPart.OUTER].B.updateBorderLineElements();
        _borders[eWidgetPart.OUTER].L.updateBorderLineElements();
        _borders[eWidgetPart.INNER].T.updateBorderLineElements();
        _borders[eWidgetPart.INNER].R.updateBorderLineElements();
        _borders[eWidgetPart.INNER].B.updateBorderLineElements();
        _borders[eWidgetPart.INNER].L.updateBorderLineElements();

    } //...renderBordersAndBackground




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
    (or remove from, if an already-selected widget is shift-clicked again). The application
    list-management routine includes logic to prevent effective "doubling+" of a selection,
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
            _widgetState = eWidgetState.setState(_widgetState, eWidgetState.MOVING);

            if (_isMovable.x) {
                _x = _widgetMetrics.Margin.L;   //our Widget's Left-most Bounds
                _align.clearAlignsOnAxisX();    //if we want something to remain aligned "relative" after moving, bypass this line.  TODO??
            }

            if (_isMovable.y) {
                _y = _widgetMetrics.Margin.T;   //our Widget's Top-most Bounds
                _align.clearAlignsOnAxisY();
             }

            //Widget shall be more transparent during movement
            _entireGroupSVGElement.attributes['opacity'] = '0.7';
        } else {
            _widgetState = eWidgetState.setState(_widgetState, eWidgetState.SIZING);

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
        if (eWidgetState.isMoving(_widgetState)) {
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
            if ((_isSizable.x) && (offsetX != 0.0)) {width    = _width   + offsetX;}
            if ((_isSizable.y) && (offsetY != 0.0)) {height   = _height  + offsetY;}
        }

        //Process any potential user-assigned event code to run on ANY mousemove (not just a Widget "move")
        _on.mouseMove(new MouseNotifyEventObject(this, event));

        //Need to make sure any subclass-implemented alignment occurs for THIS widget
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
        //test for null because we programmatically call MouseUp to abort Move() that would otherwise violate PosRules
        if (event != null) {event.stopPropagation();}

        _applicationObject.canvas.on.mouseMove.remove(mouseMoveHandler);
        _applicationObject.canvas.on.mouseUp.remove(mouseUpHandler);

        //Process any potential user-assigned event code to occur on mouse up
        _on.mouseUp(new MouseNotifyEventObject(this, event));

        //Restore opacity after movement/sizing (if Move, entire widget effects applied, otherwise just border);
        //TODO: Get values from CSS -- Application-wide setting.
        if (eWidgetState.isMoving(_widgetState)) {
            _entireGroupSVGElement.attributes['opacity'] = '1.0';
            _widgetState = eWidgetState.removeState(_widgetState, eWidgetState.MOVING);
        } else {
            _borders.allBordersSVGGroupElement.attributes['opacity'] = '1.0';
            _widgetState = eWidgetState.removeState(_widgetState, eWidgetState.SIZING);
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
        const num CLOSE_ENOUGH = 50.0; //a little "slack" for a bit stickier edge during moves in case mouse gets out infront of event processor a bit
        num proposedTranslateX  = _translateX + shiftX;
        num proposedTranslateY  = _translateY + shiftY;
        num proposedX           = _x + proposedTranslateX;
        num proposedY           = _y + proposedTranslateY;

        if ((_isMovable.x) && (shiftX != 0.0)) {
            bool isCursorInWidgetRangeX = (event == null) ||
                ((event.clientX >= (xAsClientX - (shiftX > 0 ? 0 : CLOSE_ENOUGH))) && (event.clientX <= (xAsClientX + _width + (shiftX < 0 ? 0 : CLOSE_ENOUGH))));

            num minX                = _posRules.getMinX(new MouseNotifyEventObject(this, event));
            bool acceptProposedX    = ((minX == null) ? true : ((proposedX >= minX) || (shiftX > 0)));
            num maxX                = _posRules.getMaxX(new MouseNotifyEventObject(this, event));
            acceptProposedX         = acceptProposedX && ((maxX == null) ? true : ((proposedX <= maxX) || (shiftX < 0)));

            _applicationObject.trace(7, this);
            _applicationObject.trace(7, "  >> isCursorInWidgetRangeX = ${isCursorInWidgetRangeX};  acceptProposedX = ${acceptProposedX};  xAsClientX = ${xAsClientX};  event.clientX = ${(event == null ? 'null' : event.clientX)};");

            if  (acceptProposedX && isCursorInWidgetRangeX) {
                _translateX = proposedTranslateX;
            }
        }

        if ((_isMovable.y) && (shiftY != 0.0)) {
            bool isCursorInWidgetRangeY = (event == null) ||
                ((event.clientY >= (yAsClientY - (shiftY > 0 ? 0 : CLOSE_ENOUGH))) && (event.clientY <= (yAsClientY + _height + (shiftY < 0 ? 0 : CLOSE_ENOUGH))));

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

        //Already in Updating state? (note: next line wouldn't care; this is here for placeholder
        //if we later want to allow "nested" begin/endupdates... change return to inc count, etc.)
        if (eWidgetState.isUpdating(_widgetState)) return;

        _widgetState = eWidgetState.setState(_widgetState, eWidgetState.UPDATING);
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Call endUpdate to signal the end of mass property changes;
    * endUpdate will then start the visual recalculation / repaint sequence and apply outstanding
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
        if ( !(eWidgetState.isUpdating(_widgetState))) return;  //already not in Updating state

        _widgetState = eWidgetState.removeState(_widgetState, eWidgetState.UPDATING);
        rePaint(true); //assume CSS style changes during bulk-update
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
    * This provides access to the Widget's inner rect/bounding-box (T,L,B,R coords) that
    * define the visual region available to CHILD objects (i.e., this Widget's Outer Bounds
    * less spaced used for any margin, border(s), padding).
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
    * updated to include [eWidgetState.SHOWING].
    *
    * Event hooks exist herein for [Widget.on.beforeShow] and [Widget.on.show].
    *
    * When method *first* shows Widget content, the [widgetState] is transitioned
    * out of [eWidgetState.LOADING] and into [eWidgetState.NORMAL].
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
        if (eWidgetState.isLoading(_widgetState)) {

            //Fire ALL CSS change handlers on initial show.
            classesCSS.updateAllCSSValues();

            _widgetState = eWidgetState.removeState(_widgetState, eWidgetState.LOADING);
            _widgetState = eWidgetState.setState(_widgetState, eWidgetState.NORMAL);
            rePaint(true);
        }

        //call any user-provided method
        _on.show(new NotifyEventObject(this));

        _widgetState = eWidgetState.setState(_widgetState, eWidgetState.SHOWING);
    } //...Show()



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Essentially the opposite of [show]. Likewise, the [widgetState] is
    * updated to omit [eWidgetState.SHOWING].
    *
    * Event hooks exist herein for [Widget.on.hide].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void hide() {
        _entireGroupSVGElement.attributes['display'] = 'none';

        _visible = false;

        //Call any user-method to occur when Widget is hidden.  This is perfect place to prep for re-alignment, etc.
        _on.hide(new NotifyEventObject(this));

        _widgetState = eWidgetState.removeState(_widgetState, eWidgetState.SHOWING);
    } //...hide()



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Called by constructor. Required by Widget CSS styling logic.
    * Provides *initial* (default) values for CSS-to-Stylable-Widget-object-targets
    * mappings contained in [classesCSS] and loaded via [CSSTargetsMap.createDefaults] method.
    *
    * Sub-classes must add to or remove from this list as needed to expose/hide stylable
    * widget-parts. The called createDefaults method is setup such that it can be called
    * repeatedly with additional List(s) of values to add; just be sure that each
    * additional [CssTargetAndSelectorData.targetObjectName] is unique to the entire list.
    *
    * When new components are created that are "composite widgets" (i.e., widgets using
    * other widgets within then), the widgets held internal to another will potentially
    * need the container-widget to map new part-names/change-handlers that pass values
    * to internalized widgets appropriately.
    *
    * TODO: EXAMPLE COMING SOON.  It also may make more sense to create derived-widgets
    * created for specialized embedded-use in composite widgets.  E.g., scroll-bar's trackbar.
    *
    * ## See Also
    *    * [classesCSS] property for more information on Widget styling.
    *    * [CSSTargetsMap] class
    *    * [StyleTarget] class
    *    * [InitialStylableWidgetProperties] contains initial stylable properties on Widget and
    *    additional details about how these values are used.
    *    * [createWidgetCSSTargetsStylableProperties] loads internal list of stylable properties.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void createWidgetCssStyleTargets() {

        classesCSS.createDefaults(
            [
                new CssTargetAndSelectorData(W_BASE     , W_BASE   , false  , _applyStylesToWidgetBase),
                new CssTargetAndSelectorData(W_FRAME    , W_FRAME  , false  , _applyStylesToWidgetBorders),
                new CssTargetAndSelectorData(W_OUTER    , W_OUTER  , false  , _applyStylesToWidgetBorders),
                new CssTargetAndSelectorData(W_INNER    , W_INNER  , false  , _applyStylesToWidgetBorders),
                new CssTargetAndSelectorData('Font'     , 'Font'   , true   , null)  //TODO: Implement in derived - this only tests logic for now
            ]
        );

    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Called by constructor. Required by Widget CSS styling logic.
    * Sets up *initial* (default) values for list of stylable CSS properties that can
    * apply to those stylable targets created in [createWidgetCssStyleTargets].
    *
    * Override / extended by subclasses to add/remove styling properties used by controls.
    *
    * ## See Also
    *    * [classesCSS] property for more information on Widget styling.
    *    * [CSSTargetsMap] class
    *    * [StyleTarget] class
    *    * [InitialStylableWidgetProperties] contains initial stylable properties on Widget and
    *    additional details about how these values are used.
    *    * [createWidgetCssStyleTargets] loads [classesCSS] data.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void createWidgetCSSTargetsStylableProperties() {
        _addStylablePropertiesToWidget(InitialStylableWidgetProperties);
    }


    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    Used by [createWidgetCSSTargetsStylableProperties]
    Logic kept external to that method so that any code overriding that method still has
    access to this helper method (otherwise, this would have just been encapsulated therein).

    Populate list with stylable targets-objects/properties applicable to this Widget.
    Pass in a list of constant values from which to obtain initializing data.

    Only load the stylable properties that are even possible to "target" per the
    values created during [createWidgetCssStyleTargets].
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    void _addStylablePropertiesToWidget(List<ConstStyleTarget> listToAdd) {
        listToAdd.forEach( (ConstStyleTarget intitial) {
            if (classesCSS._targetObjectsAndSelectors.containsKey(intitial.targetObject)) {
                _stylablePropertiesList.add(new StyleTarget(intitial.targetObject, intitial.targetProperty, intitial.defaultValue));
            }
        });
    }



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
        Once this widget is "shown" (via show()), we can rely just on using the cascading
        visual inheritance of display:inherit/none without a problem.
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
        Grab defaults from app-level; can be overridden per instance if needed.
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

        //Create any EMBEDDED CLASSES a widget uses that can NOT be done via Lazy initialization at object-declaration point earlier in code...
        _borders        = new WidgetBorders("${instanceName}_${typeName}")

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

        //required setup (list-assignment not achievable during constructor do to limitations on accessing "this")
        classesCSS.setStylablePropertiesListRef(_applicationObject, _stylablePropertiesList);


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
        on UniqueConstraintException catch (e) {
            throw new Exception('${e} \n Attempt to create new Widget instance (typeName = ${_typeName}; duplicate instanceName = ${_instanceName})');
        }
        catch (e) {
            throw new Exception('${e} \n Severe error in Widget constructor while attempting to add object instance to Application (object typeName = ${_typeName}; instanceName = ${_instanceName})');
        }


        /*
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        Test validity of parent, if specified, and raise exception if specified parent object
        is not of proper [Widget] (or derivation thereof) type.
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        */
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
        TODO: ISSUE 144: FIND "144" (above) for description of this dart-issue-144 workaround.
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        */
        mouseDownHandler    = mouseDown;
        mouseClickHandler   = mouseClick;
        mouseMoveHandler    = mouseMove;
        mouseUpHandler      = mouseUp;


        /*
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        Create initial values for CSS-to-Stylable-Widget-object-targets mappings AND associated
        list of stylable CSS properties that can apply to those targets.  Both of these
        routines can be overridden / extended by subclasses to add/remove stylable targets/etc.
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        */
        createWidgetCssStyleTargets();
        createWidgetCSSTargetsStylableProperties();


        /*
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        Time to actually create the default SVG objects used to render a Widget.
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        */
        _create();


        /*
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        setup callbacks required by these objects...
        ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
        */
        _isMovable.changeHandler    = handleIsMovableIsSizableChanges;
        _isSizable.changeHandler    = handleIsMovableIsSizableChanges;
        _sizeRules.changeHandler    = handleSizeRuleChanges;

        _align.alignSpecs.forEach( (objAlignPart) {
            objAlignPart.changeHandler = handleAlignmentChanges;
        });

    } //constructor

} //class Widget