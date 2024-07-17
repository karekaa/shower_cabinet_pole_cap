// ======================================================================
// Program:    shower_cabinet_pole_cap_mini.scad
//
// Function: OpenSCAD program to define a plastic cap at the top of the
//           aluminium pole holding the shower cabinet together.
//
//           The whole cap is designed up-side-down, to function as a
//           holding base (raft not necessary) on the 3D print plate.
//
// Author:   Kjell Arne Rekaa (kjell.arne.rekaa@gmail.com)
// 
// Date:     2024-07-17
// ======================================================================
// Speed up rendering - low resolution only for preview: 
$fn = $preview ? 32 : 90; 

// Variabler: *******************************************************
mink_dia       = 3;   // Minkowski diameter for rounding edges
profile_thick  = 2;   // The thickness of the «basic» aluminum plate
profile_length = 21;  // Lenght of the profile to cover
profile_width  = 21;  // width of the profile to cover

lid_length = profile_length + 2*profile_thick;
lid_width  = profile_width + 2*profile_thick;
lid_hight  = 3;
hold_box_depth = 15;   // The depth/hight of the inside holding box

// Rutiner: *********************************************************

// The lid (visible outside):
module minkowski_lid(length, width, hight) { // *********************
  difference() { 
      union() {  // Make the outer box with rounded corners:
        minkowski() {
           cube([length, width, hight]); 
           sphere(d=mink_dia); 
        }
      }; // union 
      
      // Cut off upper part of the box:
     // translate([-profile_thick, -profile_thick, lid_hight]) 
     // cube([lid_length, lid_width, lid_hight]);
      
      // Lag hulrom for å legge over profilen:
      translate([0, 0, 0]) 
      cube([profile_length, profile_width, lid_hight*2]);
  } // difference
}


// The box fitting inside the aluminium profile to hold the lid in place:
module holding_box(length, width, hight) { // ***********************
    difference() {
        // The outer box:
        cube([length-profile_thick, width-profile_thick, hight]);
        // Remove the inner box:
        translate ([0.5, 0.5, 0.0]) 
        cube([length-profile_thick-1, width-profile_thick-1, hight+9]);
    }
}


// Main code: *******************************************************
difference() {
    union() {
        minkowski_lid(profile_length, profile_width, lid_hight);
        translate([mink_dia,profile_thick+0.5,0]) 
        holding_box (profile_length-mink_dia, profile_width-mink_dia, hold_box_depth);
    }
    // cutting off the end, which align tight to the next part of total profile:
    translate([profile_length,-mink_dia,0]) 
    cube([profile_width,profile_width+mink_dia+2,lid_hight*2]);
}