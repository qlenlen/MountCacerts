if [ -d /apex/com.android.conscrypt/cacerts ]; then
    ui_print "Supported A14+"
else
    ui_print "Only support A14+"
    abort "***************"
fi