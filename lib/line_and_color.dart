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
Lower-level classes representing lines, colors, and perhaps other such things over time.
███████████████████████████████████████████████████████████████████████████████████████████
*/

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Simplify and standardize storage of line information Line begin/end (X,Y) pairs
* (i.e., start/end points). Essentially just a struct at this time, but that could
* change in the future.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Line {
    num x1  = 0.0;
    num y1  = 0.0;
    num x2  = 0.0;
    num y2  = 0.0;

    Line.zeros();
    Line(this.x1, this.y1, this.x2, this.y2);
}




//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
/**
* Simplify and standardize storage of RGB Color information used throughout framework.
* Chose to omit "setters" (and valid range testing) to lighten up the objects slightly.
*/
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Color {
    int R   = 0;
    int G   = 0;
    int B   = 0;

    static const int MIN_VALUE = 0;
    static const int MAX_VALUE = 255;

    ///Returns [true] if all color channel values (R/G/B) are zero valued, else [false].
    bool isBlack() {
        return (((R == MIN_VALUE) && (G == MIN_VALUE) && (B == MIN_VALUE)) ? true : false);
    }

    ///Returns [true] if all color channel values (R/G/B) are "max" valued (i.e., int 255), else [false].
    bool isWhite() {
        return ((R == MAX_VALUE) && (G == MAX_VALUE) && (B == MAX_VALUE));
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Adjust the [R],[G],[B] color stored herein by the amount of "shifting" (per color channel) as
    * specified in [shiftColorByInt] parameter, which defaults to a reasonable visual diff.
    *
    * Pass a negative value to make a color "darker" and a positive one for "lighter"
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void shiftColor([int shiftColorByInt=24]) {
        if (shiftColorByInt > 0) {lightenColor(shiftColorByInt);} else {darkenColor(-shiftColorByInt);}
    }

    void lightenColor([int shiftColorByInt=24]) {
        int GetShiftedSubColor(int channelValue) {
            return min(MAX_VALUE, (channelValue + shiftColorByInt));
        }

        R = GetShiftedSubColor(R);
        G = GetShiftedSubColor(G);
        B = GetShiftedSubColor(B);
    }

    void darkenColor([int shiftColorByInt=24]) {
        int GetShiftedSubColor(int channelValue) {
            return max(MIN_VALUE, (channelValue - shiftColorByInt));
        }

        R = GetShiftedSubColor(R);
        G = GetShiftedSubColor(G);
        B = GetShiftedSubColor(B);
    }



    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    /**
    * Our off-page CSS style calculations will return colors (in Chrome/Dartium) in the
    * form: "rgb(255, 255, 255)".
    * Parse that String and load our Color object [R],[G],[B] values from it.
    */
    //▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
    void loadFromRGBString(String RGBString) {
        if (!(RGBString.startsWith('rgb(')) ) return;

        List<String>    colorsSplit    = null;

        //whip string into a tight list of comma-delim values only; e.g.:255,255,255
        RGBString = RGBString.replaceFirst('rgb(', '');
        RGBString = RGBString.replaceAll(')', '');
        RGBString = RGBString.replaceAll(' ', '');

        colorsSplit= RGBString.split(',');
        R = int.parse(colorsSplit[0]);
        G = int.parse(colorsSplit[1]);
        B = int.parse(colorsSplit[2]);
    }


    //return in the same approx format that the browser uses
    String formattedRGBString() {
        return 'rgb(${R.toString()}, ${G.toString()}, ${B.toString()})';
    }


    /*
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    CONSTRUCTORS
    ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
    */
    Color.empty();
    Color.fromIntRGB(this.R, this.G, this.B);
    Color.fromBrowserRBGString(String RGBString) {loadFromRGBString(RGBString);}

} //Color
