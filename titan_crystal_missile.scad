// Titan IIIE/Centaur (Voyager) - Crystal Missile Scale Model
// Designed for available polycarbonate tubes
// Scale: approximately 1:50 
// Competition target: 300-500 feet altitude

// ========================
// Dimensions
// ========================

// Real Titan IIIE height: ~48.8m (Unit is meters)

_HEIGHT           = 48.8;
_FAIRING_L        = 17.678;         // Centaur Standard Shroud
_FAIRING_NOSE_L   = 6; // 8.9408;   // Biconic - 25, then 15 degrees
_STAGE1_BOATTAIL  = 1.397;          // Aft skirt protecting stage1 engine area
_STAGE1_ENGINE_L  = 2; //3.84;      // 
_STAGE1_I_L       = 3.01;           // Interstage
_STAGE1_L         = 22.28 - _STAGE1_I_L - _STAGE1_ENGINE_L;
_STAGE2_L         = 7.9;
_ADAPTER_L        = 1;
_CENTAUR_L        = 10; // 9.1-1.5;  // Excluding fairing (shroud)
_SRB_L            = 25.9;
_SRB_NOSE_L       = 5.105;
_SRB_SEG_L        = 3.05;
_SRB_TVC_L        = 7.6;   // The thrust-vector-control (TVC) "injection tank"

_SRB_TVC_OD     = 1.3; // ChatGPT said 1, but it did not look like the pictures;
_CORE_OD        = 3.05;
_SRB_OD         = 3.05;
_FAIRING_OD     = 4.267;
_CENTAUR_OD     = 5; // 3.048;
_PAF_L          = 1.5;

// Model Dimensions

conv         = 10;  // Multiply by 10 and treat units as mm
HEIGHT_ADJ   = 1.2; // Since I am not doing 'true' scale, stretching it to it 'looks' correct
MODEL_HEIGHT = _HEIGHT * conv; // Scale - 1m = 10mm


// ============================
// Tolerance
// ============================

function get_M_ID() =
   (FIT == "LOOSE") ? $M_IDL :
   (FIT == "SNUG")  ? $M_ID  :
   (FIT == "TIGHT") ? $M_IDT :
      assert(false,"Invalid value for FIT");

function get_M_OD() =
   (FIT == "LOOSE") ? $M_ODL :
   (FIT == "SNUG")  ? $M_OD  :
   (FIT == "TIGHT") ? $M_ODT :
      assert(false,"Invalid value for FIT");

function get_L_ID() =
   (FIT == "LOOSE") ? $L_IDL :
   (FIT == "SNUG")  ? $L_ID  :
   (FIT == "TIGHT") ? $L_IDT :
      assert(false,"Invalid value for FIT");

function get_L_OD() =
   (FIT == "LOOSE") ? $L_ODL :
   (FIT == "SNUG")  ? $L_OD  :
   (FIT == "TIGHT") ? $L_ODT :
      assert(false,"Invalid value for FIT");


// FAIRING/PAYLOAD SECTION - Partial large tube

TUBE_FAIRING_ID = get_L_ID();
TUBE_FAIRING_OD = get_L_OD();

FAIRING_L       = (_FAIRING_L*conv) * HEIGHT_ADJ;     
FAIRING_NOSE_L  = (_FAIRING_NOSE_L*conv) * HEIGHT_ADJ;
FAIRING_L_ADJ   = FAIRING_L - FAIRING_NOSE_L;

// MAIN BODY - Partial medium tube

TUBE_MAIN_ID    = get_M_ID();
TUBE_MAIN_OD    = get_M_OD();

STAGE1_L        = (_STAGE1_L*conv) * HEIGHT_ADJ;      
STAGE1_I_L      = (_STAGE1_I_L*conv) * HEIGHT_ADJ;      
STAGE2_L        = (_STAGE2_L*conv) * HEIGHT_ADJ -3;      
ADAPTER_L       = (_ADAPTER_L*conv) * HEIGHT_ADJ;      
STAGE1_ENGINE_L = (_STAGE1_ENGINE_L*conv) * HEIGHT_ADJ;
STAGE1_L_ADJ    = STAGE1_L - STAGE1_ENGINE_L;
CORE_L          = STAGE1_L_ADJ + STAGE2_L;
ENGINE_SKIRT_L  = _STAGE1_BOATTAIL * conv;

// CENTAUR (D1T) Upper Stage - Dimensions - Partial medium tube

TUBE_CENTAUR_OD = (_CENTAUR_OD*conv) * HEIGHT_ADJ; 
TUBE_CENTAUR_ID = TUBE_CENTAUR_OD-2;
CENTAUR_L       = (_CENTAUR_L*conv) * HEIGHT_ADJ;
PAF_L           = (_PAF_L*conv) * HEIGHT_ADJ;    

