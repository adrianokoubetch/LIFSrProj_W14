include <z_axis.scad>;
include <../components/5v_stepper_motor.scad>;
vert_drive_rod_length = 180;
vert_static_rod_length = 185;
horz_rod_length = 80;

/*
difference() {
	Z_AXIS_TRANS_STAGE();
	color("cyan") translate([-mount_position-10,0,20]) smooth_rod(10, rod_radius);
}
XY_AXIS_TRANS_STAGE();
	union() {
		tbs_mount_z_axis();
		frame();
	}
*/

module tbs_mount_z_axis() {
	difference() {
		union() {
			translate([-22.5,-12.5,-22.5]) cube([45,25,5]);
			translate([-30,-12.5,23.5]) cube([60,25,5]);
			translate([-30,-12.5,20])cube([7,25,5]);
			translate([23,-12.5,20])cube([7,25,5]);
		}
		translate([17,0,0]) cylinder(h=100,r=3,center=true,$fn=50);
		translate([-17,0,0]) cylinder(h=100,r=3,center=true,$fn=50);
	}
}

module XY_AXIS_TRANS_STAGE() {
	vert_stage();
	color("grey") translate([0,0,97]) rotate([0,90,0]) smooth_rod(horz_rod_length, rod_radius);
	translate([0,0,130]) pinhole();
	translate([-55,0,95]) horz_stage();
	translate([10,37.5,95]) rotate([0,90,0]) tbs_pinhole_axis();
	translate([37.5,37.5,95]) rotate([0,90,0]) horz_drive_shaft_bearing(16,2);
	translate([-48.5,37.5,95]) rotate([0,180,-90]) stepper_motor(shaft=2.5,radius=14,width=19);
	translate([-30,37.5,95]) rotate([0,90,0]) coupler(coupler_dim, 2.5,2.5);
}

module vert_stage(){
	color("grey") translate([mount_position+15,0,200]) rotate([-90,0,-90])  stepper_motor();

	//coupler and rods
	translate([60,0,185]) coupler(coupler_dim, 2.5,2.5);
	color("grey") translate([-mount_position-10,0,100]) smooth_rod(vert_static_rod_length, rod_radius);
	color("grey") translate([60,0,90]) smooth_rod(vert_drive_rod_length, rod_radius);
	union() {
		tbs_mount_z_axis();
		translate([60,0,105]) rotate([0,0,90]) tbs_horz_axis();
		frame();
	}
}

module frame() {
	union() {
		difference() {//top frame
			translate([0,0,190]) cube([250,60,20],center=true);
			translate([60,0,190]) cylinder(r=10,h=25,center=true,$fn=100) //motor shaft hole
			translate([-mount_position-10,0,100]) smooth_rod(vert_static_rod_length, rod_radius); //static shaft hole
			//screw holes
			translate([52,22,180]) cube([7,17,30],center=true);//screw hole +y side
			translate([52,16.5,190]) cylinder(r=2,h=25,center=true,$fn=100); 
			translate([52,-22,180]) cube([7,17,30],center=true);//screw hole -y side
			translate([52,-16.5,190]) cylinder(r=2,h=25,center=true,$fn=100); 
		}
		
		//bottom frame
		translate([0,10,0]) rotate([-90,0,0]) union() {
			//-x mount
			tbs_side_support();

			//+x mount
			difference() {
				rotate([0,0,180]) tbs_side_support();
				translate([mount_position+15,-20,-10]) rotate([90,0,0]) cylinder(h=5.25,r=lin_bearing_od/2,center=true,$fn=100);
			}
			%translate([mount_position+15,-20,-10]) rotate([90,0,0]) bearing(2.5,8);
		}

		//Side support beams
		translate([110,0,100]) cube([30,60,200],center=true);
		translate([-110,0,100]) cube([30,60,200],center=true);
	}

	//private modules
	module tbs_side_support() {
		union() {
			difference() {
				translate([-65.5,0,-15]) cube([85, 45, 15],center=true);
				translate([-rod_spacing,0,0]) cylinder(100,lin_bearing_od/2,center=true,$fn=100);
			}
			translate([-mount_position-2.5,0,-7.5]) cube([50,45,30],center=true);
			translate([-110,0,-10]) cube([30,45,60],center=true);
		}
	}
}

module pinhole() {
	difference() {
		cube([40,10,40],center=true);
		rotate([90,0,0]) cylinder(h=20,r=1,center=true,$fn=100);
	}
}

module horz_stage(lin_bearing_od=16,height=27.5) {
	lin_bearing_or = lin_bearing_od/2;
	union() {
		difference() {//Motor Seat
			difference() {
				translate([-10,35,5]) cube([30,50,height],center=true);
				translate([6.5,37.5,0]) rotate([0,180,-90]) stepper_motor(shaft=2.5,radius=14.5,width=34);
				translate([-5,37.5,17.5]) cube([30,29,20],center=true);
				translate([-10,23,12.5]) cube([20,10,15],center=true);
				translate([-10,52,12.5]) cube([20,10,15],center=true);
				translate([5,21,8]) rotate([0,90,0]) cylinder(h=10,r=2,center=true,$fn=100);
				translate([5,54,8]) rotate([0,90,0]) cylinder(h=10,r=2,center=true,$fn=100);
			}
		}
		difference() {//Linear Bearing Shaft
			difference() {
				translate([-5,0,5]) cube([40,30,height],center=true);
				cylinder(h=90,r=lin_bearing_or,center=true,$fn=100);
				translate([50,0,2]) rotate([0,90,0]) smooth_rod(horz_rod_length, rod_radius);
			}
		}
	}
}

module tbs_pinhole_axis(lin_bearing_od=16) {
	lin_bearing_or=lin_bearing_od/2;
	union() {
		tbs();
		difference() {
			translate([3,-45,-7.5]) cube([40,45,15],center=true);
			translate([-3,-37.5,-10]) cylinder(h=30,r=lin_bearing_or,center=true,$fn=100);
		}
	}
}

module horz_drive_shaft_bearing(bearing_od, screw_size) {
	screw_rad = screw_size/2;
	mount1_pos = 15;
	mount2_pos = 20;
	union() {
		difference() {//Bearing Case
			cube([20,30,10],center=true);
			cylinder(h=40,r=8,center=true,$fn=100);
		}
		difference() {//Mount 1
			
			translate([0,-12.5,mount1_pos]) cube([20,5,30],center=true);
			translate([0,-12.5,mount1_pos+10]) rotate([90,0,0]) cylinder(h=10,r=screw_rad,center=true,$fn=100);
		}
		difference() {//Mount 2
			translate([0,-mount2_pos,-2.5]) cube([20,20,5],center=true);
			translate([0,-mount2_pos-5,0]) cylinder(h=10,r=screw_rad,center=true,$fn=100);
		}
	}
	%bearing(2.5,bearing_od/2);
}

