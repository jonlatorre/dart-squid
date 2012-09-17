/*
    Copyright (c) 2011-2012, Mike Eberhart & Intersoft Development, Inc.

        Author: Mike Eberhart, CEO
        http://www.intersoftdevelopment.com

    We release these works under the terms of the MIT License (for freeware).
    See LICENSE file (in project root) for MIT licensing information.
*/

/*
███████████████████████████████████████████████████████████████████████████████████████████
BEGIN: WIDGET-STYLING CLASSES
███████████████████████████████████████████████████████████████████████████████████████████
*/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* A [Widget] (or derived subclass) can have its visual presentation styled by CSS.
* Certain parts of the widget
* (like its background, frame, and inner & outer borders) are "target objects" for styling.
* E.g., one [targetObject] is 'Widget_BorderOuter'.
* Each of [targetObject] parts can contain *multiple* stylable
* [targetProperty] (style-target-properties).
* E.g., the 'Widget_BorderOuter' can have [targetProperty] values that CSS will be used
* to style, like:
* 'border-top-width', 'border-bottom-color', and so forth.
*
* So, each StyleTarget targetObject/targetProperty combination represents one
* stylable aspects of a widget.
* A [Widget] maintains a list of its style-able aspects in
* its _StylablePropertiesList (private variable).
*
* A Widget's [CSSTargetsMap] (exposed as [Widget.classesCSS] property) contains *keys*
* that correspond to a [StyleTarget.targetObject]; that [CSSTargetsMap] also contains
* *values* which are CSS class-selector(s) "class-names" to apply to each [targetObject].
* The resulting, post-CSS-styled, calcValue for each [targetProperty] on a [targetObject]
* will be placed in [calcValue].
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class StyleTarget {

    /**
    * The logical visual sub-component of the Widget that we are styling (e.g., its Frame).
    */
    String  targetObject    = '';

    /**
    * Within a [targetObject], various TargetProperties can be affected by CSS values.
    * Within a targetObject, e.g., the border-style, border-width, and stroke-color properties may be
    * available for styling with CSS.
    *
    * **NOTE:** even though *SVG-specific* PropertyNames show in Chrome's object-inspector (debugger)
    * as non-hyphenated camelCase, our list and lookups must use hyphenated lower-case form
    * (at least for Chrome v18-23+) to get values.
    */
    String  targetProperty  = '';

    /**
    * In the absence of externally-provided (or determinable) value, this is what
    * the [calcValue] will apply to the [targetProperty]; i.e., these are logical
    * defaults for a Widget's styling.
    */
    String  defaultValue    = '';

    /**
    * The value to be assigned to the [targetProperty] as determined by applying
    * CSS class-selector(s), from matches in CSSTargetsMap, to a Widget's
    * [targetObject] / [targetProperty].
    */
    String  calcValue       = null;     //Calculated

    StyleTarget (this.targetObject, this.targetProperty, this.defaultValue);

} //class StyleTarget



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Used to populate **initial** lists of Style Targets in Widget, etc.
* Values in these objects are transferred to "full" (non constant-only) [StyleTarget]
* object instances elsewhere.
*
* TODO: Will lazy-initializer feature remove the need for this class somehow?
*
* ## See Also
* [Widget.InitialStylableWidgetProperties] creates a constant list of these objects.
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class ConstStyleTarget {
    ///A CSS-stylable-target on a Widget
    final String  targetObject;

    ///A particular CSS property applicable to a [targetObject]
    final String  targetProperty;

    ///Default value for the [targetProperty] if CSS-calculations yield no result.
    final String  defaultValue;

    const ConstStyleTarget (this.targetObject, this.targetProperty, this.defaultValue);
}


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Used as storage structure within [CSSTargetsMap] internal Map's "values" portion of Map.
* See that class for more information.
*
* ## See Also
* [Widget.createWidgetCssStyleTargets] : creates a list of these objects and executes
* [CSSTargetsMap.createDefaults] to load the map with values.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class CssTargetAndSelectorData {
    ///A CSS-stylable-target on a Widget
    String  targetObjectName;

    ///CSS selectors applied to a given [targetObjectName]
    String  appliedCssSelectors;

    ///When [true] there is no need to perform off-screen CSS-calc routines to obtain values.
    bool    isStyledDirectly;

    ///(optional) a callback method available to perform functionality when appliedCssSelectors change
    ChangeHandler  changeHandler;


    CssTargetAndSelectorData (this.targetObjectName, this.appliedCssSelectors, this.isStyledDirectly, this.changeHandler);
}