// SRB Dimensions (UA1205)) - 2 medium tubes needed

TUBE_SRB_ID     = get_M_ID();
TUBE_SRB_OD     = get_M_OD();

SRB_L        = (_SRB_L*conv) * HEIGHT_ADJ;
SRB_NOSE_L   = _SRB_NOSE_L * conv;
SRB_ENGINE_L = SRB_L * .07;
SRB_SEG_OD   = TUBE_SRB_ID;
SRB_SEG_L    = (_SRB_SEG_L*conv) * HEIGHT_ADJ;
SRB_LEN_ADJ  = SRB_L - SRB_NOSE_L - SRB_ENGINE_L;
SRB_TVC_L    = (_SRB_TVC_L*conv) * HEIGHT_ADJ;
SRB_TVC_OD   = (_SRB_TVC_OD*conv);

// ========================
// COMMON
// ========================

NOSECONE_SHOULDER_HEIGHT = 15;
ADAPTER_INSET            = 12.5;
LUG_ID                   = 5.2;

new_fairing_l = FAIRING_L - FAIRING_NOSE_L;

// ========================
// FINS
// ========================

FIN_CAN_L      = 64;
FIN_THICKNESS  = 2;
FIN_WIDTH      = 1.25  * TUBE_SRB_OD;  // Root to edge, perp to body
FIN_HEIGHT     = 1.25  * TUBE_SRB_OD;  // Length along body tube
TIP_HEIGHT     = 0.8   * TUBE_SRB_OD;  // Height of fin edge
NBR_FINS       = 3 ;

FIN_AREA_REQ   = .33333 * MODEL_HEIGHT * TUBE_SRB_OD;
FIN_AREA       = (TIP_HEIGHT * FIN_WIDTH) + (.5*FIN_WIDTH*(FIN_HEIGHT-TIP_HEIGHT)) ;
FIN_AREA_TOTAL = FIN_AREA * NBR_FINS;
 
// ========================
// STATION LOCATIONS
// ========================

Z0              = 0;  // Base of rocket
Z_STAGE1_TOP    = STAGE1_ENGINE_L + STAGE1_L;
Z_STAGE1_I_TOP  = Z_STAGE1_TOP    + STAGE1_I_L;
Z_STAGE2_TOP    = Z_STAGE1_I_TOP  + STAGE2_L;
Z_ADAPTER_TOP   = Z_STAGE2_TOP    + ADAPTER_L; 
Z_CENTAUR_TOP   = Z_ADAPTER_TOP   + CENTAUR_L;
Z_PAF_TOP       = Z_CENTAUR_TOP   + PAF_L;
Z_FAIRING_TOP   = Z_ADAPTER_TOP   + FAIRING_L;
Z_SRB_TOP       = SRB_ENGINE_L    + SRB_LEN_ADJ;

// ========================
// Color
// ========================

color_NA       = [0,0,0,0];     // Do not apply high level color.
color_default  = [1,1,0,1];     // yellow
color_engine   = [.9,.5,.5,.7];
color_nosecone = [1, 1,1,.9];
color_stage1   = [.3,.3,.3,.8];
color_stage1_interstage   = [.3,.3,.3,.7];
color_stage2   = [.4,.4,.4,.8];
color_SRB      = [.5,.5,.5,.6];
color_fairing  = [.4,.4,.4,.5];
color_f_nose   = [1,1,1,.8];
color_centaur  = [0,1,1,.8];
color_recovery = [0,.5,.5,.5];

// =========================
// Tranlate
// =========================

translate_default   = [0,0,0];
translate_cvt_left  = [30,-21,0];
translate_cvt_right = [-31,22,0];

// =========================
// Rotate
// =========================

rotate_default = [0,0,0];

// =========================
// Scale
// =========================

scale_default = [1,1,1];
scale_cv      = [1.2,1.2,1.2];

// =========================
// Offsets
// =========================

nosecone_offset   = Z_ADAPTER_TOP  + new_fairing_l;
cvt_z_offset      = 50;
fwd_conn_z_offset = -10;  // Forward tube connector offset

SRB_x   = (TUBE_MAIN_OD/2 + TUBE_SRB_OD/2) + 7;
SRB_y   = 0;
CORE_x  = 0;

// =====================
// Interstage nesting
// =====================

stage1_2_interstage = 30.1;
centaur_z_nest      = -3;
stage2_z_nest       = -35;
voyager_z_nest      = -18;

// ==============================================
// Stacking key values
// Keeps individual parts from rotating around
// ==============================================

key_height      = 3;
key_disc_height = 3;
key_pin_od      = 2;

