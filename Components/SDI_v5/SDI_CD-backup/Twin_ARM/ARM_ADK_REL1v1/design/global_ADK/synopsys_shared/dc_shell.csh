#!/bin/csh -f

while ("1")
  dc_shell $*
  set dc_status = $status
  if ("$dc_status" == "255") then
    echo "Sleeping..."
    sleep 10
  else
    exit $dc_status
  endif
end

  