//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* A map of TargetObject names (KEY) and associated comma-delimited list of CSS Class Names selectors (VALUE)
* pairs that indicate what CSS classes are to be applied to a Widget's [StyleTarget.targetObject] in order
* to affect the Calculated values for [StyleTarget.targetProperty] when we apply CSS rules to
* compute a "Styled" widget's values.
*
* ** See [StyleTarget] class notes for further explanation** of how this class fits within framework styling paradigm.
*
* The embedded [Map] object is exposed only via specialized methods for proper encapsulation and
* to prevent user from bypassing change-detection logic. Operations like adding to
* or removing from the comma-delim values string are done through methods that detect change
* while also ensuring proper formatting of this string.
*
* ## NOTE
* We must use the *non-comma-delimited equivalent* value (in [Application.getCSSPropertyValuesForClassNames])
* because of how the off-screen class-resolution expects it to be formatted.
* We use the [] operator to access this space-delimited version of value.
*
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class CSSTargetsMap {

    //See constructor notes.
    Application _applicationObject = null;

    //See constructor notes.
    List<StyleTarget> _stylablePropertiesList = null;

    //═══════════════════════════════════════════════════════════════════════════════════════
    /**
    * The "key" for this Map is TargetObject names (aligned with values in our StylablePropertiesList —
    * a list of [StyleTarget] objects).
    * The "value" portion of this Map holds our "appliedCssSelectors" (comma-delim class-selectors)
    * and other information that applies to target.
    */
    //═══════════════════════════════════════════════════════════════════════════════════════
    Map<String, CssTargetAndSelectorData> _targetObjectsAndSelectors = new  Map();


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * NOTE: **must call** [setStylablePropertiesListRef] in addition to this constructor
    * prior to an instance of this object being first used.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    CSSTargetsMap()
    {}


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * See constructor note. This must be called (by Widget) within Widget constructor prior
    * to any operations that could use this object!
    *
    * ## Parameters
    *    * [appRef] : a reference to the [Application] object
    *     to use for CSS calc calls (to [Application.getCSSPropertyValuesForClassNames]).
    *    * [listRef] : reference to [Widget] instance's [List<StyleTarget>]
    *    CSS-stylable-targetObjectName/Properties where CSS calculations will be stored.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void setStylablePropertiesListRef(Application appRef, List<StyleTarget> listRef) {
        _applicationObject = appRef;
        _stylablePropertiesList  = listRef;
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Easy way to populate our [Map] without triggering changeHandler.
    * Initially, populate Map with key = value
    * (i.e., key/target-object-name and default-selector-name are identical).
    * This is done so that any "default" StyleTargets on a Widget can be styled using
    * a CSS selector of the same name.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void createDefaults(List<CssTargetAndSelectorData> targets) {
        targets.forEach( (CssTargetAndSelectorData target) {
            _targetObjectsAndSelectors[target.targetObjectName] = target;
        });
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    ///Useful for debugging purposes.
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    String getMapAsString() {
        String sTemp = '';
        _targetObjectsAndSelectors.forEach( (String targetName, CssTargetAndSelectorData item) {
            sTemp = "${sTemp}${(sTemp.length > 0 ? ',    ' : '')}";
            sTemp = "${sTemp}${targetName} : ${item.appliedCssSelectors}";
        });
        return sTemp;
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Returns the [CssTargetAndSelectorData.appliedCssSelectors] value
    * portion of Map that contains any CSS Class selector(s),
    * but as *space-delim* version which is critically important in off-screen
    * CSS calcs performed in [Application] object.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    String operator [] (String key) => _getFormattedSelectors(key);

    String _getFormattedSelectors(String key) {
        String sTemp = _targetObjectsAndSelectors[key].appliedCssSelectors;
        return (sTemp != null ? sTemp.replaceAll(',', ' ') : '');
    }


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    ///Helper method for repetitive logic.
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void _fireCssPropertyUpdatesAndNonNullHandler(String targetName) {
        if (_targetObjectsAndSelectors[targetName].changeHandler != null) {

            //Only need to call CSS property-value off-screen calc routine for those Widget parts not "directly" styled,
            //by their changeHandler. This could be due to inline-CSS-style considerations or other method of styling.
            if ( !_targetObjectsAndSelectors[targetName].isStyledDirectly) {
                //NOTE: instead of using the "key" value from Map, use the [] operator equiv to get the NON-COMMA-DELIM version of key! (IMPORTANT)
                _applicationObject.getCSSPropertyValuesForClassNames(targetName, _getFormattedSelectors(targetName),  _stylablePropertiesList);
            }

            _targetObjectsAndSelectors[targetName].changeHandler(targetName);
        }
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Convenience method. Will traverse all objects in our Map, call the
    * [Application.getCSSPropertyValuesForClassNames] for each entry, and fire any non-null
    * (assigned) CSS-change event-handler for each.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void updateAllCSSValues() {
        _targetObjectsAndSelectors.forEach( (String targetName, CssTargetAndSelectorData target) {
            _fireCssPropertyUpdatesAndNonNullHandler(targetName);
        });
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Replace the [CssTargetAndSelectorData.appliedCssSelectors] value
    * for a given [CssTargetAndSelectorData.targetObjectName] within the Map
    * if the key exists; otherwise, ignore.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void setClassSelectorsForTargetObjectName(String targetName, String newSelectors) {
        //remove any extraneous spaces
        newSelectors = newSelectors.replaceAll(' ', '');

        if (_targetObjectsAndSelectors.containsKey(targetName)) {
            _targetObjectsAndSelectors[targetName].appliedCssSelectors = newSelectors;

            _fireCssPropertyUpdatesAndNonNullHandler(targetName);
        }
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Add selector(s) in [newSelectors] to an existing Map entry's (with key = [targetName])
    * list of class-selectors (comma-delim).
    *
    * If the key does not exists, ignore the request, as it would be meaningless for styling.
    * The added value(s) must remain unique in the appliedSelectors string.
    * If a change to value portion results from this request, fire the [changeHandler].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void addClassSelectorsForTargetObjectName(String targetName, String newSelectors) {
        if (!_targetObjectsAndSelectors.containsKey(targetName)) return;

        //remove any extraneous spaces
        newSelectors = newSelectors.replaceAll(' ', '');

        List<String> existingSelectorsAsList    = _targetObjectsAndSelectors[targetName].appliedCssSelectors.split(',');
        List<String> newSelectorsAsList         = newSelectors.split(',');
        List<String> addTheseSelectorsList      = new List<String>();
        bool hasChanged = false;

        for (String sSelector in newSelectorsAsList) {
            if (existingSelectorsAsList.indexOf(sSelector) == -1) {
                //our Selectors do not already include...
                hasChanged = true;
                addTheseSelectorsList.add(sSelector);
            }
        }

        if (!hasChanged) return;

        //add any newly-found selectors and convert this list back into a single comma-delim string value...
        existingSelectorsAsList.addAll(addTheseSelectorsList);

        StringBuffer sbTemp = new StringBuffer();
        int i = 0;
        for (String sSelector in existingSelectorsAsList) {
            if (i > 0) {sbTemp.add(',');}
            sbTemp.add(sSelector.trim());
            i++;
        }

        _targetObjectsAndSelectors[targetName].appliedCssSelectors = sbTemp.toString();

        _fireCssPropertyUpdatesAndNonNullHandler(targetName);

    } //AddClassSelectorForTargetObjectName



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Remove selector(s) in [delSelectors] from an existing Map entry's (with key = [targetName])
    * list of class-selectors (comma-delim).
    * If the key does not exists, ignore the request, as it would be meaningless for styling.
    * If a change to value portion results from this request, fire the [changeHandler].
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void removeClassSelectorsForTargetObjectName(String targetName, String delSelectors) {
        if (!_targetObjectsAndSelectors.containsKey(targetName)) return;

        //remove any extraneous spaces
        delSelectors = delSelectors.replaceAll(' ', '');

        List<String> existingSelectorsAsList    = _targetObjectsAndSelectors[targetName].appliedCssSelectors.split(',');
        List<String> delSelectorsAsList         = delSelectors.split(',');

        bool hasChanged = false;

        for (String sSelector in delSelectorsAsList) {
            if (existingSelectorsAsList.indexOf(sSelector) > -1) {
                //found one to remove...
                hasChanged = true;
                existingSelectorsAsList.removeRange(existingSelectorsAsList.indexOf(sSelector), 1);
            }
        }

        if (!hasChanged) return;

        //convert any values remaining in our list back into a single comma-delim string value...
        StringBuffer sbTemp = new StringBuffer();
        int i = 0;
        for (String sSelector in existingSelectorsAsList) {
            if (i > 0) {sbTemp.add(',');}
            sbTemp.add(sSelector.trim());
            i++;
        }

        _targetObjectsAndSelectors[targetName].appliedCssSelectors = sbTemp.toString();

        _fireCssPropertyUpdatesAndNonNullHandler(targetName);

    } //RemoveClassSelectorsForTargetObjectName


} //class CSSTargetsMap