// NOTE - Items are: component name, translate, scale, color
components = [


// ### Internal items inside of tubes
   "INT_voyager",      [0, 0, (Z_PAF_TOP+voyager_z_nest)],   scale_cv, color_NA,
   "INT_paf",          [0, 0, (Z_CENTAUR_TOP)],              scale_default, color_default,
   "INT_centaur",      [0, 0, Z_ADAPTER_TOP+centaur_z_nest], scale_default, color_NA,
   "INT_SRB_left",     [-SRB_x, SRB_y, Z0],                  scale_default, color_NA,
   "INT_SRB_right",    [SRB_x,  SRB_y, Z0],                  scale_default, color_NA,
   "INT_stage1",       [0, 0, STAGE1_ENGINE_L+12],              scale_default, color_default,
   "INT_stage2",       [0, 0, Z_STAGE1_I_TOP+stage2_z_nest+11], scale_default, color_default,

// ### Core

   "CORE_f_nosecone",        [0, 0, nosecone_offset], scale_default, color_f_nose,
   "CORE_adapter",           [0, 0, Z_STAGE2_TOP],    scale_default, color_default,
   "CORE_fairing",           [0, 0, Z_ADAPTER_TOP],   scale_default, color_fairing,
   "CORE_stage2",            [0, 0, Z_STAGE1_I_TOP],  scale_default, color_stage2,
   "CORE_stage1_body",       [0, 0, STAGE1_ENGINE_L], scale_default, color_stage1,
   "CORE_stage1_interstage", [0, 0, Z_STAGE1_TOP],    scale_default, color_stage1_interstage,
   "CORE_stage1_engines",    [0, 0, Z0],              scale_default, color_NA,

// ### SRB - Solid Rocket Boosters  

   "SRB_left",         [-SRB_x, SRB_y, Z0], scale_default, color_NA,
   "SRB_right",        [SRB_x,  SRB_y, Z0], scale_default, color_NA,

// ### External items on outside of tubes

   "EXT_SRB_left",     [-SRB_x, SRB_y, STAGE1_ENGINE_L],      scale_default, color_default,
   "EXT_SRB_right",    [SRB_x,  SRB_y, STAGE1_ENGINE_L],      scale_default, color_default,
   "EXT_fwd",          [0,0,Z_SRB_TOP+fwd_conn_z_offset],     scale_default, color_default,
   "EXT_mid",          [0,0,SRB_L/2],                         scale_default, color_default,
   "EXT_aft",          [0,0,STAGE1_ENGINE_L],                 scale_default, color_default,
   "EXT_cvt_left",     [30,-21,STAGE1_ENGINE_L+cvt_z_offset], scale_default, color_default,
   "EXT_cvt_right",    [-31,22,STAGE1_ENGINE_L+cvt_z_offset], scale_default, color_default,

// ## Other
//   "ruler",            [0, 50, Z0], scale_default, color_default,

   ];

module make_component(component) {
    
    // ### Core ###
    
    if(component == "CORE_f_nosecone")     make_CORE_fairing_nosecone();    
    if(component == "CORE_fairing" )       make_CORE_fairing();
    if(component == "CORE_adapter" )       make_CORE_adapter();
    if(component == "CORE_stage2" )        make_CORE_stage2();
    if(component == "CORE_stage1_body")    make_CORE_stage1();
    if(component == "CORE_stage1_interstage")  make_CORE_stage1_interstage();
    if(component == "CORE_stage1_engines") make_CORE_stage1_engines();

    // ### SRB ###
    
    if(component == "SRB_left")       make_SRB(is_left=true);
    if(component == "SRB_right")      make_SRB();

    // ### Internal ###
    
    if(component == "INT_SRB_left")   make_INT_SRB();
    if(component == "INT_SRB_right")  make_INT_SRB();

    if(component == "INT_stage1")     make_INT_stage1();
    if(component == "INT_stage2" )    make_INT_stage2();

    if(component == "INT_centaur")    make_INT_centaur();
    if(component == "INT_voyager")    make_INT_voyager();
    if(component == "INT_paf")        make_INT_PAF();
    
    // ### External Items ###

    if(component == "EXT_SRB_left")   make_EXT_SRB(is_left=true);
    if(component == "EXT_SRB_right")  make_EXT_SRB(is_left=false);

    if(component == "EXT_fwd")        make_EXT_fwd(); // Top (forward)
    if(component == "EXT_mid")        make_EXT_mid(); // Middle
    if(component == "EXT_aft")        make_EXT_aft(); // Bottom
    if(component == "EXT_cvt_left")   make_EXT_cvt();
    if(component == "EXT_cvt_right")  make_EXT_cvt();
   
    // ### Other ###

    //if(component == "ruler")      cube([10,10,MODEL_HEIGHT]);
}


// ========================
// Main Items
// ========================

module make_CORE_fairing_nosecone(){
   
