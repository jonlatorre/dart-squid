/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

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
