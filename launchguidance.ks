// High TWR Ascent Guidance System

//To-Do List
//function doApoapsisMaintain

function main {
  doLaunch().
  doAscent().
  until apoapsis > 100000 {
    doAutoStage().
  }
  // until alt:radar > 70000 {
  //   doApoapsisMaintain(). // fix it, it wont shut down after we reach 100k apoapsis
  // }
  doShutdown().
  wait until false.
}

function doApoapsisMaintain{



}

function doAscent{
  local myVessel is ship.
  local vesselAltitude is myVessel:altitude.
  lock targetPitch to 90.
  lock targetDirection to 90.
  lock steering to heading(targetDirection, targetPitch).


  // Pitches to 45 degrees by the time surface speed is 100m/s
  when myVessel:altitude < 8000 then {
    print "Beginning phase 1 of ascent.".
    until myVessel:airspeed >= 100 {
      lock targetPitch to -0.000802695 * myVessel:airspeed^2 - 0.38276 * myVessel:airspeed + 90.1954.
      print "Target Pitch: " + targetPitch.
    }
    print "Phase 1 of ascent complete. Cruising to 8km.".
    lock targetPitch to 45.
  }

  when myVessel:altitude >= 8000 and myVessel:altitude <= 30000 then {
    print "Beginning phase 2 of ascent.".
    until myVessel:altitude >= 30000 {
      lock targetPitch to 8.83112E-8 * myVessel:altitude^2 - 0.00526105 * myVessel:altitude + 83.9402.
      if targetPitch > 45 {
        lock targetPitch to 45.
      }
      //print "Target Pitch: " + targetPitch.
      //print "Error: Angle: " + steeringManager: angleError. //+ " Pitch: " + steeringManager:pitchError + " Yaw: " + steeringManager:yawError + " Roll: " + steeringManager:rollError.
    }
    print "Phase 2 of ascent complete. Cruising to 100km apoapsis.".
    lock steering to prograde.

  }
  
}

function doLaunch {
  print "Launching in 3!".
  
  wait 1.
  print " ... 2!".
  rcs off.
  sas off.
  print "Systems locked, guidance engaged!".
  wait 1.
  print " ... 1!".
  print "Throttle to Maximum!".
  lock throttle to 1.
  wait 1.
  print "Launch!".
  doSafeStage().
    print "We have lift off!".
}

function doAutoStage {
  if not(defined oldThrust) {
  declare global oldThrust to ship:avaiLablethrust.
  }
  if ship:avaiLablethrust < (oldThrust - 10) {
    doSafeStage(). 
    wait 1.
    declare global oldThrust to ship:avaiLablethrust.
  }
}

function doSafeStage {
  wait until stage:ready.
  stage.
}

function doShutdown {
  lock throttle to 0.
  lock steering to prograde.
  }

main().