   translate([0,0,-ADAPTER_INSET]) make_biconic_nosecone(
      height       = FAIRING_NOSE_L,
      od_shoulder  = TUBE_FAIRING_ID,
      shoulder_len = ADAPTER_INSET,
      od_1         = TUBE_FAIRING_OD,
      od_2         = 51,
      od_3         = 10,
      solid        = false,
      porthole     = false,
      thickness    = 2);
}

module make_CORE_fairing(){
   make_tube(TUBE_FAIRING_ID, TUBE_FAIRING_OD, new_fairing_l);
}

module make_CORE_adapter(){

   if(DEBUG==true) echo("DEBUG - make_CORE_adapter",
      main_id=TUBE_MAIN_ID,main_od=TUBE_MAIN_OD,faring_id=TUBE_FAIRING_ID,fairing_od=TUBE_FAIRING_OD,
      shoulder=ADAPTER_INSET);
   make_tube_adapter(TUBE_MAIN_ID,TUBE_MAIN_OD,TUBE_FAIRING_ID,TUBE_FAIRING_OD,
   transition_height=ADAPTER_L,shoulder_height=ADAPTER_INSET,solid=false);
}

module make_CORE_stage1(){
  make_tube(TUBE_MAIN_ID, TUBE_MAIN_OD, STAGE1_L);
}

module make_CORE_stage1_interstage(){
  make_tube(TUBE_MAIN_ID, TUBE_MAIN_OD, STAGE1_I_L);
}

module make_CORE_stage2(){
  make_tube(TUBE_MAIN_ID, TUBE_MAIN_OD, STAGE2_L);
}

module make_CORE_stage1_engines(b_make_parts=false) {

   if(b_make_parts) echo("## NOTE ##- make_CORE_stage1_engine() - part plane (z) = ",STAGE1_ENGINE_L);
   
    // Engine Skirt
    color([.5,.5,.5,1]) translate([0,0,STAGE1_ENGINE_L]) rotate([180,0,0])
    linear_extrude(height=ENGINE_SKIRT_L,scale=.8,slices=20){

        difference(){
            circle(d=TUBE_MAIN_OD);
            circle(d=TUBE_MAIN_OD-3);
            translate([19,0,0]) square([10,31],center=true);
            translate([-19,0,0]) square([10,31],center=true);
        }
        translate([14.6,0,0]) square([1.2,31],center=true);
        translate([-14.6,0,0]) square([1.2,31],center=true);
    }
    
    // Rocket Nozzels
    color([0,0,0,1]){
       translate([0,9,0]){
         make_rocket_motor(od_top=10,od_bottom=15, height = STAGE1_ENGINE_L,thickness=3);
         t_z(STAGE1_ENGINE_L-2) cylinder(h=2,d=15);
       }
       translate([0,-9,0]){
         make_rocket_motor(od_top=10,od_bottom=15, height = STAGE1_ENGINE_L,thickness=3);
         t_z(STAGE1_ENGINE_L-2) cylinder(h=2,d=15);
       }
    }
    
    part_seperation = b_make_parts ? [0,0,STAGE1_ENGINE_L+.1] : [0,0,STAGE1_ENGINE_L];
 
 // Plug insert into tube
    color([1,1,1,1]) translate(part_seperation){ 
      
      difference(){
         cylinder(h=12.5,d=TUBE_MAIN_ID);
         translate([4,0,10]) cylinder(h=key_height,d=key_pin_od);
         translate([-4,0,10]) cylinder(h=key_height,d=key_pin_od);
      }
         }

}

module make_SRB(is_left= false,b_nosecone=true,b_body=true,b_engine=true){
    new_SRB_len         = SRB_L - SRB_NOSE_L - SRB_ENGINE_L;
    SRB_body_offset     = SRB_ENGINE_L;
    SRB_nosecone_offset = SRB_body_offset + new_SRB_len;
   
    nozzle_rotate = is_left ? 5 : -5;
    nozzle_offset = is_left ? -2 : 2;
        
    if(b_engine == true)
        difference(){
       union() {
         color([.5,1,1,.8]) translate([nozzle_offset,0,0] ) rotate([0,nozzle_rotate,0]) 
            make_rocket_motor(od_top=TUBE_SRB_OD-10,od_bottom=TUBE_SRB_OD, height = SRB_ENGINE_L-1,thickness=2);
         color([1,1,1,.8]) translate([0,0,SRB_ENGINE_L-10])
            cylinder(h=10,d=TUBE_SRB_OD+2);
       }

       translate([0,0,14]) cylinder(h=14,d=TUBE_SRB_OD);    // Remove to fit OD of tube 
       translate([0,0,-2]) cylinder(h=20,d=TUBE_SRB_OD-10);  // Remove for engine exaxhaust
       }

