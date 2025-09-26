include <KnurledFinishLib.scad>
include <ThreadLib.scad>

// *******************
// *** Usage Tests ***
// *******************

//make_buttressed_tube();
//make_corrugated_tube(tube_id=30, tube_od=40, corrugation_radius=3, nbr_corregations=25, height=50);
//make_corrugated_cylinder(tube_od=40,corrugation_radius=3, nbr_corregations=25, height=50);
//height,d,corrugation_radius,nbr_corregations,fn

//createThreadPair(diameter,height,thread_height,engine_diameter);
//createThreadPair(20,20,20,18);

// ***************
// *** Helpers ***
// ***************

module t_x (x) { translate([x,0,0]) children(); }
module t_y (y) { translate([0,y,0]) children(); }
module t_z (z) { translate([0,0,z]) children(); }

// Translate/Rotate Combo
module tr(t=[0,0,0],r=[0,0,0]){ translate(t) rotate(r) children(); }

// **************
// *** Colors ***
// **************

function get_color(color) =
    [for (pair = color_map) if (pair[0] == color) pair[1]][0];
    
color_map = [
    ["red",       [1, 0, 0]],
    ["green",     [0, 1, 0]],
    ["blue",      [0, 0, 1]],
    ["cyan",      [0, 1, 1]],
    ["magenta",   [1, 0, 1]],
    ["yellow",    [1, 1, 0]],
    ["black",     [0, 0, 0]],
    ["white",     [1, 1, 1]],
    ["gray",      [0.5, 0.5, 0.5]],
    ["grey",      [0.5, 0.5, 0.5]], // alias
    ["orange",    [1, 0.65, 0]],
    ["pink",      [1, 0.75, 0.8]],
    ["brown",     [0.65, 0.16, 0.16]],
    ["purple",    [0.5, 0, 0.5]],
    ["lime",      [0.75, 1, 0]],
    ["navy",      [0, 0, 0.5]],
    ["teal",      [0, 0.5, 0.5]],
    ["olive",     [0.5, 0.5, 0]],
    ["maroon",    [0.5, 0, 0]],
    ["silver",    [0.75, 0.75, 0.75]],
    ["aqua",      [0, 1, 1]],   // alias for cyan
    ["fuchsia",   [1, 0, 1]]    // alias for magenta
];

// ********************
// *** Compensation ***
// ********************

function hole_comp(diameter,fn) = diameter / cos(PI/fn);

// *************
// *** Tubes ***
// *************

// Function by Grok AI - Good Job !!
module make_corrugated_tube(tube_id, tube_od, corrugation_radius, nbr_corregations, height, fn=75) {
  inner_radius = tube_id / 2;

  difference() {
    make_corrugated_cylinder(tube_od,height,corrugation_radius,nbr_corregations,fn);
    // Core out inner dimension to create a smooth bore.  
    translate([0,0,-.1]) cylinder(h=height+1, r=inner_radius, $fn=fn);
  }
}

module make_tube(inner,outer,height){
    assert(outer > inner,"PezLib::make_tube() - Outer must be greater than inner");
    assert(height > 0,"PezLib::make_tube() - Height must be greater than 0");
    
    difference(){
      cylinder(h=height, d=outer);
      translate([0,0,-.5])
        cylinder(h=height+1, d=inner);
    }
}

module fillet_tube(height,inner_r,bottom_r,top_r,chamfer_size){
   bottom = [
      [inner_r, 0],
      [bottom_r - chamfer_size, 0],
      [bottom_r, chamfer_size],
      [top_r, height],
      [inner_r, height]
   ];

   top = [[inner_r, 0],
          [bottom_r, 0],
          [top_r, height - chamfer_size],
          [top_r - chamfer_size, height],
          [inner_r, height]];
             
   rotate_extrude(angle=360) polygon(points=top);
    
}

// *****************
// *** Cylinders ***
// *****************

module make_corrugated_cylinder(tube_od,height,corrugation_radius,nbr_corregations,fn=50){
  peak_radius  = tube_od / 2;
  d            = peak_radius - corrugation_radius;

  for (i = [0:nbr_corregations-1]) {
    rotate([0, 0, i * 360 / nbr_corregations])
      translate([d, 0, 0])
        cylinder(h=height, r=corrugation_radius, $fn=fn);
  }
  filler_radius = tube_od/2 - corrugation_radius;
  cylinder(h=height,r=filler_radius,$fn=fn);
}

