
include <ThreadLib.scad>
include <PezLib.scad>
include <RocketLib.scad>
include <Nosecone.scad>
include <Estes.scad>
include <PolyTube.scad>

// Number of 'sides' in circles
// Amount of detail
$fn=50;

// NOTE: All measurements are metric (mm)

// ***********************************************************
// *** Set parameters for current rocket you want to build ***
// ***********************************************************

    $HEIGHT              = 425;

    $NOSECONE_LENGTH   = 70;
    $NOSECONE_SHOULDER = 20;
    // Valid Types - ** "parabolic", ** "power_series", "haack" or "lpaelke" (Lutz Paelke)
    $NOSECONE_SHAPE    = "power_series"; 

    $TAIL_HEIGHT         = 80;
    $INNER_THREAD_HEIGHT = 10;

    $CAP_HEIGHT          = 20;
    $CAP_WIDTH           = 30;
    $KNURL_HEIGHT        = 10;
    $CAP_FLOOR           = 2;

    $BODY_TUBE_OD  = $M_OD;
    $BODY_TUBE_ID  = $M_ID;

    $MOTOR_LEN      = $estes_medium_len;
    $MOTOR_OD       = $estes_medium_dia;
    $MOTOR_STICKOUT = 8;

    $THREAD_OD = $MOTOR_OD +12;

    $NBR_FINS          = 4;
    $FIN_ATTACH_HEIGHT = 50;
    $FIN_THICKNESS     = 2;

    $CANARD_HEIGHT     = 20;
    

// *************************
// *** Fin Requirements  ***
// *************************
    
    $FIN_WIDTH     = 1.25  * $BODY_TUBE_OD;  // Root to edge, perp to body
    $FIN_HEIGHT    = 1.25  * $BODY_TUBE_OD;  // Length along body tube
    $TIP_HEIGHT    = 0.6   * $BODY_TUBE_OD;  // Height of fin edge

    $FIN_AREA_REQ  = .33333 * $HEIGHT * $BODY_TUBE_OD;
    $FIN_AREA = ($TIP_HEIGHT * $FIN_WIDTH) + (.5*$FIN_WIDTH*($FIN_HEIGHT-$TIP_HEIGHT)) ;
   
    echo(area_required=$FIN_AREA_REQ/$NBR_FINS, fin_area=$FIN_AREA);

// *********************************
// *** Rocket Performance Specs  ***
// *********************************

   // Todo: Is this configuration viable ???

// *****************************
// *** Make the Rocket Parts ***
// *****************************
       
    //make_voyager_rocket();
    make_rocket_v4();
    
// ****************************************
// *** Different versions of the rocket ***
// ****************************************


module make_voyager_rocket(){
    total_height = 48.5; //(meters, actually)
    height = 485;
    
    color([.5,.5,.5,.5]){
        % translate([0,0,10])    make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,height);
        % translate([50,0,20])   make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,height);
        % translate([-50,0,20])  make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,height);
        % translate([0,0,height+50])   make_tube($BODY_TUBE_ID+20,$BODY_TUBE_OD+20,150);
    }
}

// V1 rockets use tail with integrated fins, solid integrated motor housing
module make_rocket_v1(){

    // *** Dummy Motor ***    
    //%translate([0,0,-$MOTOR_STICKOUT]) color([0,0,1,.5]) cylinder(h=$MOTOR_LEN,d=$MOTOR_OD);

    // *** Nose Cone
    translate([0,0,$HEIGHT-$NOSECONE_SHOULDER+$FIN_HEIGHT]) make_haack_nosecone();
    
    // *** Tail ***
    make_tail_section_v1();

    // *** Body Tube
    
    % translate([0,0,$FIN_HEIGHT]) color([.5,.5,.5,.5]) make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,$HEIGHT);

}

// V2 rockets use tail with integrated fins, ribbed integrated motor housing
module make_rocket_v2(){
    // *** Dummy Motor ***    
    %translate([0,0,-$MOTOR_STICKOUT]) color([0,0,1,.5]) cylinder(h=$MOTOR_LEN,d=$MOTOR_OD);

    // *** Nose Cone
    translate([0,0,$HEIGHT-$NOSECONE_SHOULDER+$FIN_HEIGHT]) make_haack_nosecone();
    
    // *** Tail ***
    make_tail_section_v2();

    // *** Body Tube
    % translate([0,0,$FIN_HEIGHT]) color([.5,.5,.5,.5]) make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,$HEIGHT);
}

// V3 Rockets use a seperate (fits on tube_od) tail with integrated fins, spiraled motor core, and threaded endcap, canard
module make_rocket_v3(){
echo(hello=2);
   // *** Dummy Motor ***    
   %translate([0,0,-$MOTOR_STICKOUT]) color([0,0,1,.5]) cylinder(h=$MOTOR_LEN,d=$MOTOR_OD);

    // *** Nose Cone
    translate([0,0,$HEIGHT-$NOSECONE_SHOULDER]) make_haack_nosecone();
    
    // *** Tail ***
    make_tail_section_v3();

    // *** Body Tube   
    % color([.5,.5,.5,.5]) make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,$HEIGHT);
    
    // *** Canard
    
    translate([0,0,$HEIGHT*.66]) make_canard();

    // *** Engine Cores ***
    
    make_engine_mount_v3();
    
    // *** End Cap Engine Retainer
    
    translate([0,0,-10]) color([1,0,0,1]) make_engine_retainer();
}

// V4 rockets use fin can tail, attachable fins, spiraled motor core w/ threaded endcap, canard 
module make_rocket_v4(){
    
   // *** Dummy Motor ***    
   %translate([0,0,-$MOTOR_STICKOUT]) color([0,0,1,.5]) cylinder(h=$MOTOR_LEN,d=$MOTOR_OD);

    // *** Nose Cone
    translate([0,0,$HEIGHT-$NOSECONE_SHOULDER]) make_haack_nosecone();
  
    // *** Canard  
    translate([0,0,$HEIGHT*.66]) make_canard();
   
    // *** Tail Section

    make_tail_section_v4($BODY_TUBE_OD,$TAIL_HEIGHT,$FIN_ATTACH_HEIGHT);

    // *** Body Tube   
    % color([.5,.5,.5,.5]) make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,$HEIGHT);

    // *** Attachable Fins ***

    // createTapered_fin_attachable(width,height,tip,tube_diameter,thickness);
    fin_width      = 55;
    fin_tip_height = 30;
    translate([$BODY_TUBE_OD/2,0,0]) make_tapered_fin_attachable(fin_width,$FIN_ATTACH_HEIGHT,fin_tip_height,$BODY_TUBE_OD,$FIN_THICKNESS);

    // *** Engine Cores ***
    
    make_engine_mount_v4($MOTOR_OD,$BODY_TUBE_ID,$THREAD_OD);
    
    // *** End Cap Engine Retainer
    
    translate([0,0,-10]) color([1,0,0,1]) make_engine_retainer(thread_od);
        
}












    