    if(b_nosecone == true)   
      translate([0,0,SRB_nosecone_offset-NOSECONE_SHOULDER_HEIGHT])
/*
      make_nosecone(
            body_tube_id   = TUBE_SRB_ID,
            body_tube_od   = TUBE_SRB_OD,
            cone_length    = SRB_NOSE_L,
            shape          = "power_series",
            shoulder_len   = NOSECONE_SHOULDER_HEIGHT);
 */ 
      make_shouldered_nosecone(
            shoulder_height = NOSECONE_SHOULDER_HEIGHT,
            shoulder_od     = TUBE_SRB_ID,
            cone_od_1       = TUBE_SRB_OD,
            cone_od_2       = 15,
            cone_height     = SRB_NOSE_L,
            tip_r           = 7.5,
            b_recovery      = true);

    if(b_body == true)
      color(color_SRB) translate([0,0,SRB_ENGINE_L]) make_tube(TUBE_SRB_ID,TUBE_SRB_OD,new_SRB_len);
 
}


// =======================
// Internal Items
// =======================


module make_INT_key_pin(key_disc_od){
      cylinder(h=key_disc_height,d=key_disc_od);
      translate([4,0,key_disc_height]) cylinder(h=key_height,d=key_pin_od);
      translate([-4,0,key_disc_height]) cylinder(h=key_height,d=key_pin_od);
}

module make_INT_key_hole(key_disc_od){
      
   difference(){
      cylinder(h=key_disc_height,d=key_disc_od);
      translate([4,0,-.1]) cylinder(h=key_height+.2,d=key_pin_od+1);
      translate([-4,0,-.1]) cylinder(h=key_height+.2,d=key_pin_od+1);
   }
}

module make_INT_key_hole_in(key_disc_od){
      
   difference(){
      children();
      translate([4,0,-.1]) cylinder(h=key_height+.2,d=key_pin_od+1);
      translate([-4,0,-.1]) cylinder(h=key_height+.2,d=key_pin_od+1);
   }
}

module make_INT_SRB(b_mount=false,b_srb_units=true,num_units=1,b_stuffer_tube=false,b_recovery=false,b_cord_hole=true){
    
    if(b_mount == true)
      estes_pro_style_mount_24mm(body_tube_id=TUBE_SRB_ID,b_seperate_parts=true);
    
    if(b_stuffer_tube == true) 
      make_tube($BT_50_id,$BT_50_od,SRB_L*.475);

    if(b_srb_units == true)
          for(a=[0:num_units-1])
            translate([0,0,SRB_ENGINE_L+(a*SRB_SEG_L) + a*1  ])
            difference(){
               cylinder(h=SRB_SEG_L,d=SRB_SEG_OD);
               t_z(-.1) cylinder(h=SRB_SEG_L+1,d=$BT_50_od); // Exclude stuffer tube
               if(a==num_units-1) translate([SRB_SEG_OD/2-4,0,-.1]) cylinder(h=SRB_SEG_L+1,d=4);  // Exclude cord hole
         } 
    
    if(DEBUG == true)
      echo("DEBUG - make_INT_SRB()::srb_unit",srb_seg_od=SRB_SEG_OD,srb_seg_len=SRB_SEG_L,stuffer_od=$BT_50_od);
    

    // Recovery placeholder
    if(b_recovery == true)
      color(color_recovery) t_z(165) cylinder(h=80,d=  TUBE_SRB_ID);
      
} 

module make_INT_stage1(b_bottom_tank=true,b_top_tank=true,b_fuel_line=true){

   stage1_tank_l = (STAGE1_L ) / 2;
   window_l      = .7 * stage1_tank_l;
   window_d      = 30;
   offset        = (stage1_tank_l - window_l + window_d) / 2;
   
   // Bottom Tank
   if(b_bottom_tank==true){
      difference() {
         make_tank(TUBE_MAIN_ID,stage1_tank_l,2);
         make_rounded_vertical_hull(offset,window_l,window_d);
      }
      t_z(stage1_tank_l-key_disc_height) make_INT_key_pin(TUBE_MAIN_ID/2);
      make_INT_key_hole(TUBE_MAIN_ID/2);

      // Fuel Passthrough
      if(b_fuel_line==true)
         make_tube(2,3,100);
   }
   
   
   // Top Tank
   if(b_top_tank==true){
      translate([0,0,stage1_tank_l])
         difference(){
            make_tank(TUBE_MAIN_ID,stage1_tank_l,2);
            make_rounded_vertical_hull(offset,window_l,window_d);
         }
      t_z(stage1_tank_l*2-key_disc_height) make_INT_key_pin(TUBE_MAIN_ID/2);
      t_z(stage1_tank_l) make_INT_key_hole(TUBE_MAIN_ID/2);
   }
}

module make_INT_stage2(){
 
