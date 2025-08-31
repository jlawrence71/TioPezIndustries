//
// Titan IIIE / Centaur (Voyager-1) — Rough Parametric Scaffold
// Coordinate convention: +Z is UP (stacking axis)
// Units: meters
//

// ---------- Top-level toggles ----------
SHOW_SRM      = true;   // show UA1205 pair
SHOW_CENTAUR  = true;
SHOW_STAGE2   = true;
SHOW_STAGE1   = true;
SHOW_FAIRING  = true;

// ---------- Core diameters (10 ft / 3.05 m class) ----------
D_core    = 3.05;           // Titan core + fairing class diameter
R_core    = D_core/2;

// ---------- Lengths (m) ----------
L_stage1  = 22.28;          // Titan Stage I
L_stage2  = 9.85;           // Titan Stage II
L_centaur = 9.10;           // Centaur D-1T
// Effective fairing length chosen to hit overall 48.8 m
L_fairing = 48.8 - (L_stage1 + L_stage2 + L_centaur);   // ~7.57 m

// ---------- Strap-on SRMs (UA1205) ----------
D_srm       = 3.05;         // 120-inch class
R_srm       = D_srm/2;
L_srm       = 25.91;        // length of each UA1205
SRM_clear   = 0.30;         // lateral clearance between core & SRM
SRM_x_off   = R_core + SRM_clear + R_srm;  // offset in X
SRM_z_base  = 0;            // bottom aligned with Stage I base (Z=0)

// ---------- Stations (Z=0 at Stage I base) ----------
Z0_stage1   = 0;
Z0_stage2   = Z0_stage1 + L_stage1;         // 22.28
Z0_centaur  = Z0_stage2 + L_stage2;         // 32.13
Z0_fairing  = Z0_centaur + L_centaur;       // 41.23
Z_tip       = Z0_fairing + L_fairing;       // 48.80

// ---------- Simple visual detailing ----------
interstage_lip = 0.15;      // small ring lip thickness (along Z)
interstage_gap = 0.02;      // tiny inset to visually separate segments

// ---------- Helpers ----------
module band(d, t=0.01, h=interstage_lip) {
    color([0.75,0.75,0.75]) difference() {
        cylinder(h=h, r=d/2 + t, $fn=96);
        cylinder(h=h+0.001, r=d/2, $fn=96);
    }
}

// ---------- Major components ----------
module stage(name, d, L, body_color=[0.55,0.55,0.60]) {
    color(body_color) cylinder(h=L, r=d/2, $fn=96);
}

module titanstage1() { stage("Stage I", D_core, L_stage1, [0.55,0.60,0.70]); }
module titanstage2() { stage("Stage II", D_core, L_stage2, [0.60,0.65,0.75]); }
module centaur()     { stage("Centaur",  D_core, L_centaur, [0.70,0.75,0.85]); }

module fairing_rough(d=D_core, L=L_fairing, tip_round=0.25) {
    skirt_L = min(0.6, max(0.2, L*0.10)); // ~10% skirt
    cone_L  = max(0, L - skirt_L - tip_round);

    // skirt
    color([0.85,0.85,0.90]) cylinder(h=skirt_L, r=d/2, $fn=96);
    // cone
    tip_r = 0.06 * d; // small residual tip radius
    color([0.85,0.85,0.90])
        translate([0,0,skirt_L])
        cylinder(h=cone_L, r1=d/2, r2=tip_r, $fn=96);
    // rounded tip
    if (tip_round > 0 && cone_L > 0)
        translate([0,0,skirt_L + cone_L])
            sphere(r=tip_round, $fn=96);
}

// ---------- SRMs ----------
module srm() {
    color([0.60,0.60,0.60]) cylinder(h=L_srm, r=R_srm, $fn=96);
    // simple nozzle skirt
    color([0.40,0.40,0.45]) cylinder(h=0.5, r1=R_srm*0.65, r2=R_srm*0.85, $fn=64);
}

module srm_pair() {
    // left
    translate([ -SRM_x_off, 0, SRM_z_base]) srm();
    // right
    translate([  SRM_x_off, 0, SRM_z_base]) srm();
}

// ---------- Assembly ----------
module titan_IIIE_centaur() {
    // Stage I
    if (SHOW_STAGE1) {
        translate([0,0,Z0_stage1]) titanstage1();
        translate([0,0,Z0_stage2 - interstage_gap]) band(D_core, t=0.006, h=interstage_lip);
    }

    // Stage II
    if (SHOW_STAGE2) {
        translate([0,0,Z0_stage2]) titanstage2();
        translate([0,0,Z0_centaur - interstage_gap]) band(D_core, t=0.006, h=interstage_lip);
    }

    // Centaur
    if (SHOW_CENTAUR) {
        translate([0,0,Z0_centaur]) centaur();
        translate([0,0,Z0_fairing - interstage_gap]) band(D_core, t=0.006, h=interstage_lip);
    }

    // Fairing
    if (SHOW_FAIRING) {
        translate([0,0,Z0_fairing]) fairing_rough(D_core, L_fairing, tip_round=0.20);
    }

    // SRMs
    if (SHOW_SRM) {
        srm_pair();
    }
}

// ---------- Export / scale helpers ----------
module export_scale(ratio=1/100) {
    scale(ratio) titan_IIIE_centaur();
}
module export_mm() {
    // meters to millimeters
    scale(1000) titan_IIIE_centaur();
}

// ---------- Default preview ----------
titan_IIIE_centaur();
