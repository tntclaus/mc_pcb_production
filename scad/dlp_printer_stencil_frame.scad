//use <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/vitamins/nuts.scad>

use <dlp_printer_fixture.scad>

module dlp_printer_stencil_frame(type) {

}

function place_holes(a,b) = [for(i = [-a : b : a]) i];

function H(type) = fixture_heigth(type)*3;
function Di(type) = fixture_depth(type) + fixture_thickness(type)*3;
function Do(type) = fixture_depth(type) + fixture_thickness(type)*5;
function Wi(type) = fixture_width(type) + fixture_thickness(type)*3;
function Wo(type) = fixture_width(type) + fixture_thickness(type)*5;

module make_holes(type, with_nuts = true) {
    frame_cap_H = H(type)/2;

    for(y = [1, -1])
    translate([0, y*(Wo(type)-fixture_thickness(type))/2, 0])
        for(x = place_holes((Do(type)-fixture_thickness(type)*3)/2,33.6))
        translate([x,0,0]) {
            cylinder(d = 3.5, h = 50, center = true, $fn = 90);

            if(with_nuts) {
                translate_z(frame_cap_H - 3)
                cylinder(r = nut_radius(M3_nut), h = H(type), $fn = 6);

            } else {
                translate_z(frame_cap_H - 3)
                cylinder(d = 7, h = H(type), $fn = 90);
            }
        }


    for(y = [1, -1])
    translate([y*(Do(type)-fixture_thickness(type))/2, 0, 0])
        for(x = place_holes((Wo(type)-fixture_thickness(type)*3)/2,38.1))
        translate([0,x,0]) {
            cylinder(d = 3.5, h = 50, center = true, $fn=90);

            if(with_nuts){
                translate_z(frame_cap_H - 3)
                cylinder(r = nut_radius(M3_nut), h = H(type), $fn = 6);
            } else {
                translate_z(frame_cap_H - 3)
                cylinder(d = 7, h = H(type), $fn = 90);
            }
        }
}

module dlp_printer_stencil_frame_bottom(type) {
    frame_cap_H = H(type)/2;
    difference() {
        rounded_rectangle([Do(type), Wo(type), H(type)-frame_cap_H], 3);
        rounded_rectangle([Di(type), Wi(type), H(type)*2], 2);

        make_holes(type = type);
    }

    difference() {
        rounded_rectangle([Di(type)-.5, Wi(type)-.5, H(type)], 2.5);
        rounded_rectangle([Di(type)-fixture_thickness(type), Wi(type)-fixture_thickness(type), H(type)*2], 2);
    }
}
module dlp_printer_stencil_frame_top(type) {

    frame_cap_H = H(type)/2;

    difference() {
        rounded_rectangle([Do(type), Wo(type), H(type)-frame_cap_H], 3);
        rounded_rectangle([Di(type), Wi(type), H(type)*2], 2);

        make_holes(type = type, with_nuts = false);
    }
}

module dlp_printer_stencil_frame_base_assembly(type) {
    Do = Do(type)+20;
    Wo = Wo(type)+20;

    translate_z(10)
    dlp_printer_stencil_frame_base(type);

    for(x = [-1,1])
    for(y = [-1,1])
    translate([x*(Do-10)/2, y*(Wo-10)/2, 0])
        dlp_printer_stencil_frame_base_leg(type);
}
module dlp_printer_stencil_frame_base(type) {
    frame_cap_H = H(type)/2;

    H = 10;
    Do = Do(type)+20;
    Wo = Wo(type)+20;

    difference() {
        rounded_rectangle([Do, Wo, H], 3);

        translate_z(H-5){
            translate_z(3)
                rounded_rectangle([Do(type) + 1, Wo(type) + 1, H(type)], 2);

            rounded_rectangle([Di(type) + 1, Wi(type) + 1, H(type)], 2);
            rounded_rectangle([Do(type) + 1, Wi(type) + 1, H(type)], 2);
            rounded_rectangle([Di(type) + 1, Wo(type) + 1, H(type)], 2);

            translate_z(-H){
                rounded_rectangle([Di(type) + 1, 6, H * 2], 2);
                rounded_rectangle([6, Wi(type), H * 2], 2);
            }
        }

        for(x = [-1,1])
        for(y = [-1,1])
        translate([x*(Do-10)/2, y*(Wo-10)/2, 0])
            cylinder(d = 4, h = H*3, center = true);
    }


}

module dlp_printer_stencil_frame_base_leg(type) {
    rounded_rectangle([10, 10, 6], 3);
    cylinder(d = 3.8, h = 10);
}