   id          = TUBE_MAIN_ID;
   od          = TUBE_MAIN_OD;
   height      = STAGE2_L;
   nbr_engines = 1;
   solid       = false;
   isEndcap    = false;
   
   nozzle_height    = od/2;
   nozzle_bottom_od = od/5;
   nozzle_top_od    = 5;

   detail_height    = .3;
    
   bulkhead_height = od/5;
   main_height = height -  bulkhead_height*2;

   echo("make_INT_stage2(): ",height=height,main_height=main_height,bh=bulkhead_height,nh=nozzle_height);
    
    shoulder_height = 10;
    
    // Station Locations along z-axis
    z_0 = 0;
    z_top_nozzle   = z_0 + nozzle_height;
    z_top_bulkhead = nozzle_height+bulkhead_height;
    z_top_main     = z_top_bulkhead + main_height;

    make_stage_bottom(id,od,shoulder_height,nbr_engines,
        nozzle_top_od,nozzle_bottom_od,nozzle_height,bulkhead_height,solid,isEndcap);
    //make_stage_body(id,od,nozzle_height,bulkhead_height,main_height,detail_height,solid);
    t_z(-3) make_stage_top(id,od,shoulder_height,bulkhead_height,z_top_main,solid,isEndcap);

echo("make_INT_stage2()",stage2_l=STAGE2_L);
   

   tank_l  = (STAGE2_L ) / 2.25;
   tank_od = TUBE_MAIN_ID;
    
   // LOX is on top and RP1 is the bottom tank
   t_z(tank_l-15){
      difference(){
         make_tank(tank_od,tank_l,2);
         make_rounded_vertical_hull(20,25,20);
      }
   t_z(tank_l-3) make_INT_key_hole(TUBE_MAIN_ID/2);
   t_z(tank_l+0) make_INT_key_hole(TUBE_MAIN_ID/2);

   }   
      
   t_z(25) make_tube(2,3,47); // fuel pass through
    
   translate([0,0,tank_l*2-15]) 
      difference(){
         make_tank(tank_od,tank_l,2);
         make_rounded_vertical_hull(20,25,20);
      }
      
   // Keys
   make_INT_key_hole(TUBE_MAIN_ID/2);
   //tz() make_INT_key_hole(TUBE_MAIN_ID/2);
   
}

module make_INT_centaur(b_inner_tank=false,b_inner_bulkhead=true,b_bottom=true,b_body=true,b_top=true){

   id          = TUBE_CENTAUR_ID;
   od          = TUBE_CENTAUR_OD;
   height      = CENTAUR_L;
   nbr_engines = 2;
   solid       = false;
   isEndcap    = true;
   
   nozzle_height    = od/2;
   nozzle_bottom_od = od/5;
   nozzle_top_od    = 5;

   detail_height    = .3;
    
   bulkhead_height = od/5;
   main_height = height -  nozzle_height - bulkhead_height*2;

   echo("make_INT_stage2(): ",height=height,main_height=main_height,bh=bulkhead_height,nh=nozzle_height);
    
    shoulder_height = 10;
    
    // Station Locations along z-axis
    z_0 = 0;
    z_top_nozzle   = z_0 + nozzle_height;
    z_top_bulkhead = nozzle_height+bulkhead_height;
    z_top_main     = z_top_bulkhead + main_height;
    
   
   if(b_inner_tank){
      // Common inner tank with viewport cuts
      difference() {
         color([0,.5,.5,.5]) t_z(26) make_tank(id-5,height*.8,2);
         translate([0,50,75]) rotate([90,0,0]) scale([.75,1,1]) cylinder(h=100,d=40);
         translate([-50,0,75]) rotate([90,0,90]) scale([.75,1,1]) cylinder(h=100,d=40);
      }
   }
   
   if(b_inner_bulkhead){
      // Common insulated bulkhead (for inner tank) seperating LH2 from LOX
      t_z(65){
         scale([1,1,.4]) make_hollow_hemisphere(id+1,thickness=2,top=true);
         t_z(-34) make_tube(1,3,48); // Fuel pass through
      }
   }
      
      difference() {
         union(){
            if(b_bottom) 
               make_stage_bottom(id,od,shoulder_height,nbr_engines,nozzle_top_od,nozzle_bottom_od,
               nozzle_height,bulkhead_height,solid,isEndcap);
            if(b_body)   
               make_stage_body(id,od,nozzle_height,bulkhead_height,main_height,detail_height,solid);
            if(b_top) 
               make_stage_top(id,od,shoulder_height,bulkhead_height,z_top_main,solid,isEndcap);
         }
        // viewport cuts 
        translate([0,50,75]) rotate([90,0,0]) scale([.75,1,1]) cylinder(h=100,d=50);
        translate([-50,0,75]) rotate([90,0,90]) scale([.75,1,1]) cylinder(h=100,d=50);
      }
}

