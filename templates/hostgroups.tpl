Hostgroups:
============

+-----------------------------------------+
#for $h in $HOSTGROUPS:
    $h["groupid"] | $h["name"] | Hosts: $len($h["hosts"]) | Templates: $len($h["templates"])
#end for
+-----------------------------------------+