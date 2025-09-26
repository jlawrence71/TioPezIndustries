
include <ThreadLib.scad>
include <PezLib.scad>
include <RocketLib.scad>
include <Nosecone.scad>
include <Estes.scad>
include <PolyTube.scad>

// *** Configuration Management ***

$PRINT_QUALITY = "draft"; // "draft", "normal", "high"
$GLOBAL_TOLERANCE = 0.2;   // mm
$fn = ($PRINT_QUALITY == "draft")  ? 25 : 
      ($PRINT_QUALITY == "normal") ? 50 : 80;
      
// NOTE: All measurements are metric (mm)

// ***********************************************************
// *** Set parameters for current rocket you want to build ***
// ***********************************************************

    $HEIGHT              = 425;

    $NOSECONE_LENGTH   = 70;
    $NOSECONE_SHOULDER = 20;
    // Valid Types - ** "conical", "parabolic", ** "power_series", "haack", "lpaelke" (Lutz Paelke - bi-elliptical ogive)
    $NOSECONE_SHAPE    = "parabolic"; 

    $TAIL_HEIGHT         = 80;
    $INNER_THREAD_HEIGHT = 10;
    $TAIL_THICKNESS      = 2;

    $CAP_HEIGHT          = 20;
    $CAP_WIDTH           = 30;
    $KNURL_HEIGHT        = 10;
    $CAP_FLOOR           = 2;

    $BODY_TUBE_OD  = $M_OD;
    $BODY_TUBE_ID  = $M_ID;

    $MOTOR_LEN      = $estes_medium_len;
    $MOTOR_OD       = $estes_medium_dia;
    $MOTOR_STICKOUT = 8;

    $THREAD_OD = $MOTOR_OD + 12;

    $NBR_FINS          = 4;
    $FIN_THICKNESS     = 2;

    $CANARD_HEIGHT     = 20;
    $CANARD_PCT_HEIGHT = .66; // 2/3 the way up the rocket
    

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
       
    make_rocket("v3");
    
// ****************************************
// *** Different versions of the rocket ***
// ****************************************

// V1 Use tail with integrated fins, solid tube integrated motor housing
// V1 Use tail with integrated fins, finned integrated motor housing
// V3 Use a seperate (fits on tube_od) tail with integrated fins, spiraled motor core, and threaded endcap, canard
// V4 Use fin can tail, attachable fins, spiraled motor core w/ threaded endcap, canard 
// Voyager - Titan IIe Centaur used to launch Voyager spacecrafts

module make_rocket(version){
    core_height = $MOTOR_LEN - $KNURL_HEIGHT - $INNER_THREAD_HEIGHT + $CAP_FLOOR;

    // *** Dummy Motor ***    
    %translate([0,0,-$MOTOR_STICKOUT]) color([0,0,1,.5]) cylinder(h=$MOTOR_LEN,d=$MOTOR_OD);

    if(version == "v1"){
        make_tail_section_v1($BODY_TUBE_ID,$BODY_TUBE_OD,$TAIL_HEIGHT,$NBR_FINS,$FIN_WIDTH,$FIN_HEIGHT,$TIP_HEIGHT,$FIN_THICKNESS,$TAIL_THICKNESS,$MOTOR_OD,$MOTOR_LEN,$MOTOR_STICKOUT);
    
    } else if (version == "v2"){
        make_tail_section_v2($BODY_TUBE_ID,$BODY_TUBE_OD,$TAIL_HEIGHT,$NBR_FINS,$FIN_WIDTH,$FIN_HEIGHT,$TIP_HEIGHT,$FIN_THICKNESS,$TAIL_THICKNESS,$MOTOR_OD,$MOTOR_LEN,$MOTOR_STICKOUT);
    
    } else if (version == "v3" || version == "v4"){
        make_tail_section_v3_v4(version,$BODY_TUBE_OD,$TAIL_HEIGHT,$NBR_FINS,$FIN_HEIGHT,$FIN_WIDTH,$TIP_HEIGHT,$FIN_THICKNESS);
        make_engine_mount_v3_v4(version,core_height,$BODY_TUBE_ID,$BODY_TUBE_OD,$MOTOR_OD,$MOTOR_LEN,$MOTOR_STICKOUT,$INNER_THREAD_HEIGHT,$FIN_THICKNESS,$THREAD_OD);
    
   } else {
        assert(false,str("I do not support that rocket version - ",version));
    }
    
    // Common items for V1 & V2
    if(version == "v1" || version == "v2"){
        translate([0,0,$HEIGHT-$NOSECONE_SHOULDER+$FIN_HEIGHT]) make_nosecone($BODY_TUBE_ID,$BODY_TUBE_OD,$NOSECONE_LENGTH,$NOSECONE_SHAPE,$NOSECONE_SHOULDER);
        translate([0,0,$FIN_HEIGHT]) % color([.5,.5,.5,.5]) make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,$HEIGHT);

    }
    
    // Common items for V3 & V4
    if(version == "v3" || version == "v4"){
        translate([0,0,$HEIGHT-$NOSECONE_SHOULDER]) make_nosecone($BODY_TUBE_ID,$BODY_TUBE_OD,$NOSECONE_LENGTH,$NOSECONE_SHAPE,$NOSECONE_SHOULDER);
        % color([.5,.5,.5,.5]) make_tube($BODY_TUBE_ID,$BODY_TUBE_OD,$HEIGHT);
        translate([0,0,$HEIGHT*$CANARD_PCT_HEIGHT ]) make_canard($BODY_TUBE_OD,$CANARD_HEIGHT);
        translate([0,0,-10]) color([1,0,0,1]) make_engine_retainer();
        }
}

}










    