// By Grok AI
module make_chamfered_cylinder(height, bottom_od, top_od, chamfer_size, position="both") {
    bottom_r = bottom_od / 2;
    top_r = top_od / 2;
    rotate_extrude(angle=360) {
        if (position == "bottom") {
            polygon(points=[
                [0, 0],
                [bottom_r - chamfer_size, 0],
                [bottom_r, chamfer_size],
                [top_r, height],
                [0, height]
            ]);
        } else if (position == "top") {
            polygon(points=[
                [0, 0],
                [bottom_r, 0],
                [top_r, height - chamfer_size],
                [top_r - chamfer_size, height],
                [0, height]
            ]);
        } else { // both
            polygon(points=[
                [0, 0],
                [bottom_r - chamfer_size, 0],
                [bottom_r, chamfer_size],
                [top_r, height - chamfer_size],
                [top_r - chamfer_size, height],
                [0, height]
            ]);
        }
    }
}

// By Grok AI
module make_filleted_cylinder(height, bottom_od, top_od, fillet_radius, position="both") {
    bottom_r = bottom_od / 2;
    top_r = top_od / 2;
    rotate_extrude(angle=360) {
        if (position == "bottom") {
            union() {
                square([bottom_r - fillet_radius, fillet_radius]);
                translate([bottom_r - fillet_radius, fillet_radius]) circle(r=fillet_radius);
                polygon(points=[
                    [0, fillet_radius],
                    [bottom_r, fillet_radius],
                    [top_r, height],
                    [0, height]
                ]);
            }
        } else if (position == "top") {
            union() {
                polygon(points=[
                    [0, 0],
                    [bottom_r, 0],
                    [top_r, height - fillet_radius],
                    [0, height - fillet_radius]
                ]);
                translate([0, height - fillet_radius]) square([top_r - fillet_radius, fillet_radius]);
                translate([top_r - fillet_radius, height - fillet_radius]) circle(r=fillet_radius);
            }
        } else { // both
            union() {
                square([bottom_r - fillet_radius, fillet_radius]);
                translate([bottom_r - fillet_radius, fillet_radius]) circle(r=fillet_radius);
                polygon(points=[
                    [0, fillet_radius],
                    [bottom_r, fillet_radius],
                    [top_r, height - fillet_radius],
                    [0, height - fillet_radius]
                ]);
                translate([0, height - fillet_radius]) square([top_r - fillet_radius, fillet_radius]);
                translate([top_r - fillet_radius, height - fillet_radius]) circle(r=fillet_radius);
            }
        }
    }
}

module make_top_chamfered_tube(inner,outer,height){
    difference(){
      union(){  
        translate([0,0,height-3]) cylinder(h=3,d1=outer,d2=inner); 
        cylinder(h=height-3, d=outer);
      }
      translate([0,0,-.5])
        cylinder(h=height+1, d=inner);
    }
}

module make_inner_tapered_tube(id,od,taper_height,taper_od){
    difference(){
       cylinder(h=taper_height,d=od);
       // Core out a cone to create the inner taper, which slants upwards.
       translate([0,0,-.1]) cylinder(h=taper_height+1,d1=taper_od,d2=id);
    }
}

// ***************
// *** Lattice ***
// ***************

// By GROK - Great Job !! (just one minor tweek, then it was perfect)
// OpenSCAD module for a lattice tower with square cross-section, divided into multiple sections
// Parameters:
// - length: total height of the tower (mm)
// - width: side length of the square cross-section (mm)
// - od_frame: outer diameter of the four corner frame members (mm)
// - od_truss: outer diameter of the diagonal truss members (mm)
// - nbr_sections: number of sections to divide the tower height into
// The tower has four vertical corner legs and X-bracing (forming triangles) on each face per section.

// Helper module to create a cylinder along a vector between two points
module cylinder_along_vector(p1, p2, d) {
    dx = p2[0] - p1[0];
    dy = p2[1] - p1[1];
    dz = p2[2] - p1[2];
    len = sqrt(dx*dx + dy*dy + dz*dz);
    if (len > 0.001) {
        hyp = sqrt(dx*dx + dy*dy);
        yaw = atan2(dy, dx);
        elev = (hyp > 0.001) ? atan2(dz, hyp) : 90;
        pitch = 90 - elev;
        midx = p1[0] + dx / 2;
        midy = p1[1] + dy / 2;
        midz = p1[2] + dz / 2;
        translate([midx, midy, midz])
        rotate([0, pitch, yaw])
        cylinder(h = len, d = d, center = true, $fn = 24);
    }
}

