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
* CompositeWidget Class is a [Widget] that contains embedded widget(s)
*
*/
//███████████████████████████████████████████████████████████████████████████████████████
class CompositeWidget extends Widget {

    Widget ownedWidget1 = null;


    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Override [super]'s [mouseClick] method.
    * Adds functionality to cycle-through available "states" (on/off[/null])
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void mouseClick(MouseEvent event) {

        //determine WHICH "click(s)" we want to enable... this widget's or embedded widget(s)'

        super.mouseClick(event);
    } //MouseClick




    /*
    ═══════════════════════════════════════════════════════════════════════════════════════
    TODO: DOC
    ═══════════════════════════════════════════════════════════════════════════════════════
    */
    void _createEmbeddedWidgets() {


    }


    /*
    TODO: SELECTABLE: OFF for owned controls.
    TODO: Create specific-owned-controls with "knocked-out" methods, etc., OR is it best to "whack" the methods from here?

     */



    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    /**
    * Constructs a CompositeWidget object after performing, mainly via inheritance, the same
    * type of activities that the [Widget] (base class) does during construction.
    *
    * ### Parameters
    *    * see [Widget] (base class) constructor for all parameters aside from the following...
    */
    //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CompositeWidget(String instanceName, Application appInstance, {Widget parentInstance, String typeName: 'CompositeWidget'}) :

        //Create any EMBEDDED CLASSES a widget uses that can NOT be done via Lazy initialization at object-declaration point earlier in code...
        ownedWidget1        = new Widget("${instanceName}_Owned1", appInstance, null, 'Junk', true),

        //Base class [Widget] constructor provides the substance we need
        super(instanceName, appInstance, parentInstance, typeName)

    {
        //ownedWidget1.show();
        ownedWidget1
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Base',       'ButtonWidget_Base')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_Frame',      'ButtonWidget_Frame')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderOuter','ButtonWidget_BorderOuter, UseVirtualBorder')
            ..classesCSS.addClassSelectorsForTargetObjectName('Widget_BorderInner','ButtonWidget_BorderInner');

        ownedWidget1
            .._setParent(this)
            .._create()
            ..align.T.aspect = eAspects.T
            ..align.L.aspect = eAspects.L
            ..align.B.aspect = eAspects.B
            ..show();
    }

} //class CompositeWidget

