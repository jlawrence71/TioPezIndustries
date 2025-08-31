include <ThreadLib.scad>
include <PezLib.scad>

// *****************
// *** Nosecones ***
// *****************

module make_haack_nosecone(){

    radius_in  = $BODY_TUBE_ID/2;	// inside radius of rocket tube, should be >= 7 
    radius_out = $BODY_TUBE_OD/2;	// ouside radius of rocket tube / nose cone, should be > radius_in

    make_nosecone($BODY_TUBE_ID,$BODY_TUBE_OD,$NOSECONE_LENGTH,$NOSECONE_SHAPE,$NOSECONE_SHOULDER,
    radius_in,radius_out);

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

module make_estes_rail_male(height=15,width=11){
    //et_od = 9.16;  // Very tight with PLA fin and PETG fin can
    et_od = 9.1;  
    
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

// *************
// *** Tanks ***
// *************

module make_tank(width,height,thickness){

    radius = width/2;

    translate([0,0,radius])        make_tube(width-thickness,width,height);
    translate([0,0,radius])        make_hollow_hemisphere(width,thickness);    
    translate([0,0,radius+height]) make_hollow_hemisphere(width,thickness,false);    
}


// ***************     
// *** Baffles ***
// ***************

module make_baffle_v1(diameter){
    difference(){
        make_tank(diameter,15,2);
        translate([0,0,-1]) cylinder(h=100,d=$MOTOR_DIA);
    }
    translate([0,0,53.5]) make_nozzle(diameter,$MOTOR_DIA+2,10,3);
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
    //translate([0,0,53.5]) make_nozzle(diameter,$MOTOR_DIA+2,10,3);
}

// ***************
// *** Canards ***
// ***************

module make_canard(){
    canard_thickness = 3;
    canard_id  = $BODY_TUBE_OD;
    canard_od  = canard_id + canard_thickness;
    fins       = 4;
    width      = 10;
    thickness  = 2;
    tip_height = 5;
    
    make_top_chamfered_tube(canard_id,canard_od,$CANARD_HEIGHT);
    make_tapered_fins(fins,canard_od,width,$CANARD_HEIGHT-3,tip_height,thickness);

    rotate([0,0,45]) make_launch_lug($BODY_TUBE_OD,$CANARD_HEIGHT);
            
}    

// ***************************
// *** Launch Lugs & Rails ***
// ***************************

module make_launch_lug(parent_tube_od,height){
        difference(){    
            translate([-parent_tube_od/2-4,0,0])  make_tube(5,7,height-4);
            translate([-parent_tube_od/2-4,0,height-7]) rotate([0,-45,0]) cylinder(h=8,d=10);
            translate([-parent_tube_od/2-8,0,-7]) rotate([0,45,0]) cylinder(h=10,d=20);
        }
 }

// **************************
// *** Tail Section Parts ***
// **************************

module make_tail_section_v1(){
    make_tube($BODY_TUBE_OD-2,$BODY_TUBE_OD,$TAIL_HEIGHT);
    make_tapered_fins($NBR_FINS,$BODY_TUBE_OD,$FIN_WIDTH,$FIN_HEIGHT,$TIP_HEIGHT,$FIN_THICKNESS);
    make_engine_mount_v1();
}

module make_tail_section_v2(){
    make_tube($BODY_TUBE_OD-2,$BODY_TUBE_OD,$TAIL_HEIGHT);
    make_tapered_fins($NBR_FINS,$BODY_TUBE_OD,$FIN_WIDTH,$FIN_HEIGHT,$TIP_HEIGHT,$FIN_THICKNESS);
    make_engine_mount_v2();
}

module make_tail_section_v3(){
    new_od = $BODY_TUBE_OD + 3;
    
    difference(){
        make_top_chamfered_tube($BODY_TUBE_OD,new_od,$TAIL_HEIGHT);
        translate([0,0,20]) rotate([45,90,0])  scale([1,.75,1]) cylinder(h=50,d=15,center=true);
        translate([0,0,45]) rotate([45,90,0])  scale([1,.75,1]) cylinder(h=50,d=15,center=true);
        translate([0,0,20]) rotate([-45,90,0]) scale([1,.75,1]) cylinder(h=40,d=15);
        translate([0,0,45]) rotate([-45,90,0]) scale([1,.75,1]) cylinder(h=40,d=15);
    }
    
    make_tapered_fins($NBR_FINS,new_od-1,$FIN_WIDTH,$FIN_HEIGHT,$TIP_HEIGHT,$FIN_THICKNESS);
    
    rotate([0,0,45]) make_launch_lug($BODY_TUBE_OD,$TAIL_HEIGHT);
    
}

module make_tail_section_v4(body_tube_od,height,fin_attach_height=40){

    num_rails      = 4;
    rail_width     = 11;
    rail_thickness = 5;
    new_od         = body_tube_od + 3;
    
