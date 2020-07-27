download() {
   for i in $(curl https://instantos.surge.sh/ | link | grep -Eo '"(.*xz)"' | tr -d '"')
   do
       wget "https://instantos.surge.sh/$i"
   done
}

unpack() {
    for f in $(find . -name '*.xz')
    do
        tar xvf "$f" | tee file_list.txt
    done
}

"$@"
