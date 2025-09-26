include <ThreadLib.scad>
include <PezLib.scad>
include <Estes.scad>


// =============
// Test Cases
// =============

//$fn=50;

//make_stage(41.7,100,2,1);
//make_cored_tank(41.6,45,$BT_20_od,has_bulkhead=false);

// ****************
// *** Coupling ***
// ****************

module make_extended_lug(){
      rotate([0,0,-90]) make_launch_lug(TUBE_MAIN_OD+19,15,tapered=false,lug_id=LUG_ID);
      translate([0,28,5]) cube([3,9,10],center=true);
      rotate([0,0,90]) make_launch_lug(TUBE_MAIN_OD+19,15,tapered=false,lug_id=LUG_ID);
      translate([0,-28,5]) cube([3,9,10],center=true);    
}

module make_tube_coupler_zip(tube_od=50,size=40) {
    size = 40;
    x_offset = size/2 +6;

    difference(){ // core out for zip ties
        scale([1,1,1.5]) //stretch z so its more aerodynamic
        difference(){
           translate([0,0,size/2]) sphere(d=size);
           translate([x_offset,0,-.1]) cylinder(h=size+1,d=od);
           translate([-x_offset,0,-.1]) cylinder(h=size+1,d=od);
        } // end main object
        tr(t=[0,0,size/2*1.5],r=[90,0,0]) cylinder(h=80,d=6,center=true);
    } // end zip tie core
}

module make_tube_adapter(tube1_id,tube1_od,tube2_id,tube2_od,transition_height,shoulder_height,solid=true){
   
   thickness=2;
 
   difference(){
      union(){
         translate([0,0,transition_height]) cylinder(d=tube2_id,h=shoulder_height);
         cylinder(d1=tube1_od,d2=tube2_od,h=transition_height);
         translate([0,0,-shoulder_height]) cylinder(d=tube1_id,h=shoulder_height);
         }
   if(solid==false){
         translate([0,0,transition_height-.1]) cylinder(d=tube2_id-thickness,h=shoulder_height+1);
         //translate([0,0,-.1]) cylinder(d1=tube1_od-thickness,d2=tube2_od-thickness,h=transition_height+.2);
         translate([0,0,-shoulder_height-.1]) cylinder(d=tube1_id-thickness,h=shoulder_height+1);
      }   
   }
   
   // Make inner rings for added stregth to avoid shearing
   t_z(transition_height-1) #make_tube(tube2_id-5,tube2_id-2,3);
   t_z(-1) #make_tube(tube1_id-5,tube1_id-2,3);
}

module make_tube_coupler(height=10,id=47,od=50,has_lug=false){
   join_od = height;
   offset  = od/2 + 2.5;
      
   difference(){
       union(){
           make_chamfered_cylinder(height, od, od, chamfer_size=1, position="top");
           make_corrugated_cylinder(od+1,height=height-1,corrugation_radius=1,nbr_corregations=25);
           scale([1,1.5,1.6]) translate([offset,0,height/2-1]) sphere(d=join_od);
           scale([1,1.5,1.6]) translate([-offset,0,height/2-1]) sphere(d=join_od);
           }
       t_z(-.1) cylinder(d=id,h=height+5); // Remove ID
       translate([0,0,-2.5]) cube([100,10,5],center=true); // Remove below Z0
   }

   // Launch Lugs
   if(has_lug) make_extended_lug();
}

