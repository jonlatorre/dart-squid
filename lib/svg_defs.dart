/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

//███████████████████████████████████████████████████████████████████████████████████████
/**
* ConstSvgDefsItem is used by [SvgDefs] in order to make re-usable SVG <defs>
* content available throughout an [Application]
* -- most notably images and SVG filters and the like.
* The content to re-use can be sourced from external files (using [defURL] property) or
* from a string-representation of SVG construct to re-use (using [defText] propety).
*
*/
//███████████████████████████████████████████████████████████████████████████████████████
class ConstSvgDefsItem {
    ///The name, or "id" to assign to the Def entry and use as our Map-key in [SvgDefs]
    final String    defId;


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Mutually exclusive with [defURL]; use this only for Applications not running from http server.
    *
    * Simply provide a valid SVG <defs> structure, in string format.  E.g.,:
    *
    *    <svg id="svgBlueCheckMark" width="64" height="64">
    *        <defs id="defs">
    *            <linearGradient id="linearGradient1">
    *                <stop style="stop-color:#4682b4;stop-opacity:1;" offset="0" id="stopLight"/>
    *                <stop style="stop-color:#483d8b;stop-opacity:1;" offset="1" id="stopDark"/>
    *            </linearGradient>
    *            <linearGradient xlink:href="#linearGradient1" id="linearGradient2" gradientUnits="userSpaceOnUse" x1="20" y1="40" x2="40" y2="0"/>
    *        </defs>
    *        <g id="checkMark">
    *            <path id="checkOutline" style="stroke:#333333; stroke-width:1.5; fill:none;" d="m 12,26 10,10 30,-30 10,10 -40,40 -20,-20 z" />
    *            <path id="checkFill" d="m 12,26 10,10 30,-30 10,10 -40,40 -20,-20 z" style="fill:url(#linearGradient2);fill-opacity:1;stroke:none"/>
    *        </g>
    *    </svg>
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    final String    defText;


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Either an absolute location, or relative (to where [Application] code resides) one,
    * from which to acquire valid SVG <defs> content. E.g., an SVG image file or file
    * containing filter definition.
    *
    * Mutually exclusive with [defText]; used only for Applications running from http server.
    * If both [defText] AND [defURL] are provided, [SvgDefsItem] will choose the [defText],
    * since that option can be used whether [Application] is being run from a server or locally,
    * whereas the [defURL] version relies on an HttpRequest object.
    *
    * NOTE: if *only* [defURL] is provided, and [Application] is not run from http server,
    * expect to encounter a message something like this:
    *
    *     HttpRequest cannot load file:///drive:/path_to_file/filename.html. Cross origin requests are only supported for HTTP.
    *     Exception: Error: NETWORK_ERR: HttpRequest Exception 101
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    final String    defURL;

    String toString() => "Id = ${defId};  URL = ${defURL}; Text = ${(defText == null ? '' : '(Appears on next line)\n')}${defText}";

    //constructor
    const ConstSvgDefsItem(this.defId, {this.defText: null, this.defURL: null});

    //const constructor cannot contain a method body, therefore cannot enforce the need for ONE of the optional parms as would be ideal:
    //  if ((defText == null) && (defURL == null)) { throw new Exception('${e} \nConstSvgDefsItem constructor requires either defText OR defURL be non-null value.)');}
    //is there another easy way to do this?  Trapped for this in SvgDefs instead for now.
}


//███████████████████████████████████████████████████████████████████████████████████████
/**
* The [SvgDefs] class wraps up some common functionality for dealing with "re-usable"
* SVG content by way of SVG <defs>.  [ConstSvgDefsItem] instances are provided to
* this class via add... methods and/or constructor parameter.
*
* SVGElement(s) containing re-usable SVG <defs> content are created for each provided
* [ConstSvgDefsItem] definition and made available throughout an [Application] --
* most notably images and SVG filters and the like are contained.  A given item def's
* associated SVGElement is accessible via the `[]` operator using "id" value provided
* in [ConstSvgDefsItem].   That SVGElement can be "used" (i.e., cloned elsewhere in
* the application) via the [useSvgDef] method.
*/
//███████████████████████████████████████████████████████████████████████████████████████
class SvgDefs {

