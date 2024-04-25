BEGIN {first=1}
/^#/ {next}
/SecRule / && !/id:/ && first==1 {
    sub("\" *$", ", id:0\"")
    }
/SecRule / && /chain/ && first==1 {
    sub("id:[0-9]+ *","id:"i"")
    print $0;
    i++;
    first=0
    next}
/SecRule / && /chain/  {
    print "   "$0;
    next}

/SecRule .*\".*\".*\".*\"/ && first {
    sub("\" *$", ",chain\"")
    sub("id:[0-9]+ *","id:"i"")
    print $0;
    print "   SecRule REQUEST_HEADERS:X-Forwarded-Host \""h"\" \"nolog\""
    print ""
    first=1
    i++
    next}

/SecRule / && first {
    sub("$", " \"chain\"")
    sub("id:[0-9]+ *","id:"i"")
    print $0;
    print "   SecRule REQUEST_HEADERS:X-Forwarded-Host \""h"\" \"nolog\""
    print ""
    first=1
    i++
    next}


/SecRule .*\".*\".*\".*\"/ {
    sub("\" *$", ",chain\"")
    print "   "$0;
    print "   SecRule REQUEST_HEADERS:X-Forwarded-Host \""h"\" \"nolog\""
    print ""
    first=1
    next
    }

/SecRule / {
    sub("$", " \"chain\"")
    print "   "$0;
    print "   SecRule REQUEST_HEADERS:X-Forwarded-Host \""h"\" \"nolog\""
    print ""
    first=1

    }