module make_3_tube_coupler(height=10,id=47,od=50,has_tvc=false,has_lug=false){

if(DEBUG) echo(str("DEBUG - RocketLib::make_3_tube_coupler() - Coupler_ID = ",id));

offset  = od/2 + 2.5;
join_od = height;
tvc_od  = 13;
   

   
   difference(){
       union(){
           make_chamfered_cylinder(height, od, od, chamfer_size=1, position="top");
           make_corrugated_cylinder(od+1,height=height-1,corrugation_radius=1,nbr_corregations=25);
           t_x(od+5) {
               make_chamfered_cylinder(height, od, od, chamfer_size=1, position="top");
               make_corrugated_cylinder(od+1,height=height-1,corrugation_radius=1,nbr_corregations=25);
           }
           t_x(-(od+5)) {
               make_chamfered_cylinder(height, od, od, chamfer_size=1, position="top");
               make_corrugated_cylinder(od+1,height=height-1,corrugation_radius=1,nbr_corregations=25);
           }
           scale([1,1.5,1.6]) translate([offset,0,height/2-1]) sphere(d=join_od);
           scale([1,1.5,1.6]) translate([-offset,0,height/2-1]) sphere(d=join_od);
           }
       t_z(-.1)                   cylinder(d=id,h=height+5);
       translate([od+5,0,-.1])    cylinder(d=id,h=height+5);
       translate([-(od+5),0,-.1]) cylinder(d=id,h=height+5);
       translate([0,0,-2.5]) cube([100,10,5],center=true); // Remove below Z0
   }
      if(has_tvc){
         tvc_radius = tvc_od/2;
         translate(translate_cvt_left)
            fillet_tube(height-5,tvc_radius,tvc_radius+1.5,tvc_radius+1.5,chamfer_size=1); // TVC mounts
         translate(translate_cvt_right)
            fillet_tube(height-5,tvc_radius,tvc_radius+1.5,tvc_radius+1.5,chamfer_size=1);// TVC mounts
      }

      // Launch Lugs
   if(has_lug) make_extended_lug();

}

// *****************
// *** Nosecones ***
// *****************

module make_nosecone(body_tube_id,body_tube_od,cone_length,shape,shoulder_len){

    radius_id = body_tube_id/2;	// inside radius of rocket tube, should be >= 7 
    radius_od = body_tube_od/2;	// ouside radius of rocket tube / nose cone, should be > radius_in

    nosecone(radius_id,radius_od,cone_length,shape,shoulder_len);

}

module make_shouldered_nosecone(shoulder_height,shoulder_od,cone_od_1,cone_od_2,cone_height,tip_r,b_recovery=false){
    new_cone_height = cone_height - shoulder_height - tip_r;
    sphere_offset   = shoulder_height + new_cone_height-1;

    color(color_nosecone){
    
      // Shoulder
      if(b_recovery == false)
         cylinder(h=shoulder_height,d=shoulder_od);
      else
         recovery_shoulder(shoulder_height,shoulder_od/2);
         
      translate([0,0,shoulder_height]) cylinder(h=new_cone_height,d1=cone_od_1,d2=cone_od_2-.2);
      translate([0,0,sphere_offset]) sphere(r=tip_r);
    }
}

module make_biconic_nosecone(height,od_shoulder,shoulder_len,od_1,od_2,od_3,solid=true,thickness=3,porthole=false){

   // Shoulder
   difference(){
      cylinder(h=shoulder_len, d=od_shoulder);
      if(solid==false) t_z(-.1) cylinder(h=shoulder_len+1, d=od_shoulder-thickness*1.5);
   }
      
   // Middle truncated cone
   translate([0,0,shoulder_len])
      difference() {
         cylinder(h=height*.5, d1=od_1, d2=od_2);
         if(solid==false) t_z(-.1)cylinder(h=height*.5+1, d1=od_1-thickness*2, d2=od_2-thickness*1.5);
         if(porthole==true){
            t_z(20) rotate([90,0,0]) cylinder(h=100,d=25,center=true);
            t_z(20) rotate([90,0,90]) cylinder(h=100,d=25,center=true);
         }
      }
      
   // Top truncated cone
   translate([0,0,shoulder_len+height*.5]){
  
  difference(){
         cylinder(h=height*.5, d1=od_2, d2=od_3);
         if(solid==false) t_z(-.1) cylinder(h=height*.5+.2, d1=od_2-thickness*1.5, d2=od_3-thickness);
      }

      translate([0,0,height*.5-1]) scale([1,1,1])
         //sphere(d=od_3+.2);  // rounded tip
         make_hollow_hemisphere(od_3+.3,1,top=true);
    }
}    


// ************************
// *** Triangular Slots ***
// ************************

