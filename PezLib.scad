include <KnurledFinishLib.scad>
include <ThreadLib.scad>

// *** Tests ***

//make_buttressed_tube();
//make_corrugated_tube(tube_id=18, tube_od=20, corrugation_radius=2, nbr_corregations=25, height=50);

// *************
// *** Tubes ***
// *************

// Function by Grok AI - Good Job !!
module make_corrugated_tube(tube_id, tube_od, corrugation_radius, nbr_corregations, height, fn=75) {
  inner_radius = tube_id / 2;
  peak_radius  = tube_od / 2;
  d            = peak_radius - corrugation_radius;

  difference() {
      for (i = [0:nbr_corregations-1]) {
        rotate([0, 0, i * 360 / nbr_corregations])
          translate([d, 0, 0])
            cylinder(h=height, r=corrugation_radius, $fn=fn);
      }
    // Core out inner dimension to create a smooth bore.  
    translate([0,0,-.1]) cylinder(h=height+1, r=inner_radius, $fn=fn);
  }
}

module make_tube(inner,outer,height){
    difference(){
      cylinder(h=height, d=outer);
      translate([0,0,-.5])
        cylinder(h=height+1, d=inner);
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
        if(top == true)
            translate([0,0,width/2]) cube(width,center=true);
        else
            translate([0,0,-width/2]) cube(width,center=true);
    }
}

module make_hollow_sphere(width,thickness){
    difference(){
        sphere(d=width);
        sphere(d=width-thickness);
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

module createThreadPair(diameter,height,thread_height,engine_diameter){
    threaded_body(diameter,height,thread_height,diameter-5);
    endCap(diameter,height,thread_height,diameter-5,engine_diameter);
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
            knurledCylinder(10,diameter);
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

    