module make_INT_PAF(){
   // PAF (Payload Attach Fitting)

   // Proportions in regards to total length of component
   bottom_h = PAF_L * .4;
   middle_h = PAF_L * .4;
   top_h    = PAF_L * .2;
   
   // Bottom Truncated Cone, put key holes to pair up with centaur
   make_INT_key_hole_in()  cylinder(h=bottom_h,d1=20,d2=15);
   
   // Middle Cylinder
   t_z(bottom_h){
      cylinder(h=middle_h,d=15);

      // Top truncated cone
      t_z(middle_h) cylinder(h=top_h,d1=15,d2=5);
      }
}

module make_INT_voyager(){

   HGA_OD = 3.66 * conv;
   BUS_OD = 1.78 * conv;
   BUS_H  = .47  * conv;
   RTG_H  = .508 * conv;
   RTG_OD = .406 * conv;
   MAG_L  = 13   * conv;

   //color([1,1,1,1]) translate([50,0,0]) cube([64,174,29]);

/*   
   // Feed horn supports
   t_z(45){
      for(angle=[0:120:270]){ // Bus to dish support struts
         rotate([180,0,angle]) translate([2,0,0]) rotate([30,30,0]) cylinder(h=15,d=2);
         rotate([180,0,angle]) translate([2,0,0]) rotate([-30,30,0]) cylinder(h=15,d=2);
      }
      cylinder(h=1,d=7);
      cylinder(h=3,d=3);
   }

   // HGA
   t_z(35) make_parabolic_dish();

   // Dish support ring
   t_z(30) cylinder(h=2,d=15);

   // Bus - Electronics section
   t_z(23) {
      cylinder(h=BUS_H,d=BUS_OD,$fn=10);
      //color([1,1,0,1]) translate([0,-8,2]) rotate([90,0,0]) cylinder(h=1,d=5); // Golden Record
      t_z(8) for(angle=[0:90:270]){ // Bus to dish support struts
         rotate([180,0,angle]) translate([4.5,0,0]) rotate([30,30,0]) cylinder(h=5.5,d=2);
         rotate([180,0,angle]) translate([4.5,0,0]) rotate([-30,30,0]) cylinder(h=5.5,d=2);
      }
   }

   // Bus to PAF struts
   t_z(11)
      for(angle=[0:90:270]){
         rotate([0,0,angle]) translate([5,0,0]) rotate([20,-2,0]) cylinder(h=15,d=2);
         rotate([0,0,angle]) translate([5,0,0]) rotate([-20,-2,0]) cylinder(h=15,d=2);
      }
*/
  // RTG
   translate([12,0,8]){
      translate([-7,0,3]) rotate([0,90,0]) cylinder(h=9,d=1);
      translate([-7,0,16]) rotate([0,90,0]) cylinder(h=7,d=1);
      cylinder(h=27,d=1.5);
      cylinder(h=1,d=RTG_OD*1.5);
      cylinder(h=RTG_H,d=RTG_OD);
      t_z(RTG_H+1) {
         cylinder(h=RTG_H,d=RTG_OD);
         t_z(RTG_H+1) cylinder(h=RTG_H,d=RTG_OD);
      }
   }

   // Lattice - Sensors and such
   rotate([0,3,0]) translate([-13,0,8]){
      translate([-2,0,3])  rotate([0,90,0]) cylinder(h=9,d=1);
      translate([-2,0,15]) rotate([0,90,0]) cylinder(h=9,d=1);
      translate([-2,-2,0])  cube([5,5,5]);
      translate([-2,-1,13]) cube([4,4,4]);
      lattice_tower(length=25, width=2, od_frame=1, od_truss=.5, nbr_sections=5);
      }

}

// ========================
// External Items
// ========================

module make_EXT_SRB(is_left=true){
    make_tail_section_v3_v4("v4",TUBE_SRB_OD,FIN_CAN_L,NBR_FINS,FIN_HEIGHT,FIN_WIDTH,TIP_HEIGHT,FIN_THICKNESS,false,is_left);
} 

module make_EXT_fwd(){
   make_3_tube_coupler(height=10,id=TUBE_MAIN_OD,od=TUBE_MAIN_OD+3,has_lug=true);
}

module make_EXT_mid(){
   make_3_tube_coupler(height=10,id=TUBE_MAIN_OD,od=TUBE_MAIN_OD+3,has_tvc=true);
}

module make_EXT_aft(){

   height=10;
   
