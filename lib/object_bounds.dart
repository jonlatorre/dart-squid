/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Encapsulates standard storage and retrieval of bounding-information
* associated with Widgets, Canvas, etc.
*
* i.e., Left, Top, Right, Bottom (L,T,R,B or, a.k.a. x1,y1,x2,y2) and aliases for
* obtaining CenterX, CenterY (i.e., side-midpoints of CX,CY), and Width and Height
* from the provided LTRB information.
*
* ## See Also
*    * [WidgetMetrics] uses multiple instances of this class to store important bounds info.
*    * [Application.canvasBounds]
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
            default:        return null;  //TODO: fallthrough means invalid specification: throw exception?
        }
    }

}  //ObjectBounds class
