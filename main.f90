! 2015 UCL_CHEM by Serena Viti update by Jon Holdship
! Rewritten for FORTRAN 95 and modulised


PROGRAM uclchem
!everything to do with physics should be stored in a physics module based on physics-template.f90
!UCL_CHEM uses density and temperature in chemical calculations so these MUST be provided, everything else is
!user dependent

USE physics
USE chem
IMPLICIT NONE

!Default parameters.f90 works for MOST physics modules.
!CSHOCK has cshock_parameters.f90
include 'parameters.f90'

!Set up with initial values etc, lives in chem.f90
 CALL phys_initialise
 CALL chem_initialise

!loop over time, tstep limit is arbitrary so that tfin can be reached.
DO tstep=1,20000
    !End if we hit final density or time
    IF (switch .eq. 1 .and. dens >= dfin) THEN
        exit
    ELSEIF (switch .eq. 0 .and. tage >= tfin) THEN
        exit
    ENDIF

    !store current time as starting point for each depth step
    IF (points .gt. 1) THEN
        t0old=tout
        t0=t0old
    END IF
    !update tout
    CALL timestep

    !loop over depth points, counting from edge in to centre
    DO dstep=1,points

        dens=abund(nspec+1,dstep)
        !update physics
        CALL phys_update
        !update chemistry
        CALL chem_update        
        !set time to the final time of integrator rather than target     
        tout=t0
        !reset target for next depth point
        if (points .gt. 1)t0=t0old
        !get time in years for output
        tage=tout*year
        !write this depth step
        CALL output      
    END DO
END DO 
END PROGRAM uclchem


