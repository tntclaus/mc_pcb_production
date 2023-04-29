include <NopSCADlib/utils/core/core.scad>
include <NopSCADlib/utils/rounded_polygon.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>
include <NopSCADlib/vitamins/screws.scad>

function cnc_pcb_fixture_name(type) = type[0];
function cnc_pcb_fixture_width(type) = type[1];
function cnc_pcb_fixture_depth(type) = type[2];
function cnc_pcb_fixture_heigth(type) = type[3];
function cnc_pcb_fixture_inner_step(type) = type[4];
function cnc_pcb_fixture_inner_wall(type) = type[5];

module cnc_pcb_fixture_place_cross_corner(type) {
    step = cnc_pcb_fixture_inner_step(type);
    wall = cnc_pcb_fixture_inner_wall(type);

    cnc_pcb_fixture_place_cross(type, last_line = true)
    translate([- (step / 2 + wall / 2), - (step / 2 + wall / 2), 0])
        children();
}

module cnc_pcb_fixture_place_cross(type, last_line = false) {
    width = cnc_pcb_fixture_width(type);
    depth = cnc_pcb_fixture_depth(type);
    heigth = cnc_pcb_fixture_heigth(type);
    step = cnc_pcb_fixture_inner_step(type);
    wall = cnc_pcb_fixture_inner_wall(type);

    if (last_line) {
        for (x = [- width / 2 + step / 2 : step + wall : width / 2 + step / 2])
        for (y = [- depth / 2 + step / 2 : step + wall : depth / 2 + step / 2])
        translate([x + wall, y + wall, 0])
            children();
    } else {
        for (x = [- width / 2 + step / 2 : step + wall : width / 2 - step / 2])
        for (y = [- depth / 2 + step / 2 : step + wall : depth / 2 - step / 2])
        translate([x + wall, y + wall, 0])
            children();
    }
}

module cnc_pcb_fixture_assembly(type, stl = false) {
    stl(
        str("cnc_pcb_fixture_assembly_",
        cnc_pcb_fixture_name(type))
    );

    heigth = cnc_pcb_fixture_heigth(type);
    width = cnc_pcb_fixture_width(type);

    if (stl) {
        //        translate([-width,0,0])
        cnc_pcb_fixture_mounts(type);
    } else {
        translate_z(heigth+2)
        color("red")
        cnc_pcb_fixture_mounts(type);
    }

    cnc_pcb_fixture(type);
}

module cnc_pcb_fixture_mounts(type) {
    step = cnc_pcb_fixture_inner_step(type);
    wall = cnc_pcb_fixture_inner_wall(type);
    width = cnc_pcb_fixture_width(type);

    shift = step + wall;

    module fixture_mount(l = step / 2) {
        difference() {
            union() {
                translate([- wall / 2, 0, 0])
                    rounded_cube_xy([wall, l, 5], r = 1);
                cylinder(d = 10, h = 5);
            }
            poly_cylinder(r = 3 / 2, h = 100, center = true);
        }
    }


    module fixture_mount_set() {
        fixture_mount();
        translate([wall*2+1,step/3,0])
            rotate([0,0,180])
                fixture_mount(step/3);
        translate([wall*4+2,0,0])
            fixture_mount(step*2/3);
    }

    translate([- width / 2 + step / 2, - step / 2 + 6, 0]) {
        fixture_mount_set();
        translate([shift, 0, 0])
            fixture_mount_set();
        translate([shift * 2, 0, 0]) {
            fixture_mount_set();
        }
        translate([shift * 3, 0, 0])
            fixture_mount_set();
    }
}

module cnc_pcb_fixture(type) {
    name = cnc_pcb_fixture_name(type);
    width = cnc_pcb_fixture_width(type);
    depth = cnc_pcb_fixture_depth(type);
    heigth = cnc_pcb_fixture_heigth(type);
    step = cnc_pcb_fixture_inner_step(type);
    wall = cnc_pcb_fixture_inner_wall(type);

    difference() {
        union() {
            translate([-width/2+step/2,-depth/2+wall/2,heigth])
                rounded_cube_xy([step*2/3, wall, heigth/2], r = 1, xy_center = true);

            translate([-width/2+wall/2,-depth/2+step/2,heigth])
                rounded_cube_xy([wall, step*2/3, heigth/2], r = 1, xy_center = true);

            rounded_cube_xy([width, depth, heigth], r = 5, xy_center = true);
            rounded_cube_xy([width + 20, depth, 3], r = 5, xy_center = true);

            cnc_pcb_fixture_place_cross_corner(type) {
                cylinder(d = 8, h = heigth);
            }
        }
        cnc_pcb_fixture_place_cross(type) {
            rounded_cube_xy([step, step, heigth * 3], r = 5, xy_center = true, z_center = true);
        }
        cnc_pcb_fixture_place_cross_corner(type) {
            nut_trap(M3_cs_cap_screw, M3_nut, depth = heigth / 2);
        }
    }
    // тонкая мембрана чтобы слайсер юзал печать с использованием мостика
    cnc_pcb_fixture_place_cross_corner(type) {
        // мембрана
        translate_z(heigth / 2)
        cylinder(d = 4, h = .2);

        //утолщени для установки гаек
        difference() {
            cylinder(d = 10, h = heigth / 2 + .4);
            cylinder(d = 7, h = 100, center = true);
        }
    }
    //площадка для самореза
    cnc_pcb_fixture_place_cross(type)
    translate([- (step / 2 + wall / 2), - (step / 2 + wall / 2), 0])
        difference() {
            rounded_cube_xy([12, 12, 3], r = 4);
            cylinder(d = 7, h = 100, center = true);
            translate([7, 7, 0])
                poly_cylinder(r = 3 / 2, h = 100, center = true);
        }
}
