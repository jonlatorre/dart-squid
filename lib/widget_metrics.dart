/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

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
*  * ClientBounds:       the Container region for a Widget's Child-Widget(s).
*
* ## See Also
* [Widget.metrics] - where a [Widget] maintains a reference to an instance of this class.
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
            case eWidgetPart.MARGIN   : return Margin;
            case eWidgetPart.OUTER    : return Outer;
            case eWidgetPart.FRAME    : return Frame;
            case eWidgetPart.INNER    : return Inner;
            case eWidgetPart.PADDING  : return Padding;
            case eWidgetPart.CLIENT   : return ClientBounds;
            default                   : return null;          //fall-through means invalid specification: throw??
        }
    }

} //WidgetMetrics