module make_radial_fin_rails(num_rails=3,radius=30,fin_height=40,rail_width=11,rail_thickness=10){
    for (i = [0:num_rails-1]) {
        angle = 360/num_rails * i;
        rotate(a=angle,v=[0,0,1]) 
            translate([radius+rail_thickness,0,0]) 
                make_estes_rail_female(fin_height,rail_width,rail_thickness);
    }
}

module make_v_radial_fin_rails(num_rails=3,radius=30,fin_height=40,rail_width=11,rail_thickness=10,is_left){
     
     angle1 = is_left ? 270 : 90;
     angle2 = is_left ? 90 : 270;
     angle3 = is_left ? 180 : 0;
     
     rotate(a=angle1,v=[0,0,1]) translate([radius+rail_thickness,0,0]) 
        make_estes_rail_female(fin_height,rail_width,rail_thickness);
     rotate(a=angle2,v=[0,0,1]) translate([radius+rail_thickness,0,0]) 
        make_estes_rail_female(fin_height,rail_width,rail_thickness);
     rotate(a=angle3,v=[0,0,1]) translate([radius+rail_thickness,0,0]) 
        make_estes_rail_female(fin_height,rail_width,rail_thickness);
   
}

module make_estes_rail_male(height=15,width=11){
    //et_od = 9.16;  // Very tight with PLA fin and PETG fin can
    //et_od = 9.1;     // Good fit PLA fin and PETG fin can
    et_od = 8.8;    // PLA to PLA
    
    difference(){
        union(){
        // The triangle portion
        translate([et_od/4,0,0]) cylinder($fn=3,d=et_od,h=height);
        // The 'backstop' triangle is embedded in
        translate([3.2,-width/2,0]) cube([3,width,height]);
        }
        // Taper top end so its not blunt
        translate([5,0,height+1]) rotate([0,45,0]) cube([width+1,width+1,5],center=true);
    }
}

module make_estes_rail_female(height=25,width=15,thickness=10){
    et_od = 9.16;
    end_stop_thickness = 2; 
    rotate([0,0,180]) difference(){
        // The block ET is excluded from
        translate([0,-width/2,0]) cube([thickness,width,height+end_stop_thickness]);
        // The ET portion
        rotate([0,0,180]) translate([0,0,end_stop_thickness]) cylinder($fn=3,d=et_od,h=height+1);
    }
}



// ************
// *** FINS ***
// ************

module make_square_fins(num_fins,tube_diameter,width,height,fin_thickness,inset_fin){
      
    $angle_incr = 360/num_fins;
    for(angle=[0:$angle_incr:(num_fins-1)*$angle_incr]){    
    
        rotate(a=angle,v=[0,0,1])    
                make_square_fin(width,height,tube_diameter,fin_thickness,inset_fin);
    }
}

module make_square_fin(width,height,tube_diameter,thickness,inset_fin){
    translate([-(thickness/2),tube_diameter/2-inset_fin,0]){
    cube(size=[thickness,width,height],center=false);
  }
}

module make_tapered_fins(num_fins,tube_diameter,width,height,tip,thickness){

    // So it is part of the body and edge is not on tangent
    $inset_fin=.2;
      
    $angle_incr = 360/num_fins;
    for(angle=[0:$angle_incr:(num_fins-1)*$angle_incr]){    
            rotate(a=angle,v=[0,0,1])    
                make_tapered_fin(width,height,tip,tube_diameter,$FIN_THICKNESS);
    }
    
}


module make_tapered_fin(width,height,tip,tube_diameter,thickness){
 translate([tube_diameter/2-$inset_fin,thickness/2,0]){
    rotate(a=90,v=[1,0,0])
    linear_extrude(2)
    polygon([[0,0],[0,height],[width,tip],[width,0]]);
 }
}

module make_tapered_fin_attachable(width,height,tip,tube_diameter,thickness){
 translate([0,thickness/2,0]){
    rotate(a=90,v=[1,0,0])
    linear_extrude(thickness)
    polygon([[0,0],[0,height],[width,tip],[width,0]]);
 }
 make_estes_rail_male(height,10);
}

// ***************
// *** Nozzles ***
// ***************

module make_nozzle(od_top,od_bottom,height,thickness){
    
