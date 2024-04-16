/^#/ {next}
/SecRule / && !/id:/ {sub("\" *$", ", id:0\"")}
/SecRule / && /chain/ {
    sub("id:[0-9]+ *","id:"i"")
    print $0;
    i++;
    next}
/SecRule / {

    sub("\" *$", ",chain\"")
    sub("id:[0-9]+ *","id:"i"")
    print $0;
    print "   SecRule REQUEST_HEADERS:X-Forwarded-Host \""h"\" \"nolog\""
    print ""
    i++}
