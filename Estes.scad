// There are standard estes tubes in mm.
// Note some are engine tubes as well (Markes with ###)

// ***************************
// *** Standard Body Tubes ***
// ***************************

    BT_5_id   = 13.2;   BT_5_od   = 13.8;  // ###(13 mm motors - ½A3, A10, etc.) Small rockets, micromaxx adaptors
    BT_20_id  = 18.0;   BT_20_od  = 18.7;  // ###(18 mm motors - A8, B6, C6 ) Engine mount for 18 mm motors (A–C)
    BT_30_id  = 19.5;   BT_30_od  = 20.1;  // Rare, transitional
    BT_50_id  = 24.1;   BT_50_od  = 24.8;  // ###(24 mm motors - C11, D12, E12, etc.) Engine mount for 24 mm motors (D/E), also used as main airframes
    BT_52H_id = 29.0;   BT_52H_od = 30.7;  // ###(29 mm motors - Estes E16, F15, and Aerotech 29 mm composites)
    BT_55_id  = 33.7;   BT_55_od  = 34.3;  // Widely used body size. Used as “stuffer tubes” as well
    BT_56_id  = 40.5;   BT_56_od  = 41.6;  // Custom size, close to BT-60 ( "Transitional")
    BT_60_id  = 40.5;   BT_60_od  = 41.6;  // Very common for larger rockets
    BT_70_id  = 55.2;   BT_70_od  = 56.3;  // Big kits, Saturn 1B
    BT_80_id  = 65.0;   BT_80_od  = 66.0;  // ###(Can hold 2 × 24 mm or 1 × 29 mm cluster) Large kits, Estes Saturn V.  

// ****************************
// *** Engine Configuration ***
// ****************************

    $estes_mini_len = 45;
    $estes_mini_dia = 13;

    $estes_standard_len = 70;
    $estes_standard_dia = 18;

    $estes_medium_len = 70;
    $estes_medium_dia = 24;
    
    $estes_E_len     = 95;
    $estes_E_dia     = 24;

    $estes_F_len     = 114;
    $estes_F_dia     = 29;

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