    //See constructor notes.
    List<ConstSvgDefsItem> _svgDefsItemsList = null;

    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * The "key" for this Map is derivied from [ConstSvgDefsItem.defId]
    *
    * The "value" portion of this Map holds a reference to a dynamically-created SVG element.
    *
    * TODO: Map value may be replaced with a class that holds additional information:
    * e.g., may wish to keep image-sizing information handy, etc.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    Map<String, SVGElement> _svgDefsMap = new  Map();



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Returns the [SVGElement] (from within our SVG <defs> structure) associated with [key],
    * whose value must match one of the [ConstSvgDefsItem.defId] values that has been
    * provided via [addDefToSvgRoot] or [addDefsInListToSvgRoot] methods (or constructor parm).
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    SVGElement operator [] (String key) => _svgDefsMap[key];



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Adds a single <svg> structure for a given <defs> item specified in [defItem] into the
    * SVG [rootDefsElement] provided.
    *
    * ## Parameters:
    *    * [defItem] : the [ConstSvgDefsItem] describing the <defs> item to be created.
    *    * [rootDefsElement]  : generally just pass [getSvgRootDefsElement] (framework top-level function).
    *    * [idOfNewUseNode] : pass [isRunningOnServer] (framework top-level function).
    *
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void addDefToSvgRoot(ConstSvgDefsItem defItem, SVGElement rootDefsElement, bool isRunningOnServer) {
        SVGElement tempSVG = null;
        tempSVG = new SVGElement.tag('svg');

        //String-based specifier will take precedence since this works with Apps on server (http:) AND local (file:) filesystem.
        if (defItem.defText != null) {
            tempSVG.innerHTML = defItem.defText;
        } else {
            if ((isRunningOnServer) && (defItem.defURL != null)) {

                //MUST get files synchronously or all sorts of issues occur throughout app!
                HttpRequest request = new HttpRequest();
                request.open("GET", defItem.defURL, async : false);
                request.send();

                if (request.statusText.toUpperCase() == "OK") {
                    tempSVG.innerHTML = request.responseText;
                } else {
                    throw new Exception('Specified URL is invalid / unreachable; request status = ${request.statusText}. Specified defItem value: \n${defItem.toString()}');
                }
            } else {
                tempSVG = null;
                throw new Exception('Specified defItem value(s) not compatible with run-environment (e.g., only URL provided but not running from HTTP? neither Text nor URL provided in defItem?): \n${defItem.toString()}');
            }
        }

        //The "cloning" here fixes auto-sizing-of-SVGs (which do not occur when node is otherwise assigned)
        try {
            _svgDefsMap[defItem.defId] = tempSVG.nodes[0].clone(true);
        }
        catch (e) {
            String errorMsg = '''
                ${e}
                \nSevere error in SvgDefs._addDefToSvgRoot while attempting to clone SVG Node per defItem value: \n${defItem.toString()}
                \nPOTENTIAL CAUSE: ${(defItem.defText != null ? "malformed SVG in defText field." : "Specified URL is invalid / unreachable or other unknown error.")}
            ''';
            throw new Exception(errorMsg);
        }


        rootDefsElement.nodes.add(_svgDefsMap[defItem.defId]);

    } //addDefToSvgRoot



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * For each element provided in [defsList] parameter, calls [addDefToSvgRoot].
    * Simplified way to add a large group of "defs" at once.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void addDefsInListToSvgRoot(List<ConstSvgDefsItem> defsList) {
        //get these just once, for optimal speed
        SVGElement rootDefsElement  = getSvgRootDefsElement();
        bool isRunningOnServer      = isRunningOnServer();

        defsList.forEach( (ConstSvgDefsItem defItem) {
            addDefToSvgRoot(defItem, rootDefsElement, isRunningOnServer);
        });
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Essentially, emulates an SVG <use> based on a <defs> item by cloning the desired
    * <defs> item into a specified target [cloneToNode].  Each "def" has been wrapped by
    * an <svg> tag construct for consistency within the [addDefToSvgRoot] method.
    *
    * ## Parameters:
    *    * [cloneToNode] : the [SVGElement] into which the specified <defs> item will be cloned.
    *    * [defIdToUse]  : the String value of the "id" identifying the <defs> item to clone.
    *    * [idOfNewUseNode] : the "id" value to assign to the cloned <svg> tag.
    *    * [initialDisplayState] : (optionl) determines whether cloned <svg> "use" structure
    *    will be showing (the default) or not upon creation; pass either "inherit" or "none"
    *    (i.e., standard svg display attr values).
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    SVGElement useSvgDef(SVGElement cloneToNode, String defIdToUse, String idOfNewUseNode, [String initialDisplayState='inherit']) {
        SVGElement _clonedFromDef   = null;

        if (_svgDefsMap[defIdToUse] == null) {
            return null;  //TODO: Throw?
        }

        _clonedFromDef = _svgDefsMap[defIdToUse].clone(true);

        setSVGAttributes(_clonedFromDef, {
            'id'            : idOfNewUseNode,
            'display'       : initialDisplayState
        });

        cloneToNode.nodes.add(_clonedFromDef);
        return _clonedFromDef;
    }



    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * Constructs an SvgDefs object, and if optional parameter provided, creates SVG defs
    * during constructor; otherwise, [addDefsInListToSvgRoot] and/or [addDefToSvgRoot]
    * method(s) will need to be called post-construction to create SVG <defs> items.
    *
    * ### Parameters
    *    * List<ConstSvgDefsItem> (optional) list of Image definitions of type [ConstSvgDefsItem] to
    *    load into our SvgDefs during creation.
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    SvgDefs(List<ConstSvgDefsItem> this._svgDefsItemsList)
    {
        if (_svgDefsItemsList != null) addDefsInListToSvgRoot(_svgDefsItemsList);
    }

} //class SvgDefs


/*
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
DEVELOPER NOTES / FUNCTIONALITY DISCUSSSION for SvgDefs:

SEE MY ISSUE REPORT: http://code.google.com/p/dart/issues/detail?id=5395
"Dynamically Generated (Dart) SVG Elements with "xlink:href" attributes will not render
in Dartium (or Chromium using Dart2JS)."  This issue report pertains only to
in-the-same-SVG-file-defs-references, as Webkit (in general) fails to honor ANY external
file-referenced xlink:href content.
--------------------------------------------------------------------------------------

So, we "Embed" the DEF via cloning for now...

Embed the DEF via cloning...
It may appear easier to implement via <use xlink:href="#checkMark"> or <image xlink:href>
or, better yet, reference EXTERNAL FILES, but Webkit is a buggy piece of junk when it
comes to this.  And, for same-file-ref'd "use" or "image" tag(s), the expected content
will show up in the DOM tree but not DISPLAY! (issue 5395) since xlink attribute not
being created with proper namespace information.

A KEY NOTE TO MENTION: the USE/IMAGE (referencing <defs> content) approach DOES WORK
WITHIN *STATIC SVG STRUCTURES*  but not within DYNAMICALLY CREATED content/structures
(and, obviously all [Application] [Widget] controls create their structures at runtime.)

The following approach *should* work once the Dart team fixes the attributes setter to
support namespaces (need xlink NS for xlink attr!)

    _clonedFromDef = new SVGElement.tag('use');
    _clonedFromDef.attributes = {
        'id': idOfNewUseNode,
        'xlink:href'    : defIdToUse
    };
    cloneToNode.nodes.add(_clonedFromDef);

--------------------------------------------------------------------------------------
There are also problem with externally-ref'd filters (defs) not being available...
See this: http://code.google.com/p/chromium/issues/detail?id=109212 bug report.

--------------------------------------------------------------------------------------
THE ONLY OTHER APPROACH that worked currently was assigning string-representation
of the entire-SVG-symbol into the innerHTML; this works inside HTML docs at least,
though Dart Issue 2977 prevents standalone SVG docs from working with this code:

    cloneToNode.innerHTML = svgStructureAsString;

*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
