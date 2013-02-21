part of dart_squid;

/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

//███████████████████████████████████████████████████████████████████████████████████████
/**
* TriStateOptionWidget Class is a [Widget] that contains embedded image(s) used to
* represent either a two-state or three-state [eCheckState] selection.
* Typical uses include check-boxes, radio buttons, and similar visual selecttion
* indicator controls.
*
* Introduces a new "ImageCSSStyle" stylable-target so SVG filters and such can be applied
* to the images if desired.  ImageCSSStyle maps directly to the "style" property on the SVG
* container used to hold images, so use appropriate CSS attribute value to assign via the
* "style = attr_value_provided_goes_here".  See [createWidgetCssStyleTargets] method.
*
*/
//███████████████████████████████████████████████████████████████████████████████████████
class TriStateOptionWidget extends Widget {

    int _checkState     = eCheckState.UNCHECKED;

    ///See: [eCheckState] for details.
    int get checkState  => _checkState;
    void set checkState(int newState) {
        _checkState = newState;
        ///Make sure only the active "state" image is showing when value is changed externally.
        for (int i = 0; i < _stateImageIDs.length; i++) {
            if (_stateImageIDs[i] != null) {
                setSVGAttributes(_stateImageRefs[i], {
                    'display'       : "${(_checkState == i ? 'inherit' : 'none')}"
                });
            }
        }
    }



    bool _isNullable        = true;

    ///If [true] enables a "tri-state" selection (on, off, plus null for "n/a") vs. "two-state" only (on/off).
    bool get isNullable     => _isNullable;
    void set isNullable(bool includeInderterminateState) {
        _isNullable = includeInderterminateState;

        //Make sure a non-nullable widget does not somehow show indeterminate state visually (if prev showing).
        if (!(eWidgetState.isLoading(_widgetState))) {
            if ( (!includeInderterminateState) && (checkState == eCheckState.INDETERMINATE)) {
                checkState = eCheckState.UNCHECKED;
            }
        }
    }



    List<String> _stateImageIDs = new List(3);
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Set via constructor parameter [stateImageIDs].
    * Any post-construction changes are currently ignored by setter.
    *
    * Any ID values provided to this list must match up with a value in [Application.imageList],
    * which is an object of type [SvgDefs].
    *
    * Internal to this class, this list will always contain 3 entries,
    * with index values as follows:
    *
    *    * [0]: the "off" (aka, "un-checked") state image ID (nullable)
    *    * [1]: the "on" (aka, "checked") state image ID (required)
    *    * [2]: the "indeterminate" state image ID (nullable, optional)
    *
    * The CHECKED state image *must* exist, and at this time, its SVG width/height
    * attributes (absolute values vs. percentages or such) must exist in order for
    * the [extendedRealign] scale-to-viewbox logic to work (during any resizing of Widget).
    * And, at this time, all (provided, non-null, optional) images are assumed to share the
    * same SVG width/height as the CHECKED state.
    * (future feature may allow different sized images for the various states).
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    List<String> get stateImageIDs  =>_stateImageIDs;
    void set stateImageIDs(List<String> idList) {
        if (!(eWidgetState.isLoading(_widgetState))) return;

        //TODO: Throws vs. simple ignore-bad-args?
        if ((idList.length < 2) || (idList.length > 3)) return;
        if ((idList[1] == null) ||
            (applicationObject._imageList[idList[1]] == null)) return;

        _stateImageIDs[0] = idList[0];
        _stateImageIDs[1] = idList[1];
        _stateImageIDs[2] = idList[2];
    }

    ///Created to hold 3 elements regardless of nullability. See [eCheckState].
    List<SvgElement> _stateImageRefs = new List(3);