// Module for a single section of the lattice tower
module lattice_tower_section(section_length, width, od_frame, od_truss, z_offset) {
    // Four corner legs (vertical for this section)
    corners = [[0, 0], [width, 0], [width, width], [0, width]];
    for (c = corners) {
        cylinder_along_vector([c[0], c[1], z_offset], [c[0], c[1], z_offset + section_length], od_frame);
    }
    
    // Diagonal trusses (X-bracing on each face, forming triangles)
    // Face 1: front (y = 0)
    cylinder_along_vector([0, 0, z_offset], [width, 0, z_offset + section_length], od_truss);
    cylinder_along_vector([width, 0, z_offset], [0, 0, z_offset + section_length], od_truss);
    
    // Face 2: right (x = width)
    cylinder_along_vector([width, 0, z_offset], [width, width, z_offset + section_length], od_truss);
    cylinder_along_vector([width, width, z_offset], [width, 0, z_offset + section_length], od_truss);
    
    // Face 3: back (y = width)
    cylinder_along_vector([width, width, z_offset], [0, width, z_offset + section_length], od_truss);
    cylinder_along_vector([0, width, z_offset], [width, width, z_offset + section_length], od_truss);
    
    // Face 4: left (x = 0)
    cylinder_along_vector([0, width, z_offset], [0, 0, z_offset + section_length], od_truss);
    cylinder_along_vector([0, 0, z_offset], [0, width, z_offset + section_length], od_truss);
}

// Main module for the lattice tower with multiple sections
module lattice_tower(length, width, od_frame, od_truss, nbr_sections) {
    section_length = length / nbr_sections; // Calculate length of each section
    for (i = [0 : nbr_sections - 1]) {
            lattice_tower_section(section_length, width, od_frame, od_truss, i * section_length);
    }
}

// Example usage (uncomment to render a sample tower)
//lattice_tower(2000, 300, 20, 10, 10);

// ****************
// *** Parabola ***
// ****************

//////////////////////////////////////////////////////////////////////////////////////////////
// Paraboloid module for OpenScad
//
// Copyright (C) 2013  Lochner, Juergen
// http://www.thingiverse.com/Ablapo/designs
//
// This program is free software. It is 
// licensed under the Attribution - Creative Commons license.
// http://creativecommons.org/licenses/by/3.0/
//
// TIO PEZ - Took out $fn argument as will be using global version to control all level of detail
//////////////////////////////////////////////////////////////////////////////////////////////

module make_paraboloid (y=10, f=5, rfa=0, fc=1){
	// y = height of paraboloid
	// f = focus distance 
	// fc : 1 = center paraboloid in focus point(x=0, y=f); 0 = center paraboloid on top (x=0, y=0)
	// rfa = radius of the focus area : 0 = point focus

	hi = (y+2*f)/sqrt(2); // height and radius of the cone -> alpha = 45° -> sin(45°)=1/sqrt(2)
	x =2*f*sqrt(y/f); // x  = half size of parabola
	
   translate([0,0,-f*fc])	       // center on focus 
	rotate_extrude(convexity = 10) // extrude paraboild
	translate([rfa,0,0])		   // translate for focus area	 
	difference(){
		union(){ // adding square for focal area
			projection(cut = true)	// reduce from 3D cone to 2D parabola
				translate([0,0,f*2]) rotate([45,0,0])	// rotate cone 45° and translate for cutting
				translate([0,0,-hi/2])cylinder(h= hi, r1=hi, r2=0, center=true); // center cone on tip
			translate([-(rfa+x ),0]) square ([rfa+x , y ]);	// focal area square
		}
		translate([-(2*rfa+x ), -1/2]) square ([rfa+x ,y +1] ); // cut of half at rotation center 
	}
}


