/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/


/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: IFrameFO Class
███████████████████████████████████████████████████████████████████████████████████████████
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* An [IFrameFO] encapsulates an iFrame inside a SVG foreignObject and allows
* interaction with that iFrame by setting the URL (via [setURL] method) that will
* be used to retrieve content from and populate the iFrame within.
*
* Unlike the somewhat similar [HtmlFO] class, this class implements no specific provisions
* for setting scroll-overflows since the iFrame handles this automatically.
*
*
* ## See Also
*    * [IFrameWidget] is the specialized [Widget] subclass that embeds the [IFrameFO] within it.
*    * [HtmlFO] is similar, but allows direct manipulation of embedded HTML content.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class IFrameFO {
    //These variables obtain their value during createFOStructure
    Widget              _ptrWidget              = null;
    SVGElement          _ptrSVGElementForFO     = null;
    String              _idOfSVGElementForFO    = '';

    //these hold refs to our created elements, and inner content
    SVGForeignObjectElement _foElementRef       = null;
    Element             _iFrameObj              = null;

    //accessors
    SVGElement      get svgFO                   => _foElementRef;
    Element         get iFrame                  => _iFrameObj;


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Creates the following FO / HTML structure within the [Widget] specified by [widget] parameter,
    * within the Widget's client-region (i.e., [Widget.clientSVGElement]).
    *
    *     <foreignObject x="10" y="10" width="100" height="150">  //NOTE: Metrics filled in later
    *         <iframe>
    *             ...any HTML content appearing here is loaded in from a URL via [setURL] method.
    *         </iframe>
    *     </foreignObject>
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void createFOStructure(Widget widget) {
        _ptrWidget              = widget;
        _ptrSVGElementForFO     = widget.clientSVGElement;
        _idOfSVGElementForFO    = _ptrSVGElementForFO.attributes['id'];

        _foElementRef.attributes = {
            'display'       : 'inherit',
            'id'            : "${_idOfSVGElementForFO}_ContainerFO"
        };

        _iFrameObj.attributes = {
            'id'            : "${_idOfSVGElementForFO}_ContainerFOiFrame",
            'marginwidth'   : "0",
            'marginheight'  : "0",
            'scrolling'     : "auto"
        };

        _foElementRef.nodes.add(_iFrameObj);
        _ptrSVGElementForFO.nodes.add(_foElementRef);
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Update position and sizing information...
    * See [HtmlFO.updateFOMetrics] for important algorithmic notes regarding
    * why we compute the FO position the way we do.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void updateFOMetrics() {
        //trap for strange-order of calls that could try to execute this prior to avail.
        if (_ptrWidget == null) return;

        num    widgetTranslateX = _ptrWidget.translateX;
        num    widgetTranslateY = _ptrWidget.translateY;

        String L       = _ptrWidget.getClientBounds().L.toString();
        String T       = _ptrWidget.getClientBounds().T.toString();

        String adjL    = (_ptrWidget.getClientBounds().L + widgetTranslateX).toString();
        String adjT    = (_ptrWidget.getClientBounds().T + widgetTranslateY).toString();
        String Width   = _ptrWidget.getClientBounds().Width.toString();
        String Height  = _ptrWidget.getClientBounds().Height.toString();

        setSVGAttributes(_foElementRef, {
            'x'             : adjL,
            'y'             : adjT,
            'width'         : Width,
            'height'        : Height,
            'transform' : 'translate(${(-widgetTranslateX)},${(-widgetTranslateY)})'
        });


        setElementAttributes(_iFrameObj, {
            'x'             : L,
            'y'             : T,
            'width'         : Width,
            'height'        : Height
        });

    }  //updateFOMetrics



    void setURL(String urlToLoad) {
        setElementAttributes(_iFrameObj, {
            'src'           : "${urlToLoad}"
        });
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * **Note:** after construction, [createFOStructure] will need called, and the
    * [updateFOMetrics] will need to be called during [Widget] alignment.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    IFrameFO() :
        _foElementRef   = new SVGElement.tag('foreignObject'),
        _iFrameObj      = new IFrameElement();

} //IFrameFO




/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: IFrameWidget Class
███████████████████████████████████████████████████████████████████████████████████████████
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* An [IFrameWidget] is just a [Widget] that contains an embedded [IFrameFO] object
* (which is a construct using an iFrame inside a SVG foreignObject). This class allows
* interaction with that IFrameFO by setting the URL (via [setURL] method) that will
* be used to retrieve content from and populate the iFrame within.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class IFrameWidget extends Widget {

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Variables, setters/getters
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    IFrameFO    _embeddedFO     = new IFrameFO();
    IFrameFO    get embeddedFO  => _embeddedFO;


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Override [super]'s [hide] method.
    * Due to an apparent flaw in Webkit-based browsers, an "Aw, Snap!" error occurs if we
    * do not *first* set the embedded FO to display:none (prior to setting the outer
    * SVG G element that contains the FO to display:none).  Clearly the browser should
    * automatically do this if it were handling hierarchically-contained DOM-object property-
    * setting and painting correctly.
    *
    * TODO: needed by HtmlWidget; not sure if truly needed in IFrameWidget yet. Confirm.
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
    *
    * TODO: needed by HtmlWidget; not sure if truly needed in IFrameWidget yet. Confirm.
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
    }


    ///Set the URL used as source-HTML for to populate embedded [IFrameFO] contents.
    void setURL(String url) {
        _embeddedFO.setURL(url);
    }


    //TODO: Consider whether we need to extend Super's [destroy] ... cleanup any DOM references, etc.
    //TODO: Currently, nothing created here that is not removed by base Widget.


    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * Constructs an IFrameWidget object after performing, mainly via inheritance, the same
    * type of activities that the [Widget] (base class) does during construction.
    *
    * ### Parameters
    *    * see [Widget] (base class) constructor for all parameters aside from the following...
    *    * [String] initialURL: (optional) TODO - Set after construction outside this right now; implement here.
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    IFrameWidget(String instanceName, Application appInstance, [Widget parentInstance = null, String typeName = 'IFrameWidget', String initialURL='']) :

        //Base class [Widget] constructor provides the substance we need
        super(instanceName, appInstance, parentInstance, typeName)

    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    body of constructor starts here...
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    {
        _embeddedFO.createFOStructure(this);
        //TODO: set any initial URL
    }

} //class IFrameWidget