    torus_od = od_top - ((od_top - od_bottom)/2) - .5;
echo(od_top=od_top,od_bottom=od_bottom,torus_od=torus_od);    
    make_hollow_cone(od_top,od_bottom,height,thickness);
    //translate([0,0,height/2]) make_horizontal_torus(torus_od-2,torus_od-.5); // inner,outer
    //translate([0,0,height-1]) make_horizontal_torus(od_top-4,od_top-3); // inner,outer

}

module make_rocket_motor(od_top=10,od_bottom=20, height = 50,thickness=2) {
    
    
    // Define proportions for more realism
    throat_dia = od_top;  // Throat diameter
    exit_dia = od_bottom;    // Exit diameter (bell end)
    bell_height = height;   // Diverging bell section


    // Ensure inner diameters are positive
    if (throat_dia - 2 * thickness <= 0) {
        echo("Warning: Thickness too large for throat diameter.");
    }

    // Main hollow body
    epsilon = 0.1;  // Small overlap to ensure clean subtraction
    difference() {
        cylinder(h = bell_height, d1 = exit_dia, d2 = throat_dia);
        translate([0, 0, -epsilon])
            cylinder(h = bell_height + 2 * epsilon, d1 = exit_dia - thickness , d2 = throat_dia -  thickness);
    }
    cylinder(h=2,d=exit_dia-1);
    t_z(bell_height-4) cylinder(h=3,d=throat_dia+3);

    // Smaller bands on bell (more of them, adjusted for taper)
    band_height = .2;
    band_thick = .1;
    num_bell_bands = 8;
    bell_band_spacing = bell_height / (num_bell_bands + 1);
    for (i = [1 : num_bell_bands]) {
        z_pos = i * bell_band_spacing;
        // Interpolate diameter at z_pos
        dia_at_z = exit_dia + (throat_dia - exit_dia) * (z_pos / bell_height);
        translate([0, 0, z_pos])
        difference() {
            cylinder(h = band_height, d = dia_at_z + band_thick * 2, center = true);
            cylinder(h = band_height + 2, d = dia_at_z, center = true);
        }
    }
}

// *************
// *** Tanks ***
// *************

module make_cored_tank(width,height,core_od,has_bulkhead=false){
    tolerance = .25;
    thickness = 2;
    bulkhead_height = 5;
    new_core_od = core_od+tolerance;

    difference(){
        
        //union(){
            make_tank_solid(width,height,thickness);
        //    if(has_bulkhead == true) cylinder(d=width,h=bulkhead_height);
        //}
        translate([0,0,-.1]) cylinder(h=height+1,d=new_core_od);
        //translate([width/2-3,0,-.1]) cylinder(h=bulkhead_height+1,w=3);
    }
}

module make_tank_solid(width,height){

    radius = width/2;
    
    new_height = height - width;

    translate([0,0,radius])            cylinder(d=width,h=new_height);
    translate([0,0,radius])            make_hemisphere(width,false);    
    translate([0,0,radius+new_height]) make_hemisphere(width,true);    
}

module make_tank(width,height,thickness){

    radius = width/2;
    
    new_height = height - width;

    //translate([0,0,radius])            make_tube(width-thickness,width,new_height);
    translate([0,0,radius])            make_hollow_hemisphere(width,thickness,false);    
    translate([0,0,radius+new_height]) make_hollow_hemisphere(width,thickness,true);    
}

module make_stage_top(id,od,shoulder_height,bulkhead_height,z_top_main,solid,isEndcap){
    
    new_od    = id;
    thickness = od-id;
    new_id    = new_od-thickness;
    bulkhead_od = isEndcap ? od : id;
    
    if(DEBUG) echo("DEBUG - RocketLib::make_stage_top() - ",od=new_od,id=new_id,thickness=thickness,isEndcap=isEndcap);
    