// By Grok - Great Job !!
// OpenSCAD script to create a to-scale model of the Voyager spacecraft's parabolic high-gain antenna dish
// Dimensions in mm (1:1 scale)
// Diameter: 3.66 m = 3660 mm
// Focal length: 123.51 cm = 1235.1 mm (best fit parabola)
// Approximate thickness: 20 mm (arbitrary for modeling purposes, as actual thickness not specified)
module make_parabolic_dish(radius=18.3,focal_length=12.35,num_segments=100,thickness=2){

f = focal_length;
r = radius;
h = pow(r, 2) / (4 * f); // depth of the dish

// Generate front surface points (concave side)
front_points = [
    for (i = [0 : num_segments])
        let (
            x = (i / num_segments) * r,
            y = pow(x, 2) / (4 * f)
        )
        [x, y]
];

// Generate back surface points (offset by thickness along normal)
back_points = [
    for (i = [0 : num_segments])
        let (
            x = (i / num_segments) * r,
            y = pow(x, 2) / (4 * f),
            dydx = x / (2 * f),
            len = sqrt(1 + pow(dydx, 2)),
            offset_x = (dydx / len) * thickness,
            offset_y = (-1 / len) * thickness
        )
        [x + offset_x, y + offset_y]
];

// Combine points for the polygon: front then reverse back
poly_points = concat(
    front_points,
    [ for (i = [num_segments : -1 : 0]) back_points[i] ]
);

// Create the dish using rotate_extrude
translate([0, 0, -thickness]) // Shift to make bottom at z=0
rotate_extrude(angle = 360, $fn = 200)
    polygon(points = poly_points);
 }
// ********************
// *** Basic Shapes ***
// ********************

module make_horizontal_torus(inner_od, outer_od, $fn=50, center=true) {
    // Derived values
    tube_diameter = (outer_od - inner_od) / 2;
    r = tube_diameter / 2;            // minor radius (tube radius)
    R = (outer_od + inner_od) / 4;    // major radius (centerline distance)

    // Safety check
    assert(outer_od > inner_od, "outer_od must be larger than inner_od");

    // Build torus
    translate([0,0, center ? -r : 0]) 
        rotate_extrude(angle=360, $fn=$fn)
            translate([R,0,0])
                circle(r=r, $fn=$fn);
}

module make_hollow_cone(od_top,od_bottom,height,thickness){
    difference(){
      cylinder(h=height, d2=od_top,d1=od_bottom);
      translate([0,0,-.5]) cylinder(h=height+1, d2=od_top-thickness,d1=od_bottom-thickness);;
    }
}


module make_box(width,depth,height,thickness){

    translate([0,0,height/2])
            difference(){
                cube( [width+thickness,depth+thickness,height],center=true);
                translate([0,0,thickness])
                    cube( [width,depth,height],center=true);
            }
}

// ************************
// *** Buttrussed Items ***
// ************************

module make_buttressed_tube(tube_id=10,tube_od=30,tube_height=3,buttress_height=5,num_buttress=10){
    translate([0,0,buttress_height]) make_tube(tube_id,tube_od,tube_height);
    buttress_width = (tube_od-tube_id)/2;
 
   angle_incr = 360/num_buttress;
    for(angle=[0:angle_incr:(num_buttress-1)*angle_incr]){    
            rotate(a=angle,v=[0,0,1])    
                translate([tube_id/2,0,0]) make_buttress(buttress_height,buttress_width);
    }
    
}

module make_buttress(height=10,width=10,thickness=2){
    translate([0,thickness/2,0]){
    rotate(a=90,v=[1,0,0])
    linear_extrude(thickness)
    polygon([[0,height],[width,height],[width,0],[0,height]]);
 }

}

// ***************
// *** Spheres ***
// ***************

module make_hollow_hemisphere(width,thickness,top=true){
    difference(){
        make_hollow_sphere(width,thickness);
        if(top == false)
            translate([0,0,width/2]) cube(width,center=true);
        else
            translate([0,0,-width/2]) cube(width,center=true);
    }
}

module make_hemisphere(width,top=true){
    difference(){
        sphere(d=width);
        if(top == false)
            translate([0,0,width/2]) cube(width,center=true);
        else
            translate([0,0,-width/2]) cube(width,center=true);
    }
}

module make_hollow_sphere(width,thickness){
    difference(){
        sphere(d=width);
        sphere(d=width-thickness*2);
    }
}

// ************************
// *** Hulls - for slotting
// ************************

module make_rounded_vertical_hull(offset,height,diameter){
   hull(){
      translate([0,50,offset]) rotate([90,0,0]) cylinder(h=100,d=diameter);
      translate([0,50,height]) rotate([90,0,0]) cylinder(h=100,d=diameter);
      }
}

// ************************
// *** Composite Shapes ***
// ************************

