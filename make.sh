get-link() {
    grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"'
}

download() {
   for i in $(curl https://instantos.surge.sh/ | get-link | grep -Eo '"(.*xz)"' | tr -d '"')
   do
       if [ ! -f "$i" ] ; then
	   wget "https://instantos.surge.sh/$i"
       fi
   done
}

unpack() {
    for f in $(find . -name '*.xz')
    do
        tar xvf "$f" | tee file_list.txt
    done
}

"$@"