   tvc_radius = SRB_TVC_OD/2;
   translate([0,0,55]) {
      translate(translate_cvt_left) fillet_tube(height-5,tvc_radius,tvc_radius+1,tvc_radius+1,chamfer_size=1); // TVC mounts
      translate(translate_cvt_right) fillet_tube(height-5,tvc_radius,tvc_radius+1,tvc_radius+1,chamfer_size=1);// TVC mounts
}
   difference(){ // Need to remove sphere bumps from inside fin can
      make_tube_coupler(height=10,id=TUBE_MAIN_OD,od=TUBE_MAIN_OD+3,has_lug=true);
      translate([SRB_x,0,-5]) cylinder(h=20,d=TUBE_SRB_OD);
      translate([-SRB_x,0,-5]) cylinder(h=20,d=TUBE_SRB_OD);
   }



}

module make_EXT_attachable_fin(){
   make_tapered_fin_attachable(FIN_WIDTH,FIN_HEIGHT,TIP_HEIGHT,TUBE_MAIN_OD,FIN_THICKNESS);
}

module make_EXT_cvt(){
   tolerance = .1;

   
   // side cylinders
   cyl_height = SRB_TVC_L;
   cyl_od     = SRB_TVC_OD-tolerance;
   cyl_nose_l = 10;

   if (DEBUG)
      echo(str("DEBUG-make_EXT_cvt()-"),tolerance=tolerance,height=cyl_height,cyl_od=cyl_od,cyl_nose_l=cyl_nose_l);

   cylinder(d=cyl_od,h=cyl_height);     
   translate([0,0,cyl_height])
      make_shouldered_nosecone(shoulder_height=0,shoulder_od=0,cone_od_1=cyl_od,cone_od_2=cyl_od-5,cone_height=cyl_nose_l,tip_r=4.03);
   translate([0,0,-8]) cylinder(d1=cyl_od-6,d2=cyl_od-2,h=8);
   translate([0,0,-10]) cylinder(d=cyl_od-6,h=5);
}


// ========================
// REPORTING
// ========================

module overview_report(){
   echo("=== CRYSTAL MISSILE SPECIFICATIONS ===");
   echo("Total model height: ", Z_FAIRING_TOP, "mm");
   echo("Motor: 29mm F-class recommended");
   echo("Recovery: Dual deploy recommended");
}

module dimension_report(){
   comp_height = _STAGE1_L + _STAGE2_L + _FAIRING_L ; 

   echo("Dimension Report");
   echo("***************************");
   echo(str("Stage1 - ",_STAGE1_L));
   echo(str("Stage2 - ",_STAGE2_L));
   echo(str("Fairing (Centaur Shroud) - ",_FAIRING_L));
   echo(str(" - Centaur - ",_CENTAUR_L));
   echo(str(" - Nosecone - ",_FAIRING_NOSE_L));
   echo("===========================");
   echo(str("Expected Height (m) - ",_HEIGHT));
   echo(str("Actual Height (m) - ",comp_height));
   echo(str("Deviation (m) - ",_HEIGHT-comp_height));
   echo("***************************");
}

module material_report(){
   echo("Tubes Dimensions Needed");
   echo("***************************");
   echo(str("Core - ",CORE_L," mm"));
   echo(str("Shroud - ",FAIRING_L_ADJ," mm"));
   echo(str("SRB(x2) - ",SRB_LEN_ADJ," mm"));
}

module fin_report(){
   echo("Fin Report");
   echo("***************************");
   echo(fin_can_l=FIN_CAN_L);
   echo(fin_thickness=FIN_THICKNESS);
   echo(fin_height=FIN_WIDTH);  // Root to edge, perp to body
   echo(fin_root=FIN_HEIGHT);   // Length along body tube
   echo(fin_tip=TIP_HEIGHT);    // Height of fin edge
   echo(nbr_fins=NBR_FINS);
   echo(fin_area_req=FIN_AREA_REQ);
   echo(fin_area_actual_each=FIN_AREA);
   echo(fin_area_total=FIN_AREA_TOTAL);
}


// ========================
// Assembly
// ========================

module make_upper(){
   //make_export_component("INT_voyager",true,true,true);
   //make_export_component("CORE_adapter",true,true);
   make_export_component("INT_centaur",true,true);
   //make_export_component("INT_paf",true,true);
   //make_export_component("CORE_fairing",true,true);
   //make_export_component("CORE_f_nosecone",true,true);
}

module make_stage1(){
   make_export_component("INT_stage1",true,true);
   make_export_component("CORE_stage1_body",true,true);
   make_export_component("CORE_stage1_engines",true,true);
}

module make_stage2(){
}

module make_srb(){
   make_export_component("INT_SRB_left",true,true);
  // make_export_component("INT_SRB_right",true,true);
}

module make_connectors(aft=true,fwd=true,mid=true){
   if(fwd)
      make_export_component("EXT_fwd",true,true);
   if(mid)
      make_export_component("EXT_mid",true,true);
   if(aft){
      make_export_component("EXT_aft",true,true);
      make_export_component("EXT_SRB_left",true,true);
      make_export_component("EXT_SRB_right",true,true);
   }
}








