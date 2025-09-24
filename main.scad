include <RocketLib.scad>
include <PolyTube.scad>
include <Nosecone.scad>

// ############################
// MAIN - Define level of detail  
// ############################
      
$fn = 50;

// ############################
// MAIN - DEBUG On/Off ?
// ############################

DEBUG = true;

// ##############################
// MAIN - !! DEFINE TOLERANCE !!
// ##############################

FIT = "SNUG";  // Valid Values: 'TIGHT', 'SNUG', 'LOOSE'

echo("----------------------------------------------------------------");
echo(" #!#!#!#!#! Pay attention, Is this the fit you want ??? -",FIT);
echo("----------------------------------------------------------------");

// ##################################
// Bring in the specific Rocket File
// Need to pre-define tolerance so the
// values in the rocket file will be
// set to the correct tolerance
// ##################################

include <titan_crystal_missile.scad>

// ========================
// MAIN - Display / Export
// ========================

//make_connectors(aft=true,mid=false,fwd=false);
//make_upper();

translate([0,-50,30]) make_model(b_color=true,b_translate=true,b_scale=true);
translate([75,0,12.5])  make_launch_pad();

// Launch Rod stand-in
translate([0,-63/2+17,0]) cylinder(h=700,d=4);

// ----------------
// Helper
// ----------------

module make_export_component(name,b_color=false,b_translate=false,b_scale=false){
   for(idx = [0:4:len(components)-1]){
       _name       = components[idx];
       v_translate = b_translate ? components[idx+1] : translate_default;
       v_scale     = b_scale     ? components[idx+2] : scale_default;
       v_color     = b_color     ? components[idx+3] : color_default;
       
       if(name == _name){
          if(v_color != [0,0,0,0] )
             color(v_color) translate(v_translate) scale(v_scale) make_component(name);
          else
             translate(v_translate) scale(v_scale) make_component(name);
       }
   }
}

module make_model(b_translate=false,b_color=false,b_scale=false){

   for(idx = [0:4:len(components)-1]){
       name        = components[idx];
       v_translate = b_translate ? components[idx+1] : translate_default;
       v_scale     = b_scale     ? components[idx+2] : scale_default;
       v_color     = b_color     ? components[idx+3] : color_default;
  
       if(v_color != [0,0,0,0] )
          color(v_color) translate(v_translate) scale(v_scale) make_component(name);
       else
          translate(v_translate) scale(v_scale) make_component(name);
   }
}


module make_launch_pad(){
   // Main Pad
   cube([400,200,20],center=true);         // Bottom
   t_z(12) cube([420,220,5],center=true);  // Top Plate
   
 
   translate([-205,0,-325]) rotate([90,0,0]) linear_extrude(height=5) import("tower.svg");
 
      
   // Tower
   translate([0,0,15])     cube([20,20,625]); // Left
   translate([-175,0,15])  cube([20,20,625]); // Right
   translate([-175,0,625]) cube([195,20,20]);  // Top


   // Sign
   translate([100,-50,40]) cube([170,25,40],center=true);
   color("black") translate([100,-65,45]) cube([170,1,1],center=true); // Horizontal line
   color("black") translate([100,-65,33]) cube([1,1,25],center=true);  // Vertical line

   
      color("black") translate([35,-65,50]) rotate([90,0,0])
         linear_extrude(height=1)text(text="TITAN / CENTAUR COMPLEX 41",size=6);
      color("black") translate([30,-65,40]) rotate([90,0,0])
         linear_extrude(height=1) text(text="USAF TITAN III-C LAUNCHES",size=3);
      color("black") translate([110,-65,40]) rotate([90,0,0])
         linear_extrude(height=1) text(text="NASA TITAN/CENTAUR LAUNCHES",size=3);
   

}