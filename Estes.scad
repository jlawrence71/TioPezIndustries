include <ThreadLib.scad>
include <BOSL/constants.scad>
use <BOSL/threading.scad>
use <BOSL/shapes.scad>

// There are standard estes tubes in mm.
// Note some are engine tubes as well (Marks with ###)

// ***************************
// *** Standard Body Tubes ***
// ***************************

    $BT_5_id   = 13.2;   $BT_5_od   = 13.8;  // ###(13 mm motors - ½A3, A10, etc.) Small rockets, micromaxx adaptors
    $BT_20_id  = 18.0;   $BT_20_od  = 18.7;  // ###(18 mm motors - A8, B6, C6 ) Engine mount for 18 mm motors (A–C)
    $BT_30_id  = 19.5;   $BT_30_od  = 20.1;  // Rare, transitional
    $BT_50_id  = 24.1;   $BT_50_od  = 25.1;  //24.8;  // ###(24 mm motors - C11, D12, E12, etc.) Engine mount for 24 mm motors (D/E), also used as main airframes
    $BT_52H_id = 29.0;   $BT_52H_od = 30.7;  // ###(29 mm motors - Estes E16, F15, and Aerotech 29 mm composites)
    $BT_55_id  = 33.7;   $BT_55_od  = 34.3;  // Widely used body size. Used as “stuffer tubes” as well
    $BT_56_id  = 40.5;   $BT_56_od  = 41.6;  // Custom size, close to BT-60 ( "Transitional")
    $BT_60_id  = 40.5;   $BT_60_od  = 41.6;  // Very common for larger rockets
    $BT_70_id  = 55.2;   $BT_70_od  = 56.3;  // Big kits, Saturn 1B
    $BT_80_id  = 65.0;   $BT_80_od  = 66.0;  // ###(Can hold 2 × 24 mm or 1 × 29 mm cluster) Large kits, Estes Saturn V.  

// ****************************
// *** Engine Configuration ***
// ****************************

    $estes_mini_len = 45;
    $estes_mini_od  = 13;

    $estes_standard_len = 70;
    $estes_standard_od  = 18;

    $estes_medium_len = 70;
    $estes_medium_od  = 24;
    
    $estes_E_len     = 95;
    $estes_E_od      = 24;

    $estes_F_len     = 114;
    $estes_F_od      = 29;

// ---------    
// Tests
// ---------    

//estes_pro_style_mount_18mm(41.5);

// ------------
// API
// ------------
    
module estes_pro_style_mount_13mm(body_tube_id=40){
    _estes_pro_style_mount(
        body_tube_id   = body_tube_id, 
        tooth_height   = tooth_height,
        engine_tube_od = $BT_5_od,
        engine_od      = $estes_mini_od
        );}

module estes_pro_style_mount_18mm(body_tube_id=40){
    _estes_pro_style_mount(
        body_tube_id   = body_tube_id, 
        tooth_height   = tooth_height,
        engine_tube_od = $BT_20_od,
        engine_od      = $estes_standard_od
        );
}

module estes_pro_style_mount_24mm(body_tube_id=40,b_seperate_parts){
    _estes_pro_style_mount(
        body_tube_id   = body_tube_id, 
        tooth_height   = 1.5,
        engine_tube_od = $BT_50_od,
        engine_od      = $estes_medium_od,
        b_seperate_parts = b_seperate_parts
        );
}

module estes_pro_style_mount_29mm(body_tube_id=40){
    _estes_pro_style_mount(
        body_tube_id   = body_tube_id, 
        tooth_height   = tooth_height,
        engine_tube_od = $BT_52H_od,
        engine_od      = $estes_F_od
        );}
    
module _estes_pro_style_mount(body_tube_id=40,tooth_height=0,engine_tube_od=24.9,engine_od=24,b_seperate_parts=false){

// -----------------------------
// Constants & Calculations
// -----------------------------

$fn=75;

num_bumps          = 25;
cap_height         = 10;
thread_height      = 7.5;
center_ring_height = 7.5;
thread_pitch       = 2;
tooth_height       = tooth_height;

od_screw           = engine_od+5;
od_cap             = od_screw+5;
radius             = (od_cap)/2;
adapter_height     = center_ring_height + thread_height;

// -----------------------------
// Engine tube threaded adapter
// -----------------------------

translate([0,0,cap_height+thread_height]) rotate([180,0,0]) difference(){
    union(){
        cylinder(h=center_ring_height,d=body_tube_id,center=false);
        translate([0,0,center_ring_height-.1]) RodStart(0,0,thread_height,od_screw,thread_pitch,tooth_height=tooth_height);
    }
    translate([0,0,-2]) cylinder(h=adapter_height,d=engine_tube_od); // Tube backstop
    translate([0,0,-.1])  cylinder(h=adapter_height+1,d=engine_od);  // Engine passage
}

// -----------------------------
// Endcap retainer
// -----------------------------

part_seperation = b_seperate_parts ? [50,0,0] : [0,0,0];

translate(part_seperation){

difference() { // ScrewHole
ScrewHole(outer_diam   = od_screw,    // Make a threaded hole...
          height       = cap_height,
          position     = [0, 0, cap_height+2],
          rotation     = [180,0,0], 
          pitch        = thread_pitch,
          tooth_angle  = 30,
          tolerance    = 0.4,
          tooth_height = tooth_height)

   difference(){ // Engine exhaust port       
   union(){ // ... into this
    cyl(d=od_cap,l=cap_height-.1,fillet1=1,center=false);
        for (i = [0:num_bumps-1]) {
            angle = 360/num_bumps * i;
            rotate(a=angle,v=[0,0,1]) translate([radius-.1,0,1]) 
               cylinder(d=1,h=cap_height-1.1);
        }
    } // union
    translate([0,0,-.1]) cylinder(d=engine_od-2,h=cap_height+1);

} // difference - Engine exhaust port
} // difference - ScrewHole
} // translate  - part seperation
} // module    