    make_radial_fin_rails(num_rails,body_tube_od/2,fin_attach_height,rail_width,rail_thickness);
    make_top_chamfered_tube(body_tube_od,new_od,height);

    rotate([0,0,45]) make_launch_lug(body_tube_od,height);
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

module make_engine_mount_v1(version){
    make_engine_mount_v1_v2("v1");
}

module make_engine_mount_v2(version){
    make_engine_mount_v1_v2("v2");
}

module make_engine_mount_v1_v2(version){

    fit_allowance         = .25;
    end_thickness         = 2;
    engine_tube_thickness = 2;
    transition_height     = 10;
    num_buttress          = 6;
    engine_retain         = .2;
    engine_retain_id      = $MOTOR_OD - engine_retain;
    height                = $MOTOR_LEN-$MOTOR_STICKOUT;
    tube_id               = $MOTOR_OD+fit_allowance;
    tube_od               = $MOTOR_OD + engine_tube_thickness;
    start_height          = height-transition_height;
    
    // Cap the top
    //make_buttressed_tube(tube_id,tube_od,tube_height,buttress_height,num_buttress){
    translate([0,0,start_height])make_buttressed_tube(engine_retain_id,$BODY_TUBE_ID,end_thickness,transition_height,num_buttress);
    
    
    if( version == "v1"){
        make_tube($MOTOR_OD+fit_allowance,$MOTOR_OD + engine_tube_thickness,height);
    }
    
    // Fins to hold motor
    if( version == "v2"){
        make_square_fins(6,$MOTOR_OD,($BODY_TUBE_ID/2-$MOTOR_OD/2)+.2,height,   $FIN_THICKNESS,0);
    }

    // Cap the end with a filler ring
    make_tube($MOTOR_OD+fit_allowance,$BODY_TUBE_OD,end_thickness);    
}


module make_engine_mount_v3(){
    end_thickness         = 2;
    transition_height     = 10;
    num_buttress          = 6;
    engine_retain         = .2;
    engine_retain_id      = $MOTOR_OD - engine_retain;
    height2               = $MOTOR_LEN-$MOTOR_STICKOUT;
    start_height          = height2-transition_height;

    height = $MOTOR_LEN - $KNURL_HEIGHT - $INNER_THREAD_HEIGHT + $CAP_FLOOR;
    
    // RodEnd(diameter, height, thread_len=0, thread_diam=0, thread_pitch=0) {
    RodEnd($BODY_TUBE_OD-1,$INNER_THREAD_HEIGHT,$INNER_THREAD_HEIGHT,$MOTOR_OD+10);

    // create tapered transition cone
    translate([0,0,$INNER_THREAD_HEIGHT-3])
    difference(){
       cylinder(h=3,d=$MOTOR_OD+10);
        translate([0,0,-.1])
           cylinder(h=4,d1=$MOTOR_OD+5,d2=$MOTOR_OD-1.5);
    }
        
    // Fins above threaded section
    translate([0,0,$INNER_THREAD_HEIGHT])
        make_square_fins(6,$MOTOR_OD,($BODY_TUBE_OD/2-$MOTOR_OD/2)-.1,height,$FIN_THICKNESS,0);

    // Cap the end with a filler ring
    make_tube($MOTOR_OD+12,$BODY_TUBE_OD,10);    

    // Cap the top too with a supported roof
    //translate([0,0,height+$INNER_THREAD_HEIGHT-3]) make_tube($MOTOR_OD,$BODY_TUBE_OD,3);
    
    // Cap the top
    //make_buttressed_tube(tube_id,tube_od,tube_height,buttress_height,num_buttress){
    translate([0,0,start_height])make_buttressed_tube(engine_retain_id,$BODY_TUBE_ID+1,end_thickness,transition_height,num_buttress);

}

module make_engine_mount_v4(motor_od,parent_id,thread_od){

    height = $MOTOR_LEN - $KNURL_HEIGHT - $INNER_THREAD_HEIGHT + $CAP_FLOOR;

    // RodEnd(diameter, height, thread_len=0, thread_diam=0, thread_pitch=0) {
    RodEnd($BODY_TUBE_OD-1,$INNER_THREAD_HEIGHT,$INNER_THREAD_HEIGHT,thread_od);
    
    // create tapered transition cone
    translate([0,0,$INNER_THREAD_HEIGHT-3])
    difference(){
       cylinder(h=3,d=thread_od);
        translate([0,0,-.1])
           cylinder(h=4,d1=motor_od+5,d2=motor_od-1.5);
    }

    // make_spiraled_tube(num_flutes,id,od,height,id_plate)
    translate([0,0,$INNER_THREAD_HEIGHT]) make_spiraled_tube(6,motor_od,parent_id,height,thread_od);
    
    make_tube(thread_od,parent_id,$INNER_THREAD_HEIGHT);
}

