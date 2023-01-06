//use <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/nuts.scad>

use <dlp_printer_fixture.scad>

module dlp_printer_stencil_frame(type) {

}

function place_holes(a,b) = [for(i = [-a : b : a]) i];


module dlp_printer_stencil_frame_top(type) {
    H = fixture_heigth(type)*3;
    Di = fixture_depth(type) + fixture_thickness(type)*3;
    Do = fixture_depth(type) + fixture_thickness(type)*5;
    Wi = fixture_width(type) + fixture_thickness(type)*3;
    Wo = fixture_width(type) + fixture_thickness(type)*5;

    frame_cap_H = H/2;

    module make_holes(with_nuts = true) {
        for(y = [1, -1])
        translate([0, y*(Wo-fixture_thickness(type))/2, 0])
            for(x = place_holes((Do-fixture_thickness(type)*3)/2,33.6))
            translate([x,0,0]) {
                cylinder(d = 3.5, h = 50, center = true, $fn = 90);

                if(with_nuts) {
                    translate_z(frame_cap_H - 3)
                    cylinder(r = nut_radius(M3_nut), h = H, $fn = 6);

                } else {
                    translate_z(frame_cap_H - 3)
                    cylinder(d = 7, h = H, $fn = 90);
                }
            }


        for(y = [1, -1])
        translate([y*(Do-fixture_thickness(type))/2, 0, 0])
            for(x = place_holes((Wo-fixture_thickness(type)*3)/2,38.1))
            translate([0,x,0]) {
                cylinder(d = 3.5, h = 50, center = true, $fn=90);

                if(with_nuts){
                    translate_z(frame_cap_H - 3)
                    cylinder(r = nut_radius(M3_nut), h = H, $fn = 6);
                } else {
                    translate_z(frame_cap_H - 3)
                    cylinder(d = 7, h = H, $fn = 90);
                }
            }
    }

//    difference() {
//        rounded_rectangle([Do, Wo, H-frame_cap_H], 3);
//        rounded_rectangle([Di, Wi, H*2], 2);
//
//        make_holes();
//    }
//
//    difference() {
//        rounded_rectangle([Di-.5, Wi-.5, H], 2.5);
//        rounded_rectangle([Di-fixture_thickness(type), Wi-fixture_thickness(type), H*2], 2);
//    }

//    translate([Do+2, 0, 0])
        difference() {
            rounded_rectangle([Do, Wo, H-frame_cap_H], 3);
            rounded_rectangle([Di, Wi, H*2], 2);

            make_holes(false);
        }
}
