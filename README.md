dart-squid
==========

DART / SVG Quick UI Development Widgets

dart-squid is an open-source **D**art / **S**vg **Q**uick **UI** **D**evelopment framework and components / widget set for browser-based **applications**.
SVG (Scalable Vector Graphics) is used for the UI rendering. CSS is (indirectly) used for styling of SVG Widgets.

The longer-term objectives are to develop both a RAD component set and an IDE that will make creating web-applications very similar to writing Delphi desktop applications.  In fact, if you are familiar with Delphi (VCL), the component structure, hierarchy, and implementation paradigm should be somewhat familiar and the Dart language provides very similar programming capabilities.

## Status: Alpha ##
Project is currently in the **alpha** stage of development, but quite functional and rather well documented.
Currently, these widgets only work well within Dartium (DART) or Chrome (JS via dart2js) browsers. Other browsers are not a current priority, and may never be.

These components currently serve as a proof-of-concept that explores the viability of relying on SVG for a visual widget set.  Due to outstanding issues with browser bugs (like proper SVG region-repaints in Webkit), there are limitations with what is possible.

## Getting Started ##
### Online Samples (requires Dartium) ###
[Online dart-squid Samples](http://mv4t.com/dart-squid/samples/samples-index.html) : I will try to keep this sample up-to-date as any substantial changes to the features/functionality change.

### Features and Functionality ###
For now, see Documentation links below, (single-file PDF with more feature discussion coming soon).

Quick Overview:
* **Nesting of widgets** (visual and true object-hierarchical); rather like Delphi panels and controls.
* **Base Widget implements borders, positioning, sizing, and alignment** (relative to other Widget parts, parent/container-widgets, or browser-window bounds).
* **Borders Sub-Components** include margin, outer, frame, inner, and padding (from outermost to innermost).
* **Movable/Sizable** (including sizing, moving, and position rules/constraints); **alignment preserved during move/size operations where it makes sense.**
* **Multi-Select** (for Moves) &mdash; depress SHIFT key while left-clicking.
* **CSS used to Style parts**, including pre-defined border-styles (raised, grooved, flat, etc).
Effects via SVG-Filters are possible.)
* **Application** object exists to manage widget interactions and enable true software application (ultimately).


## Documentation ##
* Source Code is commented in some detail
* Should be here soon: [Single-File PDF Intro, Discussion, etc.](.)
* [API Reference (aka dartdocs)] (http://mv4t.com/dart-squid/docs/dart_squid.html)
* [Wiki Documentation](https://github.com/IntersoftDev/dart-squid/wiki/_pages)


## License
MIT License (for freeware). See LICENSE file for project licensing information.

## Contact

Mike

Blog: http://suretalent.blogspot.com