part of dart_squid;

/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: EVENT-HANDLING CLASS(ES)
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
*     someSvgGroupElement.onClick.listen((event) => mouseClickHandler(event)); //TODO: which simply calls mouseCLick()
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

    ///Widget-specific event fired toward the end of the [Widget.hide] method, just before [Widget.widgetState] omits [eWidgetState.SHOWING].
    NotifyEvent         get hide                => (_onHide == null) ? _nullEvent : _onHide;
    void set hide(NotifyEvent handler)          {_onHide = handler;}

    ///Widget-specific event fired during the [Widget.mouseMove] method, when Widget movement is allowed and has occurred.
    MouseNotifyEvent    get move                => (_onMove == null) ? _nullMouseEvent : _onMove;
    void set move(MouseNotifyEvent handler)     {_onMove = handler;}

    ///Widget-specific event fired toward the end of the [Widget.show] method, just before [Widget.widgetState] includes [eWidgetState.SHOWING].
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
