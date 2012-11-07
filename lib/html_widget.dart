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
BEGIN: HtmlWidget Class
███████████████████████████████████████████████████████████████████████████████████████████
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* A [HtmlWidget] is just a [Widget] that contains an embedded [HtmlFO] object
* (which implements an SVG foreignObject containing HTML/Body/Div structure).
* This class allows to leverage that structure and interact with it as though we
* are working with a "Text Element" of sorts, using this class's [caption] property
* to set that "text" (including formatted-text, since it supports HTML markup).
**/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class HtmlWidget extends Widget {

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Variables, setters/getters
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    HtmlFO  _embeddedFO                 = new HtmlFO();
    HtmlFO  get embeddedFO              => _embeddedFO;

    ///HTML that will appear within the embedded [HtmlFO.htmlDiv] to form our "text".
    String  get caption                 => _caption;
    void    set caption(String newCaption) {
        if (_caption == newCaption ) return;

        _embeddedFO.innerHTML = newCaption;
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Override [super]'s [hide] method.
    * Due to an apparent flaw in Webkit-based browsers, an "Aw, Snap!" error occurs if we
    * do not *first* set the embedded FO to display:none (prior to setting the outer
    * SVG G element that contains the FO to display:none).  Clearly the browser should
    * automatically do this if it were handling hierarchically-contained DOM-object property-
    * setting and painting correctly.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void hide() {
        _embeddedFO.svgFO.attributes['display'] = 'none';

        super.hide();
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Override [super]'s [show] method.
    * See comment for [hide]; same issue being addressed here, but only from standpoint
    * of re-displaying the embedded FO that we have otherwise set "off" during hide.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void show() {
        _embeddedFO.svgFO.attributes['display'] = 'inherit';

        super.show();
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Override [super]'s (placeholder) [extendedRealign] method.
    * When parent Widget is realigned, we need to update position of our FO.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void extendedRealign() {
        _embeddedFO.updateFOMetrics();
        _applicationObject.trace(200, this);
    }



    //TODO: Consider whether we need to extend Super's [destroy] ... cleanup any DOM references, etc.
    //TODO: Currently, nothing created here that is not removed by base Widget.


    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * Constructs an HtmlWidget object after performing, mainly via inheritance, the same
    * type of activities that the [Widget] (base class) does during construction.
    *
    * ### Parameters
    *    * see [Widget] (base class) constructor for all parameters aside from the following...
    *    * [String] initialCaption: (optional) the HTML to initially load into our HtmlWidget.
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    HtmlWidget(String instanceName, Application appInstance, {Widget parentInstance, String initialCaption: ' ', String typeName: 'HtmlWidget'}) :

        //Base class [Widget] constructor provides the substance we need
        super(instanceName, appInstance, parentInstance, typeName)

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    body of constructor starts here...
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    {
        _embeddedFO.createFOStructure(this, initialCaption);
        caption = initialCaption;
    }

} //class HtmlWidget

