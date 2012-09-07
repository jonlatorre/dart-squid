/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/


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
    HtmlFO  _embeddedFO                 = null;
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
    HtmlWidget(String instanceName, Application appInstance, [Widget parentInstance = null, String typeName = 'HtmlWidget', String initialCaption='']) :
        //CREATE EMBEDDED CLASSES we use...
        _embeddedFO = new HtmlFO(),

        //call super's constructor
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

