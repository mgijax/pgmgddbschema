#!/bin/csh -f

# Remove log files

cd `dirname $0` && source ./Configuration

foreach i (default index key partition procedure table trigger view)
    rm ./logs/$i/*.log
end
