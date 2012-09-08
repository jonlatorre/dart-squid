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
These following Classes serve *primarily* as enumerations (enumerated types) and are
named such that their intent/usage should be rather obvious.
They exist for convenience, consistency, coding simplicity (and readability), and
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

} //eWidgetState class



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

} //eSides



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

} //eWidgetPart



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

} //eBorderStyle