    translate([0,0,z_top_main]) scale([1,1,.5])
        if(solid == true)
            make_hemisphere(bulkhead_od);
        else
            make_hollow_hemisphere(bulkhead_od,thickness);
/*            
    // Shoulder
    translate([0,0,z_top_main-shoulder_height/2+.1]) scale([1,1,.5])
        if(solid == true)
            cylinder(d=new_od,h=shoulder_height);
        else
            make_tube(new_id,new_od,shoulder_height);  
*/    
    // Details
    //translate([0,0,z_top_main+bulkhead_height+.8]) cylinder(h=2,d=od*.5);
       translate([0,0,z_top_main+bulkhead_height+.8]) make_INT_key_pin(TUBE_MAIN_ID/2);

    //translate([3,0,z_top_main+bulkhead_height]) cube([od*.1,od*.1,2],center=true);
    //translate([-4,2,z_top_main+bulkhead_height]) cube([od*.1,od*.1,2],center=true);
}

module make_stage_body(id,od,nozzle_height,bulkhead_height,main_height,detail_height,solid,details=false){

    if(DEBUG) echo("DEBUG - RocketLib::make_stage_body() - ",od=od,id=id,thickness=od-id);

    // Main Body - add vertical and ring lines for detail
    translate([0,0,nozzle_height+bulkhead_height]){
        make_tube(id,od,main_height);
        if( details == true ){
            make_square_fins(6,od,detail_height,main_height,.5,.2);
            translate ([0,0,main_height*.25]) make_tube(od,od+detail_height,.5);
            translate ([0,0,main_height*.50]) make_tube(od,od+detail_height,.5);
            translate ([0,0,main_height*.75]) make_tube(od,od+detail_height,.5);
        }
    }
}

module make_stage_bottom(id,od,shoulder_height,nbr_engines,nozzle_top_od,nozzle_bottom_od,nozzle_height,bulkhead_height,solid,isEndcap){
    
    new_od    = id;
    thickness = od-id;
    new_id    = new_od-thickness;
    bulkhead_od = isEndcap ? od : id;

    if(DEBUG) echo("DEBUG - RocketLib::make_stage_bottom() - ",od=new_od,id=new_id,thickness=thickness,isEndcap=isEndcap);

    translate([0,0,nozzle_height+bulkhead_height]) scale([1,1,.5])
       if(solid == true)
          make_hemisphere(bulkhead_od,top=false);
       else
          make_hollow_hemisphere(bulkhead_od,thickness,top=false);
/*           
    // Shoulder
    translate([0,0,nozzle_height+bulkhead_height]) scale([1,1,.5])
        if(solid == true)
            cylinder(d=new_od,h=shoulder_height);
        else
            make_tube(new_id,new_od,shoulder_height);
*/
    // Extra 'details' for realism
    color(get_color("white")) translate([0,0,nozzle_height-2]) cylinder(h=5,d=od*.75);
    //translate([0,0,nozzle_height]) cube([od*.6,od*.6,2],center=true);
    
    new_nozzle_top_od    = od * .15;
    new_nozzle_bottom_od = od * .4;
    nozzle_thickness     = 1;
    nozzle_offset        = nozzle_bottom_od + 1; //2+1;
    
    if(nbr_engines == 1){
        translate([7,1,nozzle_height-2]) sphere(r=od*.1); // detail
        translate([-7,-3,nozzle_height-2]) sphere(r=od*.1 ); // detail
        translate([-7,6,nozzle_height-2]) sphere(r=od*.1 ); // detail
        make_rocket_motor(new_nozzle_top_od,
        new_nozzle_bottom_od, nozzle_height,nozzle_thickness);
    } else {
        color(get_color("silver")){
            translate([1,4,nozzle_height-2]) sphere(r=od*.1); // detail
            translate([-1,-4,nozzle_height-2]) sphere(r=od*.1); // detail
        }
        color(get_color("black")){
           translate([-nozzle_offset,0,0])
               make_rocket_motor(od_top=new_nozzle_top_od,
               od_bottom=new_nozzle_bottom_od, height = nozzle_height,
               thickness=nozzle_thickness) ;
           translate([nozzle_offset,0,0])
               make_rocket_motor(od_top=new_nozzle_top_od,
               od_bottom=new_nozzle_bottom_od, height = nozzle_height,
               thickness=nozzle_thickness) ;
        }
   }
    
}

// ***************     
// *** Baffles ***
// ***************

