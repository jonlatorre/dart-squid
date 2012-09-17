/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: BORDER-RELATED CLASSES

See comments on [WidgetBorders] class for how these classes fit together.
███████████████████████████████████████████████████████████████████████████████████████████
*/

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
    int         borderType      = eWidgetPart.NONE;     //enumeration eWidgetPart (int); use as quick reference to what type of border this group of sides is for
    int         side            = eAspects.NONE;        //enumeration eAspects (int); quick ref so we know which side of border this side is on
    num         _width          = 0.0;
    String      opacity         = '1.0';                //Expects a decimal value between zero (transparent) and one (totally opaque).
    String      color           = 'black';
    int         _style          = eBorderStyle.NONE;    //enumeration eBorderStyle (int)
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
    static const Map<String, Map<String, int>> borderStyleSpecs =
        const   {
            'NONE'      : const {'TLe':0,   'BRe':0,    'TLi':0,    'BRi':0     },
            'SOLID'     : const {'TLe':105, 'BRe':105,  'TLi':0,    'BRi':0     },
            'GROOVE'    : const {'TLe':105, 'BRe':255,  'TLi':255,  'BRi':105   },
            'RIDGE'     : const {'TLe':255, 'BRe':105,  'TLi':105,  'BRi':255   },
            'OUTSET'    : const {'TLe':255, 'BRe':105,  'TLi':0,    'BRi':0     },
            'INSET'     : const {'TLe':105, 'BRe':255,  'TLi':0,    'BRi':0     },
            'DOUBLE'    : const {'TLe':105, 'BRe':105,  'TLi':105,  'BRi':105   },
            'RAISED'    : const {'TLe':128, 'BRe':0,    'TLi':255,  'BRi':105   },
            'LOWERED'   : const {'TLe':105, 'BRe':255,  'TLi':0,    'BRi':128   }
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


    int     get style   => _style;  //enumeration eBorderStyle (int)
    void    setStyle(String newStyle) {
        if ( (borderType == eWidgetPart.MARGIN) || (borderType == eWidgetPart.PADDING)) return; //default of NONE is only possible value, ever

        if ( (newStyle == null) || (newStyle == 'NONE') || (newStyle == '')) {
            _style = eBorderStyle.NONE;
            return;
        }

        //only valid styles for frame are solid or none; we eliminated none-condition already.
        if (borderType == eWidgetPart.FRAME) {
            _style = eBorderStyle.SOLID;
            return;
        }

        //we are working with (outer/inner); these are potentially double-lined-borders
        _style = eBorderStyle.getEnumValueDefaultNone(newStyle);

    } //setStyle



    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * Helper method.
    * When calculating line-positions, stroke line-center will be adjusted by 1/2 its
    * width when border uses just one line, and when using two lines, the line-centers
    * are at 1/4 and 3/4 of total border width. So, pass in 1, 2, or 3 to get adjuster.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    num     getStrokeInset(num quarterCount) => _width / 4.0 * quarterCount;


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Update the SVG Line Element(s) based on our latest object property
    * values that influence the SVG drawing.
    * See [Widget.renderBordersAndBackground], which is currently the only method that needs
    * to call this.
    *
    * NOTE: stroke-linecap=("round" or "square") was REQUIRED in order to get final corner
    * "joins" correct without adjusting coordinates. Otherwise, you need to adjust final
    * coordinate to not inset (lengthwise) for stroke-width if bevel or no linejoin specified.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void updateBorderLineElements() {
        String displayAttrValLine1  = ( ((_width != 0.0) && (opacity != '0.0') && (_style > eBorderStyle.NONE)) ? 'inherit' : 'none');
        String displayAttrValLine2  = ( ((_width != 0.0) && (opacity != '0.0') && (eBorderStyle.EffectsLineCount[_style] == 2)) ? 'inherit' : 'none');
        String colorValue1  = color;
        String colorValue2  = color;
        String styleName    = eBorderStyle.Names[_style];

        Color lineColor;
        lineColor = new Color.fromBrowserRBGString(colorValue1);

        //TODO: TRACING: print ("BorderType =${eWidgetPart.Names[BorderType]} Style=${eBorderStyle.Names[_Style]} RGB=${LineColor.FormattedRGBString()} Width=${_Width} EffectsLineCount=${eBorderStyle.EffectsLineCount[_Style]} SplitWidth=${_Width / eBorderStyle.EffectsLineCount[_Style]}")  ;
        //any style other than "solid" indicates use of our predefined borderStyleSpecs (color-coordinated-shifting-attempt); use BLACK color to obtain typical grey-scale Windows-like effects.
        if (_style > eBorderStyle.SOLID) {
            if (eBorderStyle.EffectsLineCount[_style] == 2) {
                switch (side) {
                    case eAspects.L   :
                    case eAspects.T   : {lineColor.shiftColor(((borderType == eWidgetPart.INNER) ? borderStyleSpecs[styleName]['TLe'] : borderStyleSpecs[styleName]['TLi'])); break;}
                    case eAspects.R   :
                    case eAspects.B   : {lineColor.shiftColor(((borderType == eWidgetPart.INNER) ? borderStyleSpecs[styleName]['BRe'] : borderStyleSpecs[styleName]['BRi'])); break;}
                }
            } else {
                switch (side) {
                    case eAspects.L   :
                    case eAspects.T   : {lineColor.shiftColor(borderStyleSpecs[styleName]['TLe']); break;}
                    case eAspects.R   :
                    case eAspects.B   : {lineColor.shiftColor(borderStyleSpecs[styleName]['BRe']); break;}
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
        //    The following works for FireFox... and, no need for <use xlink:href="../resources/standard_filters.svg#Effect_3D"/> in SVG appcontainer doc. odd.
        //    line.attributes['filter'] = 'url(../resources/standard_filters.svg#Effect_3D)';
        //
        //    But, for Chrome browser, must define filter INSIDE our Application' container SVG Element
        //    (see: [Application.canvas] property and [Application] class dartdoc details), and then reference as follows:
        //    line.attributes['filter'] = 'url(#Effect_3D)';
        //    http://code.google.com/p/chromium/issues/detail?id=109212 -- BUG REPORT 2-23-2012 (I COMMENTED ON IT); Please "star" this in hopes it then gets fixed.

        if (eBorderStyle.EffectsLineCount[_style] < 2 ) {
            //We take time to set the display attribute only because there is a slight chance a style-change has occurred where we went from line2 showing to not.
            if ( (borderType == eWidgetPart.INNER) || (borderType == eWidgetPart.OUTER) ) {
                lineElement2.attributes['display'] = displayAttrValLine2;
            }
            return;
        }

        //restore color to original state prior to potential color-shifting.
        lineColor.loadFromRGBString(colorValue2);

        if (_style > eBorderStyle.SOLID) {
            switch (side) {
                case eAspects.L   :
                case eAspects.T   : {lineColor.shiftColor(((borderType == eWidgetPart.INNER) ? borderStyleSpecs[styleName]['TLi'] : borderStyleSpecs[styleName]['TLe'])); break;}
                case eAspects.R   :
                case eAspects.B   : {lineColor.shiftColor(((borderType == eWidgetPart.INNER) ? borderStyleSpecs[styleName]['BRi'] : borderStyleSpecs[styleName]['BRe'])); break;}
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
    *   * [eAspects] side: denormalized info; enumeration value as [:int:] indicating T/R/B/L.
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
    int                 borderType  = eWidgetPart.NONE;     //enumeration eWidgetPart (int); quick reference to what type of border this group of sides is for
    SVGElement          borderGroupElementRef   = null;     //the SVG Group hierarchically above the group of lines comprising all side(s) of a border
    WidgetBorderSide    T   = null;
    WidgetBorderSide    R   = null;
    WidgetBorderSide    B   = null;
    WidgetBorderSide    L   = null;

    //denormalized from constructor scope for convenience
    String              _instanceNameAndType   = '';
    int                 _part   = eWidgetPart.NONE;         //enumeration eWidgetPart (int)

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Helper method with obvious intent
    Parameters:
    - side : expects a valid value from the enumeration eAspects (int)
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    void _setLineID(SVGElement LineElement, int side, [strokeNumSuffix = '']) {
        LineElement.attributes = {
            'id'        : "${_instanceNameAndType}_Border_${eWidgetPart.Names[_part]}_${eAspects.ShortNames[side.toString()]}${strokeNumSuffix}",
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
            tStrokeMidY =   bounds.T + ((borderType == eWidgetPart.INNER) ? T.getStrokeInset(1.0) : T.getStrokeInset(3.0));
        }

        if (eBorderStyle.EffectsLineCount[R.style] <= 1) {
            rStrokeMidX =   bounds.R - R.getStrokeInset(2.0);
        } else {
            rStrokeMidX =   bounds.R - ((borderType == eWidgetPart.INNER) ? R.getStrokeInset(1.0) : R.getStrokeInset(3.0));
        }

        if (eBorderStyle.EffectsLineCount[B.style] <= 1) {
            bStrokeMidY =   bounds.B - B.getStrokeInset(2.0);
        } else {
            bStrokeMidY =   bounds.B - ((borderType == eWidgetPart.INNER) ? B.getStrokeInset(1.0) : B.getStrokeInset(3.0));
        }

        if (eBorderStyle.EffectsLineCount[L.style] <= 1) {
            lStrokeMidX =   bounds.L + L.getStrokeInset(2.0);
        } else {
            lStrokeMidX =   bounds.L + ((borderType == eWidgetPart.INNER) ? L.getStrokeInset(1.0) : L.getStrokeInset(3.0));
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
        tStrokeMidY =   bounds.T + ((borderType == eWidgetPart.INNER) ? T.getStrokeInset(3.0) : T.getStrokeInset(1.0));
        rStrokeMidX =   bounds.R - ((borderType == eWidgetPart.INNER) ? R.getStrokeInset(3.0) : R.getStrokeInset(1.0));
        bStrokeMidY =   bounds.B - ((borderType == eWidgetPart.INNER) ? B.getStrokeInset(3.0) : B.getStrokeInset(1.0));
        lStrokeMidX =   bounds.L + ((borderType == eWidgetPart.INNER) ? L.getStrokeInset(3.0) : L.getStrokeInset(1.0));

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
        T   = new WidgetBorderSide.line(part, eAspects.T, new SVGElement.tag('line') ),
        R   = new WidgetBorderSide.line(part, eAspects.R, new SVGElement.tag('line') ),
        B   = new WidgetBorderSide.line(part, eAspects.B, new SVGElement.tag('line') ),
        L   = new WidgetBorderSide.line(part, eAspects.L, new SVGElement.tag('line') )
    {
        _instanceNameAndType = InstanceNameAndType;
        _part = part;

        //Assign attribute values to SVG elements created in constructor
        setSVGAttributes(borderGroupElementRef, {
            'id'        : "${InstanceNameAndType}_Border_${eWidgetPart.Names[part]}",
            'display'   : 'inherit'
        });

        _setLineID(T.lineElement1, eAspects.T);
        _setLineID(R.lineElement1, eAspects.R);
        _setLineID(B.lineElement1, eAspects.B);
        _setLineID(L.lineElement1, eAspects.L);


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
        T   = new WidgetBorderSide.line(part, eAspects.T, new SVGElement.tag('line'), new SVGElement.tag('line') ),
        R   = new WidgetBorderSide.line(part, eAspects.R, new SVGElement.tag('line'), new SVGElement.tag('line') ),
        B   = new WidgetBorderSide.line(part, eAspects.B, new SVGElement.tag('line'), new SVGElement.tag('line') ),
        L   = new WidgetBorderSide.line(part, eAspects.L, new SVGElement.tag('line'), new SVGElement.tag('line') )
    {
        _instanceNameAndType = InstanceNameAndType;
        _part = part;

        //Assign attribute values to SVG elements created in constructor
        setSVGAttributes(borderGroupElementRef, {
            'id'        : "${InstanceNameAndType}_Border_${eWidgetPart.Names[part]}",
            'display'   : 'inherit'
        });

        _setLineID(T.lineElement1, eAspects.T, '1');
        _setLineID(R.lineElement1, eAspects.R, '1');
        _setLineID(B.lineElement1, eAspects.B, '1');
        _setLineID(L.lineElement1, eAspects.L, '1');
        _setLineID(T.lineElement2, eAspects.T, '2');
        _setLineID(R.lineElement2, eAspects.R, '2');
        _setLineID(B.lineElement2, eAspects.B, '2');
        _setLineID(L.lineElement2, eAspects.L, '2');

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
        T   = new WidgetBorderSide.spacing(part, eAspects.T ),
        R   = new WidgetBorderSide.spacing(part, eAspects.R ),
        B   = new WidgetBorderSide.spacing(part, eAspects.B ),
        L   = new WidgetBorderSide.spacing(part, eAspects.L )
    {
        borderType = part;
    }


    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Operator
        side : expects a valid value from the enumeration eAspects (int)
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    WidgetBorderSide operator [] (int side) => _getPart(side);

    WidgetBorderSide _getPart(int side) {
        switch (side) {
            case eAspects.T   : return T;
            case eAspects.R   : return R;
            case eAspects.B   : return B;
            case eAspects.L   : return L;
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
*    1. [WidgetBorderSide]: define aspects of each [eAspects] of each border, including
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
        Margin      = new WidgetBorder.spacing(eWidgetPart.MARGIN),
        Outer       = new WidgetBorder.line2(instanceNameAndType, eWidgetPart.OUTER),
        Frame       = new WidgetBorder.line1(instanceNameAndType, eWidgetPart.FRAME),
        Inner       = new WidgetBorder.line2(instanceNameAndType, eWidgetPart.INNER),
        Padding     = new WidgetBorder.spacing(eWidgetPart.PADDING)
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
            case eWidgetPart.MARGIN     : return Margin ;
            case eWidgetPart.OUTER      : return Outer  ;
            case eWidgetPart.FRAME      : return Frame  ;
            case eWidgetPart.INNER      : return Inner  ;
            case eWidgetPart.PADDING    : return Padding;
            default                     : return null;      //fall-through means invalid specification: throw??
        }
    }

} //class WidgetBorders
