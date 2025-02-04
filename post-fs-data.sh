MODDIR=${0%/*}

set_perm() {
  chown $2:$3 $1 || return 1
  chmod $4 $1 || return 1
  local CON=$5
  [ -z $CON ] && CON=u:object_r:system_file:s0
  chcon $CON $1 || return 1
}

set_perm_recursive() {
  find $1 -type d 2>/dev/null | while read dir; do
    set_perm $dir $2 $3 $4 $6
  done
  find $1 -type f -o -type l 2>/dev/null | while read file; do
    set_perm $file $2 $3 $5 $6
  done
}


if [ -d /apex/com.android.conscrypt/cacerts ]; then
	tmp_cacerts_dir=$MODDIR/conscrypt_cacerts
	mkdir -p $tmp_cacerts_dir
	rm $tmp_cacerts_dir/*
 	cp -f /system/etc/security/cacerts/* $tmp_cacerts_dir/
	cp -f /apex/com.android.conscrypt/cacerts/* $tmp_cacerts_dir/
	cp -f /data/misc/user/0/cacerts-added/* $tmp_cacerts_dir/
	set_perm_recursive $tmp_cacerts_dir root shell 755 644 u:object_r:system_security_cacerts_file:s0
	mount --bind $tmp_cacerts_dir /apex/com.android.conscrypt/cacerts
fi