    //See below... needed for this mess: http://code.google.com/p/dart/issues/detail?id=3197
    Function superMouseClick;

    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Override [super]'s [mouseClick] method.
    * Adds functionality to cycle-through available "states" (on/off[/null])
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void mouseClick(MouseEvent event) {

        void showOrHideImage(bool makeShow) {
            if (_stateImageRefs[_checkState] != null) {

                setSVGAttributes(_stateImageRefs[_checkState], {
                    'display'       : "${(makeShow ? 'inherit' : 'none')}"
                });
            }
        }

        showOrHideImage(false);
        _checkState = eCheckState.getNextCheckState(_checkState, _isNullable);
        showOrHideImage(true);

        //tracing: print("${instanceName}.${typeName}.checkState now = ${eCheckState.Names[checkState]}.");

        //TODO: Dart Issue: WHY DOESN'T super.mouseClick(event) WORK HERE?! See: http://code.google.com/p/dart/issues/detail?id=3197
        superMouseClick(event);

    } //MouseClick



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Override [super]'s (placeholder) [Widget.extendedRealign] method.
    * When parent Widget is realigned, we need to update sizing of our contained immage(s).
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void extendedRealign() {
        //ASSUMPTION MADE CURRENTLY: ALL (provided) images are of same width/height as the CHECKED state.
        SvgElement sourceSVG    = applicationObject._imageList[_stateImageIDs[1]];

        //See: http://www.w3.org/TR/SVG/coords.html#ViewBoxAttribute
        //Use the "size" of the image to display as our viewBox size so that contents "scale" automatically
        //to mach the dimensions of our client-svg area.
        setSVGAttributes(_clientSvgElement, {
            'x'             : (getClientBounds().L).toString(),
            'y'             : (getClientBounds().T).toString(),
            'width'         : (getClientBounds().Width).toString(),
            'height'        : (getClientBounds().Height).toString(),
            'viewBox'       : '0 0 ${sourceSVG.attributes["width"]} ${sourceSVG.attributes["height"]}',
            'preserveAspectRatio'   : 'xMidYMid'
        });

    } //extendedRealign



    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    For each provided image reference, create a cloned (i.e., "use") structure equivalence
    of that reference inside this Widget's _clientSvgElement.
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    void _createImageStructure() {

        for (int i = 0; i < _stateImageIDs.length; i++) {
            if (_stateImageIDs[i] != null) {
                _stateImageRefs[i] = applicationObject._imageList.useSvgDef(
                    _clientSvgElement,
                    _stateImageIDs[i],
                    '${_entireGroupName}_${(eCheckState.Names[i])}',
                    (_checkState == i ? 'inherit' : 'none')
                );
            }
        }

    } //_createImageStructure



    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * Handle our directly-styled ImageCSSStyle style-target value.
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    void _applyCSSStyleAttributesToImages(String cssAttributeValue) {
        setSVGAttributes(_clientSvgElement, { 'style' : cssAttributeValue });
    }



    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * See [Widget.createWidgetCssStyleTargets] for details.
    * Add a style-target that will allow applying CSS style attribute information to
    * the the entire image(s) structure.
    *
    * ## Example usage:
    *     widgetInstance.classesCSS.setClassSelectorsForTargetObjectName('ImageCSSStyle' , 'filter:url(#Effect_3D);')
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    void createWidgetCssStyleTargets() {
        super.createWidgetCssStyleTargets();
        classesCSS.createDefaults(
            [
                new CssTargetAndSelectorData('ImageCSSStyle' , '' , true , _applyCSSStyleAttributesToImages)
            ]
        );
    }



    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * Constructs an TriStateOptionWidget object after performing, mainly via inheritance, the same
    * type of activities that the [Widget] (base class) does during construction.
    *
    * ### Parameters
    *    * see [Widget] (base class) constructor for all parameters aside from the following...
    *    * List<String> imageIDs: see [stateImageIDs] for description.
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    TriStateOptionWidget(String instanceName, Application appInstance, List<String> imageIDs, {Widget parentInstance, String typeName: 'TriStateOptionWidget'}) :

        //Base class [Widget] constructor provides the substance we need
        super(instanceName, appInstance, parentInstance, typeName)

    {
        stateImageIDs = imageIDs;
        _createImageStructure();
        superMouseClick = super.mouseClick;
    }

} //class TriStateOptionWidget