module make_baffle_v1(body_tube_id,motor_od){
    baffle_offset = 53.5;
    difference(){
        make_tank(body_tube_id,15,2);
        translate([0,0,-1]) cylinder(h=100,d=motor_od);
    }
    translate([0,0,baffle_offset]) make_nozzle(diameter,motor_od+2,10,3);
}

module make_baffle_v2(parent_inner){
    //make_hollow_cone(od_top,od_bottom,height,thickness)
    make_hollow_cone(parent_inner,$MOTOR_DIA+10,20,3);
    translate([0,0,20]) make_tube(parent_inner-3,parent_inner,20);
    translate([0,0,40]) make_hollow_cone($MOTOR_DIA+10,parent_inner,20,3);
    
    //difference(){
    //    make_tank(diameter,15,2);
    //    translate([0,0,-1]) cylinder(h=100,d=$MOTOR_DIA);
    //}
    baffle_offset = 53.5;
    translate([0,0,baffle_offset]) make_nozzle(diameter,motor_od+2,10,3);
}

// ***************
// *** Canards ***
// ***************

module make_canard(body_tube_od,canard_height){
    canard_thickness = 3;
    canard_id  = body_tube_od;
    canard_od  = canard_id + canard_thickness;
    fins       = 4;
    width      = 10;
    thickness  = 2;
    tip_height = 5;
    
    make_top_chamfered_tube(canard_id,canard_od,canard_height);
    make_tapered_fins(fins,canard_od,width,canard_height-3,tip_height,thickness);

    rotate([0,0,45]) make_launch_lug(body_tube_od,canard_height);
            
}    

// ***************************
// *** Launch Lugs & Rails ***
// ***************************

module make_launch_lug(body_tube_od,height,tapered=true,lug_id=5){
        
        max_length = 40;
        // clamp height to max_value
        new_height = height > max_length ? max_length : height;
        center_adj = (height - new_height) / 2;
        x_offset = - (body_tube_od/2 + (lug_id+3)/2);
    translate([0,0,center_adj])
        difference(){    
            translate([x_offset,0,0]) make_tube(lug_id,lug_id+2,new_height-4);
            if(tapered == true) {
               translate([-body_tube_od/2-4,0,new_height-7]) rotate([0,-45,0]) cylinder(h=8,d=10);
               translate([-body_tube_od/2-8,0,-7]) rotate([0,45,0]) cylinder(h=10,d=20);
               }
        }
 }

// **************************
// *** Tail Section Parts ***
// **************************

module make_tail_section_v1_v2(version,body_tube_id,body_tube_od,tail_height,nbr_fins,fin_width,fin_height,tip_height,fin_thickness,tail_thickness,motor_od,motor_len,motor_stickout){
    make_tube(body_tube_od-tail_thickness,body_tube_od,tail_height);
    make_tapered_fins(nbr_fins,body_tube_od,fin_width,fin_height,tip_height,fin_thickness);
    make_engine_mount_v1_v3(version,body_tube_id,body_tube_od,motor_od,motor_len,motor_stickout,fin_thickness);
}

module make_tail_section_v3_v4(version,body_tube_od,tail_height,
   num_fins,fin_height,fin_width,fin_tip_height,fin_thickness,cutouts=false,is_left=true){

    rail_width     = 11;
    rail_thickness = 5;
    new_od         = body_tube_od + 3;
    
    // Make a tube with oval cutouts
     difference(){
        make_top_chamfered_tube(body_tube_od,new_od,tail_height);
        if(cutouts == true ) {
           translate([0,0,20]) rotate([45,90,0])  scale([1,.75,1]) cylinder(h=50,d=15,center=true);
           translate([0,0,45]) rotate([45,90,0])  scale([1,.75,1]) cylinder(h=50,d=15,center=true);
           translate([0,0,20]) rotate([-45,90,0]) scale([1,.75,1]) cylinder(h=40,d=15);
           translate([0,0,45]) rotate([-45,90,0]) scale([1,.75,1]) cylinder(h=40,d=15);
         }
     }
    
    if(version == "v3"){
        make_tapered_fins(num_fins,new_od-1,fin_width,fin_height,fin_tip_height,fin_thickness);
    } else {    
        make_v_radial_fin_rails(num_fins,body_tube_od/2,fin_height,rail_width,rail_thickness,is_left);
        //translate([body_tube_od/2,0,0]) make_tapered_fin_attachable(fin_width,fin_height,fin_tip_height,body_tube_od,fin_thickness);

    }
    
}

