include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>

function fixture_name(type) = type[0];
function fixture_depth(type) = type[1];
function fixture_width(type) = type[2];
function fixture_len1(type) = type[3];
function fixture_len2(type) = type[4];
function fixture_heigth_middle(type) = type[5];
function fixture_heigth(type) = type[6];
function fixture_thickness(type) = type[7];


module dlp_printer_fixture(type) {
    stl(str("dlp_printer_fixture_", fixture_name(type)));

    H = fixture_heigth(type);
    Hm = fixture_heigth_middle(type);
    Di = fixture_depth(type);
    Do = fixture_depth(type) + fixture_thickness(type)*2;
    Wi = fixture_width(type);
    Wo = fixture_width(type) + fixture_thickness(type)*2;

    difference() {
        rounded_rectangle([Wo, Do, H], 2);
        rounded_rectangle([Wi, Di, H*2], 0.1);
    }
    mount_width = fixture_len1(type);
    mount_depth = Di - fixture_len2(type)*2;

    module mount() {
        translate([Wi / 2 + mount_width / 2, 0])
            rounded_rectangle([mount_width, mount_depth, Hm], 2);
    }

    mount();
    mirror([1,0,0])
    mount();
}
