// Number of 'sides' in circles
// Amount of detail

$fn=50;

create_drone_skid(20,20,3.5,1,0);

// *********************
// Primatives drawing
// *********************

module create_prop_guard(){
    $height = 3;
    $hole_r = 8;

    ring($height,100,5);
    create_spokes(5,50,$height,15,3);
    create_round_plate_with_radial_holes($height,30,4,3,$hole_r);
}

module create_drone_skid(diameter,height,hole_d,num_holes,hole_radius){

    $angle_incr = 360/num_holes;
    $radius = diameter/2;


    difference(){
        union(){
            translate([0,0,height-$radius])
                sphere(d=diameter);
            cylinder(d=diameter,h=height-$radius);
        }
        for(angle=[0:$angle_incr:(num_holes-1)*$angle_incr]){
            rotate(a=angle,v=[0,0,1])
                translate([0,hole_radius,0]){    
                    translate([0,0,-1])
                        cylinder(h=height+10,d=hole_d);
                    translate([0,0,height-3])
                        cylinder(h=10,d=hole_d+3);
                }
        }
    }
}

module ring(height,diameter,thickness){
    
    difference(){
        cylinder(h=height,d=diameter);
        translate([0,0,-.5])
            cylinder(h=height+1,d=diameter-thickness);
    }
}

module create_spokes(num_spokes,width,height,center_offset,thickness){

    $angle_incr = 360/num_spokes;
    for(angle=[0:$angle_incr:(num_spokes-1)*$angle_incr]){    
    
        rotate(a=angle,v=[0,0,1])
            translate([-(thickness/2),center_offset,0])
                cube(size=[thickness,width-center_offset,height]);
            
    }
}

module create_round_plate_with_radial_holes(height,diameter,num_holes,hole_diameter,hole_offset){

    $angle_incr = 360/num_holes;
    
    difference(){
        cylinder(h=height,d=diameter);
    
        for(angle=[0:$angle_incr:(num_holes-1)*$angle_incr]){    
            rotate(a=angle,v=[0,0,1])
                translate([0,hole_offset,-1])
                    cylinder(h=10,d=hole_diameter); 
        }
    }
}