module make_chimney(){
    make_tube($MOTOR_DIA-2,$DIAMETER-1.5,2);
    make_tube($MOTOR_DIA-2,$MOTOR_DIA,10);    
}

module make_engine_retainer(){
    cap_dia = $MOTOR_OD+15;
    // endCap(diameter,height,thread_height,thread_diameter,engine_diameter){
    endCap(cap_dia,$CAP_HEIGHT,cap_dia+5,$THREAD_OD,$MOTOR_OD);
    // Uncomment to make a matching body for the cap to screw into
    //threaded_body(cap_dia,$INNER_THREAD_HEIGHT,$INNER_THREAD_HEIGHT,cap_dia-5);
}

// ***************
// ENGINE MOUNT
// ***************

module make_engine_mount_v1_v2(version,body_tube_id,body_tube_od,motor_od,motor_len,motor_stickout,fin_thickness){

    fit_allowance         = .25;
    end_thickness         = 2;
    engine_tube_thickness = 2;
    transition_height     = 10;
    num_buttress          = 6;
    num_ribs              = 6;
    engine_retain         = .2;
    engine_retain_id      = motor_od - engine_retain;
    height                = motor_len - motor_stickout;
    motor_tube_id         = motor_od + fit_allowance;
    motor_tube_od         = motor_od + engine_tube_thickness;
    start_height          = height - transition_height;
    
    // Cap the top
    //make_buttressed_tube(tube_id,tube_od,tube_height,buttress_height,num_buttress){
    translate([0,0,start_height])make_buttressed_tube(engine_retain_id,body_tube_id,end_thickness,transition_height,num_buttress);
    
    if( version == "v1"){
        // Tube to hold motor - NOTE !! Not really viable as engine heat causes shrinkage and motor gets stuck
        make_tube(motor_tube_id,motor_tube_od,height);
    } else {
        // Fins to hold motor
        make_square_fins(nbr_ribs,motor_od,(body_tube_od/2-motor_od/2)+.2,height,fin_thickness,0);
    }

    // Cap the end with a filler ring
    make_tube(motor_tube_id,body_tube_od,end_thickness);    
}


module make_engine_mount_v3_v4(version,core_height,body_tube_id,body_tube_od,motor_od,motor_len,motor_stickout,inner_thread_height,fin_thickness,thread_od){
    
    end_thickness         = 2;
    transition_height     = 10;
    num_buttress          = 6;
    num_ribs              = 6;
    engine_retain         = .2;
    engine_retain_id      = motor_od - engine_retain;
    height2               = motor_len-motor_stickout;
    start_height          = height2-transition_height;
    taper_clearance       = .75;
    taper_height          = 4;

    // RodEnd(diameter, height, thread_len=0, thread_diam=0, thread_pitch=0) {
    RodEnd(body_tube_od-1,inner_thread_height,inner_thread_height,thread_od);

    // create tapered transition cone - transitions from threaded area to support start of fins
    // Fins cannot be in threded area becuase there is no room without them encroaching into the threads.
    translate([0,0,inner_thread_height-3])
        make_inner_tapered_tube(id=motor_od-taper_clearance,od=body_tube_id,taper_height=taper_height,taper_od=motor_od+5);
        
    // Fins above threaded section
    translate([0,0,inner_thread_height]){
        if(version == "v3"){
            make_square_fins(num_ribs,motor_od,(body_tube_od/2-motor_od/2)-.1,core_height,fin_thickness,0);
        } else {
            make_spiraled_tube(num_ribs,motor_od,body_tube_od,core_height,thread_od);
        }    
    }
    
    // Cap the end with a filler ring
    make_tube(thread_od,body_tube_od,10);    
    
    translate([0,0,start_height])make_buttressed_tube(engine_retain_id,body_tube_od+1,end_thickness,transition_height,num_buttress);

}