module make_nested_tubes(inner,outer,parent_inner,parent_outer,height,
    fin_thickness,bottom_thickness=0,top_thickness=0){

    make_tube(inner,outer,height);
    make_tube(parent_inner,parent_outer,height);
    
    if(bottom_thickness > 0)
        make_tube(inner,parent_outer,bottom_thickness);

    if(top_thickness > 0)
            translate([0,0,height-top_thickness])
                make_tube(inner,parent_outer,top_thickness);
        
    make_square_fins(3,outer,(parent_inner/2-outer/2)+.2,height,fin_thickness);    
}
// ***********************
// *** Rounded Items ***
// ***********************

module make_radial_holes(number_holes, hole_center_radius,hole_radius,hole_depth) {
    for (i = [0:number_holes-1]) {
        angle = 360/number_holes * i;
        translate([
            hole_center_radius * cos(angle),
            hole_center_radius * sin(angle),
            0
        ])
        translate([0,0,-.1]) cylinder(r=hole_radius, h=hole_depth+.2, center=false);
    }
}



module puck_with_chamfered_top(width_x,width_y,thickness,radius){
    $fn=50;

    offset_x    = (width_x/2) - radius;  
    offset_y    = (width_y/2) - radius;  
    
    hull(){
        translate([offset_x,offset_y,thickness])   sphere(radius);
        translate([offset_x,offset_y,radius])      sphere(radius);
    
        translate([-offset_x,offset_y,thickness])  sphere(radius);
        translate([-offset_x,offset_y,radius])     sphere(radius);
    
        translate([offset_x,-offset_y,thickness])  sphere(radius);
        translate([offset_x,-offset_y,radius])     sphere(radius);

        translate([-offset_x,-offset_y,thickness]) sphere(radius);
        translate([-offset_x,-offset_y,radius])    sphere(radius);
    }

}

// *****************************
// *** Knurled Threaded caps ***
// *****************************

module createThreadPair(diameter=20,height=5,thread_height=1,engine_diameter=18){
    threaded_body(diameter,height,thread_height,diameter-5);
    endCap(diameter,height,thread_height,diameter,engine_diameter);
}

module threaded_body(diameter,height,thread_height,thread_diameter){
    // RodEnd(diameter, height, thread_len=0, thread_diam=0, thread_pitch=0)

  translate([0, 50, 0])
    RodEnd(diameter,height,thread_height,thread_diameter);
}

module endCap(diameter,height,thread_height,thread_diameter,engine_diameter){

// RodStart(diameter, height, thread_len=0, thread_diam=0, thread_pitch=0)
echo(EngineDiameter=engine_diameter,ThreadDiameter=thread_diameter);
    
    difference(){
        union(){
            //knurledCylinder(10,diameter);
            cylinder(d=diameter+5,h=10);
            RodStart(0,diameter,height-3 ,thread_diameter);
        }

        translate([0,0,-1])
            cylinder(3,d=engine_diameter-3);

        translate([0,0,1.9])
           cylinder(height,d=engine_diameter+.1);
    }
}


module knurledCylinder(height,od){

    knurl_wd=3;      // Knurl polyhedron width
    knurl_hg=4;      // Knurl polyhedron height
    knurl_dp=1.5;    // Knurl polyhedron depth

    e_smooth=2;      // Cylinder ends smoothed height
    s_smooth=25;      // [ 0% - 100% ] Knurled surface smoothing amount

    knurled_cyl(height,od,knurl_wd, knurl_hg, knurl_dp,e_smooth, s_smooth);

}

// ***************
// *** Spirals ***
// ***************

module make_spiraled_tube(num_flutes,id,od,height,id_plate){
    width = (od-id)/2;
    plate_thickness = 2;
    angle_incr = 360/num_flutes;
    
    linear_extrude(height = height, convexity = 10, twist = 100)
        union(){
            
        for(angle=[0:angle_incr:(num_flutes-1)*angle_incr])
           rotate(a=angle,v=[0,0,1])    
                translate([id/2,0,0])
                    square([width-.15,2]);
        }
    // Plates that joins the spirals at top, bottom, and middle
                                            make_tube(id_plate,od,plate_thickness);
    translate([0,0,height/2])               make_tube(id_plate,od,plate_thickness);
    translate([0,0,height-plate_thickness]) make_tube(id+2,od,plate_thickness);
}

    