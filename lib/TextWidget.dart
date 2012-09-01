/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/


/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: TextWidget Class
███████████████████████████████████████████████████████████████████████████████████████████
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* A [TextWidget] is just a [Widget] that contains an embedded [HtmlFO] object
* (which implements an SVG foreignObject containing HTML/Body/Div structure).
* This class allows to leverage that structure and interact with it as though we
* are working with a "Text Element" of sorts, using this class's [caption] property
* to set that "text" (including formatted-text, since it supports HTML markup).
**/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class TextWidget extends Widget {

    /*
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    Variables, setters/getters
    ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    */
    bool    _areCaptionUpdatesPending   = true;
    String  _pendingCaptionValue        = '';

    HtmlFO  _embeddedFO                 = null;
    HtmlFO  get embeddedFO              => _embeddedFO;

    ///HTML that will appear within the embedded [HtmlFO.htmlDiv] to form our "text".
    String  get caption                 => _caption;
    void    set caption(String newCaption) {
        if (_caption == newCaption ) return;

        //workaround Webkit issue with updating innerHTML inside FO Div that is not visible
        if (!visible) {
            _pendingCaptionValue = newCaption;
            _areCaptionUpdatesPending = true;
            return;
        }

        _embeddedFO.innerHTML = newCaption;
        _areCaptionUpdatesPending = false;
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

        //Webkit issue workaround (see caption-setter); note: visible is now true here.  //TODO: Needed anymore???
        if (_areCaptionUpdatesPending) {
            caption = _pendingCaptionValue;
        }
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Override [super]'s (placeholder) [extendedRealign] method.
    * When parent Widget is realigned, we need to update position of our FO.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void extendedRealign() {
        _embeddedFO.updateFOMetrics();
        //print('extendedRealign fired; instance: ${instanceName}');
    }



    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CONSTRUCTOR

    Parameters: see [Widget] (base class) constructor

    Consider whether we need to extend Super's [destroy] ... cleanup any DOM references, etc.
    Currently, nothing created here that is not removed by base Widget.
    TODO: DOCUMENT
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    TextWidget(String instanceName, Application appInstance, [Widget parentInstance = null, String typeName = 'Text', String initialCaption='']) :
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

} //class TextWidget