// ================================================
// Estes Model Rocket Engine Reference - Chat GPT
// ================================================

// This file provides quick-reference stats for Estes black powder (BP) rocket motors.
// These values are approximate, based on NAR certification data and Estes specifications.
// 
// ------------------------------------------------------------
// Key Parameters Explained
// ------------------------------------------------------------
// - Diameter × Length: Physical size of motor casing (in mm)
// - Total Impulse (Ns): Integrated thrust over burn duration, defines motor class letter
// - Average Thrust (N): Approximate steady thrust during burn
// - Peak Thrust (N): Maximum instantaneous thrust spike
// - Burn Time (s): Duration of thrust production
// - Propellant Mass (g): Mass of black powder fuel
// - Total Weight (g): Complete motor mass (casing, nozzle, fuel)
// - Ejection Charge (g): Black powder for parachute deployment
// 
// ------------------------------------------------------------
// 13 mm "Mini Engines"
// ------------------------------------------------------------
// Motor   Size(mm)   Total Impulse(Ns)   Avg Thrust(N)   Burn(s)   Propellant(g)   Weight(g)
// 1/2A3   13x45      0.62                ~2.5            0.25      1.1             5.6
// A3      13x45      1.26                ~2.5            0.50      2.5             6.9
// A10     13x45      2.50                ~10             0.25      2.8             7.6
// 
// ------------------------------------------------------------
// 18 mm "Standard Engines"
// ------------------------------------------------------------
// Motor   Size(mm)   Total Impulse(Ns)   Avg Thrust(N)   Burn(s)   Propellant(g)   Weight(g)
// 1/2A6   18x70      0.62                ~5              0.12      2.0             7.5
// A8      18x70      2.50                ~3              0.90      3.1             8.0
// B4      18x70      5.00                ~4.5            1.10      6.6             17
// B6      18x70      5.00                ~5              0.90      5.6             15
// C6      18x70      10.0                ~6              1.60      12              25
// 
// ------------------------------------------------------------
// 24 mm "D Class Engines"
// ------------------------------------------------------------
// Motor   Size(mm)   Total Impulse(Ns)   Avg Thrust(N)   Burn(s)   Propellant(g)   Weight(g)
// C11     24x70      10.0                ~11             0.90      12              25
// D12     24x70      20.0                ~12             1.60      20              43
// E12     24x95      30.0                ~12             2.50      24              43
// 
// ------------------------------------------------------------
// 29 mm "Mid-Power BP Engines"
// ------------------------------------------------------------
// Motor   Size(mm)   Total Impulse(Ns)   Avg Thrust(N)   Burn(s)   Propellant(g)   Weight(g)
// E16     29x95      30.0                ~16             1.90      26              55
// F15     29x95      50.0                ~15             3.30      40              65
// 
// ------------------------------------------------------------
// Safety Protocols for Ignition
// ------------------------------------------------------------
// - Always launch with an electrical controller equipped with a removable safety key
// - Ensure controller and leads can deliver at least 2 amps (12V recommended for C and higher)
// - Never attempt to ignite motors with matches, lighters, or weak batteries
// - For clusters or E/F motors, use a power source capable of reliable simultaneous ignition
// 
// ------------------------------------------------------------
// Use of Stats in Calculations
// ------------------------------------------------------------
// 1. Thrust-to-Weight Ratio (T/W):
//    T/W = Peak Thrust (N) ÷ Rocket Weight (N)
// 
// 2. Velocity off Launch Rod:
//    V = Integral[(Thrust - Drag - Weight) ÷ Mass] over Burn Time
// 
// 3. Altitude Estimate:
//    Approx = (Total Impulse × Motor Efficiency) ÷ (Rocket Mass × g)
//    More precise = use OpenRocket simulations with actual Cd, fin, and nosecone data.
// 
// ------------------------------------------------------------