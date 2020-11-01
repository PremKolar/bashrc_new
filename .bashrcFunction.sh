function rr()
{
	redshift -x	
	if [ -z "$1" ]
        then
                use=2400
	else
		use=$1
        fi
	if [ -z "$2" ]
        then
                bright=1
	else
		bright=$2
        fi
	redshift -O $use -b $bright
	echo $1 > ~/.redshiftTemp
	echo $2 > ~/.redshiftBright
}
function rrd(){
	lastCol=$(cat ~/.redshiftTemp)
	lastBri=$(cat ~/.redshiftBright)
	echo $lastCol
	echo $(expr $lastCol - 100)
	rr $(expr $lastCol - 100) $lastBri
}
function rru(){
	lastCol=$(cat ~/.redshiftTemp)
	lastBri=$(cat ~/.redshiftBright)
	echo $lastCol
	echo $(expr $lastCol - 100)
	rr $(expr $lastCol + 100) $lastBri
}
function cpToOtherRuns()
{

	root="/scratch/uni/ifmto/u300065/FINAL/"
	F="$1"

	echo cp $F $root"aviI/"$F
	echo cp $F $root"aviII/"$F
	echo cp $F $root"pop7II/"$F
	echo cp $F $root"p2aII/"$F

	cp $F $root"aviI/"$F &
	cp $F $root"aviII/"$F &
	cp $F $root"pop7II/"$F &
	cp $F $root"p2aII/"$F &

}
# ==================================
function jamjam()
{
	nup=$1
	typ=$2

	a=aviII
	b=aviI
	c=p2aII
	d=pop7II
	pdfjam --nup "$nup" "$typ-$a".pdf "$typ-$b".pdf "$typ-$c".pdf "$typ-$d".pdf -o "$typ".pdf
	pdfcrop --margins "1 1 1 1" --a4paper "$typ".pdf "$typ".pdf

}
# ==================================
function sumcpu()
{
	total=0
	top -u u300065 -b -n 1 | grep u300065 | while read a b c d e f g h i j k l
	do
		#echo $j
		#echo $total + $j | bc
		total=`echo $total + $i | bc`
		echo $total
	done
}
# ==================================
function sumtop()
{
	total=0
	top -u u300065 -b -n 1 | grep u300065 | while read a b c d e f g h i j k l
	do
		#echo $j
		#echo $total + $j | bc
		total=`echo $total + $j | bc`
		echo $total
	done
}
# ==================================
function texclean()
{
	rm *.blg
	rm *.dvi
	rm *.aux
	rm *.bbl
	rm *.log
	rm *.out
	rm *.toc
}
# ==================================

function killbeep()
{
	xset b off
	set bell-style none
}
# ==================================
function insttexpack()
{
	ls --color=never *.ins | while read ins
	do
		latex $ins
	done

	ls --color=never *.dtx | while read dtx
	do
		latex $dtx
	done
	mktexlsr --verbose .
	texhash .
}
# ==================================
function YO()
{
	rm yo.pdf
	pdfjam -o yo.pdf *.pdf
	pdfcrop --a4paper yo.pdf yo.pdf
	okular yo.pdf &
}
# ==================================
function mu()
{
	cplay /home/niko/music
}
# ==================================
function pdfFlatten()
{
pdf2ps $1 - | ps2pdf - "${1%.*}_flat.pdf"
}
# ==================================
function pdfFlattenAll()
{
	ls --color=never *.pdf | while read pdf
	do
		echo "$pdf"
		pdfFlatten "$pdf"
		mv "$pdf" "${pdf%.*}_ori.pdf"
		mv "${pdf%.*}_flat.pdf" "$pdf"
	done
}
# ==================================
function giui()
{
	cp INPUT.m ../
	git pull
	mv ../INPUT.m .
}
# ==================================
function gimi()
{
	cp INPUT.m ../
	git merge $1
	mv ../INPUT.m .
}
# ==================================
function pdfi()
{
	pdftk $1 dump_data
	pdftk $1 unpack_files
}
# ==================================
function klm()
{
	killall -u u300065 MATLAB
	killall -u u300065 matlab
	rm ~/matlab_crash_dump.*
}
# ==================================
function GICU()
{
	git add *.m
	git add SUBS/*.m
	git commit -a -m 'auto commit before refresh'
	#cp INPUT*.m Sall.m ../
	branchfromdir=`echo ${PWD##*/}`
	echo $branchfromdir
	git branch | while read line
	do
		if [[ $line == "*"* ]];
		then
			bra="${line:2:20}"
		else
			bra=$line
		fi
		echo $bra
		git checkout $bra
		git pull
	done
	git checkout $branchfromdir
	#mv ../INPUT*.m ../Sall.m .
	#git commit -a -m 'auto commit after refresh'
	#git push
	#git branch
}
# ==================================
function gicu()
{
for var in "$@"
	do
	git checkout "$var"
git pull
done
}
# ==================================
function jpeg2mov()
{
	echo taking all jpegs from here
	echo example
	echo "jpeg2mov 30 outFileName"
mencoder "mf://*.jpeg" -mf fps="${1}" -o "${2}".avi  -ovc lavc -lavcopts vcodec=ljpeg
}
# ==================================
function trimmov()
{
	echo example
	echo "trimmov in.avi 00:00:20 00:01:20 out.avi -oac copy  -ovc copy   vcodec=ljpeg"
mencoder  "${1}" -ss "${2}" -endpos "${3}" -o "${4}" -oac copy  -ovc copy   vcodec=ljpeg
}
# ==================================
function TOP()
{
echo lsof:
echo --------------------------------
lsof
sleep 1s
echo netstat:
echo --------------------------------
netstat
sleep 1s
echo vmstat:
echo --------------------------------
vmstat
sleep 1s
echo iostat:
echo --------------------------------
iostat
sleep 1s
echo procinfo:
echo --------------------------------
procinfo
sleep 1s
echo mpstat -P ALL:
echo --------------------------------
mpstat -P ALL
sleep 1s
echo sar
echo --------------------------------
sar
sleep 1s
echo df -h
echo --------------------------------
df -h
}
# ==================================
function zzz()
{
while true
do
	#date
	ls -hltr
	sleep 1s
done
}
# ==================================
function lu()
{
	if [ -z $2 ]; then
		ls -lhtr  | grep "$1"
	else
		ls -lhtr "$2" | grep "$1"
	fi
}
# ==================================
function lul()
{
	lu $1 "--color=never" | while read line
	do
		[ -z "$line" ] && continue
		echo ${line##* }
	done
}
# ==================================
function luld()
{
	lul $1
	echo "delete? [1/0]"
	read del
	if  [ $del -eq 1 ]; then
		lul $1 | while read line;do
			echo deleting "$line"
			rm -r $line
		done
	fi
}
# ==================================
function shrinkpdf ()
{
	if [ -z "$2" ]
	then
		echo choose dpi:
		echo "1 for 72 dpi"
		echo "2 for 150 dpi"
		echo "3 for 300 dpi"
		echo "4 for 300 dpi color preserving"
		read dpiOption
	else
		dpiOption=$2
	fi

	case $dpiOption in
		1)
		dpimode=screen
		;;
		2)
		dpimode=ebook
		;;
		3)
		dpimode=printer
		;;
		4)
		dpimode=prepress
		;;
	esac
	gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/${dpimode} -sOutputFile="${1%.*}_shrunk2${dpimode}.pdf" "$1"
}
# ==================================
function pdfsearch()
{
    find . -iname '*.pdf' | while read filename
    do
        #echo -e "\033[34;1m// === PDF Document:\033[33;1m $filename\033[0m"
        pdftotext -q -enc ASCII7 "$filename" "$filename."; grep -s -H --color=always -i $1 "$filename."
        rm -f "$filename."
    done
}
# ==================================
function cal()
{
	last=$1
        if [ -z "$1" ]
        then
                last=1
        fi
        path=`pwd`
        lastFile=${path}/`ls -tr --color=never  | tail -n ${last} | head -n 1`
        cat $lastFile
}
# ==================================
function gly() {
if [[ $# -eq 0 ]]; then
  echo "Usage: $(basename $0) music_file.mp3"
  exit 1
fi
FILE="$1"
ALBUM="$( id3ren -showtag "$FILE" |sed -n 's/Album[^:]*: *//p' )"
ARTIST="$( id3ren -showtag "$FILE" |sed -n 's/Artist[^:]*: *//p' )"
outname=`echo $ALBUM | sed 's/ /_/g'`
outfile=`dirname ${FILE}`/${outname}.png
echo $outfile
glyrc cover --artist "$ARTIST" --album "$ALBUM" -w ./tempcoverart
convert ./tempcoverart $outfile
rm ./tempcoverart
}
# ==================================
function rmsmalldir(){
du -k --max-depth=1 ./ | while read size dirname; do
	if [ $size -lt $1 ]; then
	echo $dirname $size is under $1 kB
fi
done
echo ctrl+c to cancel, enter to delete
read deldirs
du -k --max-depth=1 ./ | while read size dirname; do
	if [ $size -lt $1 ]; then
	echo deleting $dirname
	rm -r $dirname
fi
done
}
# ==================================
function rmlargefiles(){
	ls -lS --block-size=KB
	echo enter threshold in kB as variable
	ls -l --color=never | while read a b c d size e f g filename
	do
		if [[ -z $c ]]
		then
			echo $a $b
			echo going to delete:
		else
			if [[ "$size"/1000 -gt "$1"  ]]
			then
				ls -hl "$filename"
			fi
		fi
	done
	echo ctrl+c to cancel, enter to delete
	sleep 5s
	ls -l --color=never | while read a b c d size e f g filename
	do
		if [[ -z $c ]]
		then
			echo  " "
		else
			if [[ "$size"/1000 -gt "$1"  ]]
			then
				echo deleting "$filename"
				rm "$filename"
			fi
		fi
	done
}
# ==================================
function rmsmallfiles(){
	ls -lS --block-size=KB
	echo enter threshold in kB as variable
	ls -l --color=never | while read a b c d size e f g filename
	do
		if [[ -z $c ]]
		then
			echo $a $b
			echo going to delete:
		else
			if [[ "$size"/1000 -le "$1"  ]]
			then
				ls -hl "$filename"
			fi
		fi
	done
	echo ctrl+c to cancel, enter to delete
	sleep 5s
	ls -l --color=never | while read a b c d size e f g filename
	do
		if [[ -z $c ]]
		then
			echo  " "
		else
			if [[ "$size"/1000 -le "$1"  ]]
			then
				echo deleting "$filename"
				rm "$filename"
			fi
		fi
	done
}
# ==================================
function diffn()
{
	diff -B -I % -b -w -E $1 $2
}
# ==================================
function  mpl()
{
	if [ -z $1 ]; then
		find ~/videos/ -type f -iname '*' | sed 's/.*\///g'
		find ~/videos/ -type f -iname '*' >> .mpltemp
		echo --------------------------------------
	else
		for var in "$@"
		do
			echo FOR $var FOUND:
			echo '...'
			find ~/videos/ -type f -iname '*'"${var}"'*' | sed 's/.*\///g'
			find ~/videos/ -type f -iname '*'"${var}"'*' >> .mpltemp
			echo --------------------------------------
		done
	fi
	echo enter to play
	read p
	if [ -z $p ]; then
		mplayer `cat .mpltemp`
	fi
	rm .mpltemp
}
# ==================================
function GG()
{
	geany "$1" &
}
# ============s======================
function tc()
{
	tar -cvzf $1.tar.gz $2
}
# ==================================
function nml() {
#nohup /sw/squeeze-x64/matlab-r2013a/bin/matlab -nodisplay < $1 > $2 2>&1 &
nohup /sw/squeeze-x64/matlab-r2014b/bin/matlab -nodisplay < $1 > $2 2>&1 &
sleep 1s
~/.pythonFunctions.py mtlog $2
}
# ==================================
function dd() {
	 ls -dhltr $1*/;
}
# ==================================
function k() {
echo $1
if [ -z "$1"  ]
then
        ls -hlt --color | grep ^-;
else
        ls -hlt *$1* --color  | grep ^-;
fi
}
# ==================================
function kk() {
echo $1
if [ -z "$1"  ]
then
        ls -hltr --color | grep ^-;
else
        ls -hltr *$1* --color  | grep ^-;
fi
}
# ==================================
function ml() {
/usr/share/matlab/bin/matlab  &
}
# ==================================
function ii () {
sudo apt-get -f -y  install $1
}
# ==================================
function II () {
sudo apt-get  -y check
sudo apt-get  -y clean
sudo apt-get  -y  install
sudo apt-get  -y  update
sudo apt-get  -y  upgrade
sudo apt-get  -y  dist-upgrade
sudo apt-get  -y check
sudo apt-get  -y autoclean
sudo apt-get  -y autoremove
}
# ==================================
function uu () {
sudo apt-get -f -y  remove --purge $1
}
# ==================================
function UU () {
sudo apt-get -f -y  purge --purge $1
}
# ==================================
function oo () {
okular *$1*.pdf &
}
# ==================================
function hh () {
	if [ -z $1 ]
	then
		history | sed '/ hh /d'
	else
		history | sed '/ hh /d' | grep $1
	fi
	if [ -z $2 ]
	then
		return
	fi
	todo=`hh $1 | tail -n $2 | head -n 1 | sed -r 's/^\s*[[:digit:]]+\s*//' | sed -e :a -e N -e '$!ba' -e 's/\n/ /g'`
	eval $todo
}
# ==================================
function padz () {
rename 's/\d+/sprintf("%0'${1}'d",$&)/e' $2*
}
# ==================================
function mkdircd () {
	 mkdir -p "$@" && eval cd "\"\$$#\"";
	 }
# ==================================
function txl () {
 last=$1
        if [ -z "$1" ]
        then
                last=1
        fi
        path=`pwd`
        last_gz=${path}/`ls -tr --color=never *.gz | tail -n ${last} | head -n 1`
        tar -xvzf $last_gz

}
# ==================================
function cdl () {
	last=$1
	if [ -z "$1" ]
	then
		last=1
	fi
	path=`pwd`
	last_dir=${path}/`ls -dtr --color=never */ | tail -n ${last} | head -n 1`
	cd $last_dir
}
# ==================================
function okl () {
	last=$1
	if [ -z "$1" ]
	then
		last=1
	fi
	last_pdf=`ls -htr --color=never ./*.pdf | tail -n ${last} | head -n 1`
	echo $last_pdf
	okular $last_pdf &
}
# ==================================
function gkl () {
	last=$1
	if [ -z "$1" ]
	then
		last=1
	fi
	last_png=`ls -htr --color=never ./*.png | tail -n ${last} | head -n 1`
echo $last_png
	eog $last_png &
}
# ==================================
function vf () {
	dr=$1
	if [ -z "$1" ]
	then
		dr=' '
	fi
	cd $dr
	numf=`  ls -hltr | grep ^- | wc -l`
	numd=`ls -hltr | grep ^d | wc -l`

	if [ $numd -gt 10 ]
	then
		echo ....
	fi
	if [ "$numd" -eq 0 ]
	then
		echo  empty
	else
		ls -hltr | grep ^d
	fi
	echo $numd directories

	if [ $numf -gt 10 ]
	then
		echo ...
	fi
	ll | grep ^- | tail -n 10
	echo $numf files
	pwd
}
# ==================================
function conro () {
	convert -rotate 90 $1 rot_$1
}
# ==================================
function cutshrunkName () {
ls --color=never *pdf | while read line
do
	echo $line
	mv $line "${line%_shrunk*}.pdf"
done
}
# ==================================
function all2smallpng () {
	function convop()
	{
		line=$1
		outf=$2
		pgs=`pdfinfo $line | grep Pages | grep -oE '[^ ]+$' `
		fsize=`pdfinfo $line | grep "File size" | grep -oE '[^ ]+$' | sed -r 's/^[^0-9]*([0-9]+).*/\1/'`
		if [[ "$pgs" -eq 1 ]]; then
			if [[ "$fsize" -lt 2000000 ]]; then
				ls -l "$line"
				convert -density 90x90 -resize 800x  "$line" $outf
				pwd > ${line%.*}.txt
				annoArg="${line%.*}.txt"
				echo -n "$line" >> ${line%.*}.txt
				convert $outf -pointsize 16 -gravity SouthWest -annotate 0 @$annoArg 	$outf
				rm ${line%.*}.txt
				ls -l "$line"  >  ${line%.*}.txt
				convert $outf -pointsize 16 -gravity NorthWest -annotate 0 @$annoArg 	$outf
				rm ${line%.*}.txt
				mv $outf pngs/
			fi
		fi
	}
	#----------------
	mkdir -p pngs
	find . -name '*.pdf' | while read line;	do
		outf="${line%.*}APNG.png"
		outf="${outf##*/}"
		if [ ! -f $outf ]
		then
			ls $line
			convop $line $outf &
		fi
	done
}
# ==================================
function any2pdf () {
resX=2490
convert -density 300x300 -resize ${resX}x -quality 100 +repage $1  "${1%.*}.pdf"
}
# ==================================
function any2pdfviaPS () {
	fname=${1%.*}
	convert -trim  -density 300x300 -resize 2490x -quality 100 +repage $1 $fname.pdf
	pdf2ps $fname.pdf $fname.ps
	ps2pdf $fname.ps $fname.pdf
	pdfcrop $fname.pdf $fname.pdf
	rm ${1%.*}.ps
	echo created $fname.pdf from $1
}
# ==================================
function ff() {
	 find . -iname '*'"$*"'*'
 }
# ==================================
function my_ip() {
    MY_IP=$(/sbin/ifconfig eth0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo ${MY_IP:-"Not connected"}
}
# ==================================
function MM() {
killall  -q mpg123
mroot=/home/niko/music
cd $mroot
playlist=${mroot}/f11pl.m3u
artistf=${mroot}/artist.txt
trackf=${mroot}/track.txt
fnf=${mroot}/filename.txt
fnfa=${mroot}/filenameAlt.txt
rm -f $playlist $artistf $trackf $fnf
if [ -z "$1" ]
then
	find . -type f -iname "*.mp3" > ${playlist}
else
	find . -type f -iname "*${1}*.mp3" >> ${playlist}
	find . -type d -iname "*${1}*"  | while read line; do
		cd $line
		find `pwd` -type f -iname "*.mp3" >> ${playlist}
		cd $mroot
	done
fi
plShuff=${mroot}/f11plShuff.m3u
pltmp=${mroot}/pltmp.txt
NextSong=${mroot}/NextSong
rm -f $pltmp $plShuff
more $playlist | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);' >$plShuff
more $plShuff | head -n 5 >> $plShuff

cc=1
dd=0
cat $plShuff | while read line; do
	echo $(id3v2 -R $line | grep TPE1 | sed 's/TPE1: //g') - $(id3v2 -R $line | grep TIT | sed 's/TIT.*: //g') >> $pltmp
	if [ "$cc" -gt "1" ]; then
		clear
		linec=$(cat $plShuff | head -n $dd  | tail -n 1)
		echo "-->" $(id3v2 -R $linec | grep TPE1 | sed 's/TPE1: //g') - $(id3v2 -R $linec | grep TIT | sed 's/TIT.*: //g')
		echo next:
		cat $pltmp | tail -n 1
		cat $pltmp | tail -n 1  > $NextSong
		id3v2 -R $linec | grep TIT | sed 's/TIT.*: //g' > $trackf
		id3v2 -R $linec | grep TPE1 | sed 's/TPE1: //g'> $artistf
		id3v2 -R $linec | grep Filename | sed 's/Filename: \.\///g'  > $fnf
		echo $linec > ${fnfa}
		mpg123 -q $linec
	fi
	cc=$((cc+1))
	dd=$((dd+1))
done
}
# ==================================
function shuffle()
{
	cat $1 | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);'
}
# ==================================
function ytd()
{
	echo usage: ytd nameOfOutDir youtubePassWord
	musicbase=/home/niko/music/youtuberips
	videobase=/home/niko/videos/youtuberips
	tempdir=/home/niko/ytdTemp$( date +%H%M%S )
	echo using temp dir $tempdir
	mkdir $tempdir
	mkdir -p $musicbase
	mkdir -p $videobase
	echo "This script is useful when you want to download and rip a complete Youtuble playlist into mp3"
	NAME=$1
	music=${musicbase}/${NAME}
	video=${videobase}/${NAME}
	mkdir -p $music
	mkdir -p $video
	echo "Enter the Youtube playlist URL to begin the process (e.g: http://www.youtube.com/playlist?list=PL3DFF2F30C0A04640 ):"
	read PL
	pw=$2
	cd $tempdir
	youtube-dl -i -u nikolauskoopmann -p "$pw" -o '%(stitle)s.%(ext)s' $PL
	for i in *.flv; do
		ffmpeg -i "$i" -acodec libmp3lame -vn -ar 44100 -ac 2 -ab 192k "${i%flv}mp3";
	done
	for i in *.mp4; do
		ffmpeg -i "$i" -acodec libmp3lame -vn -ar 44100 -ac 2 -ab 192k "${i%mp4}mp3";
	done
	mv -f *.mp3 $music
	mv -f *.mp4 *.flv $video
	cd .. && rm -rf $tempdir
	echo "Conversion finished!"
}
# ==================================
function mp4tomp3() {
dir=$1
for f in ${dir}/*.mp4
do
    name=`echo "$f" | sed -e "s/.mp4$//g"`
    ffmpeg -i "$f" -vn -ar 44100 -ac 2 -ab 192k -f mp3 "$name.mp3"
done
}
# ==================================

function any2mp3() {
	#any2mp3.sh file.mp4 another-file.wma yet-another.file.ogg
	# Converts to mp3 anything mplayer can play
	# Needs mplayer amd lame installed
	[ $1 ] || { echo "Usage: $0 file1.wma file2.wma"; exit 1; }

	for i in "$@"
	do
	    [ -f "$i" ] || { echo "File $i not found!"; exit 1; }
	done

	[ -f audiodump.wav ] && {
	    echo "file audiodump.wav already exists"
	    exit 1
	}

	for i in "$@"
	do
	    ext=`echo $i | sed 's/[^.]*\.\([a-zA-Z0-9]\+\)/\1/g'`
	    j=`basename "$i" ".$ext"`
	    j="$j.mp3"
	    echo
	    echo -n "Extracting audiodump.wav from $i... "
	    mplayer -vo null -vc null -af volnorm=1 -af resample=44100 -ao pcm:waveheader:fast \
	    "$i" >/dev/null 2>/dev/null || {
	        echo "Problem extracting file $i"
	        exit 1
	    }
	    echo "done!"
	    echo -n "Encoding to mp3... "
	    lame -m s audiodump.wav -o "$j" >/dev/null 2>/dev/null
	    echo "done!"
	    echo "File written: $j"
	done
	# delete temporary dump file
	rm -f audiodump.wav
}
# ==================================
function swap_ext() {
for f in *.${1}
do
	base=`basename $f .${1}`
mv $f $base.${2}
done
}
# ==================================
function br() {
bright=$1
if [ $bright -lt 0 ];
then
bright=0
fi

if [ $bright -gt 1 ];
then
bright=1
fi
lastCol=$(cat ~/.redshiftTemp)
rr $lastCol $bright
}
# ==================================
function tar_small(){
	find $1  -size +${2}M > exclude.txt
	tar cvzf ${3}.tar.gz -X exclude.txt $1
}
# ==================================
function tar_small_up(){
	tag=date +%y%m%d
	tar_small $1 $2 $3
	scp $3$tag.tar.gz $4
}
# ==================================
function acidrip(){
	cd /home/niko/scripts/acidrip-0.14
	./acidrip
}
# ==================================
function trspace() {
   dir="${1}"
   find "${dir}" -iname $'*[ &()öäü\t\r\n\v\f]*' | while read line; do
	name="${line}"
	newname="${name//[[:space:]]/_}"
	newname="${newname//ö/oe}"
	newname="${newname//Ö/Oe}"
	newname="${newname//Ä/Ae}"
	newname="${newname//ä/ae}"
	newname="${newname//ü/ue}"
	newname="${newname//U/Ue}"
	newname="${newname//ß/ss}"
	newname="${newname//&/and}"
	echo old: $name
	echo new: $newname
	if [[ -e "${newname}" ]]; then
		echo Warning: file already exists: ${newname}
		mv "${name}" "${newname}"
else
		mv "${name}" "${newname}"
	fi
done
}
# ==================================
function spacetr() {
   dir="${1}"
   find "${dir}" -xdev -depth -name "*.*" | while read line; do
	name="${line}"
	newname="${name//_/ }"
	echo old: $name
	echo new: $newname
	mv "${name}" "${newname}"
done
}
# ==================================
function sy() {
sudo synaptic &
sleep 1
echo ro
}
# ==================================
function cp_pat {
if [ -z "$1" ]
	then
	echo "usage: cp_pat from_dir pattern with wildcards to_dir"
fi
find  $1 -type f -iname "${2}" | while read line; do
	FN=$(basename "$line")
	echo copying $FN
		cp $line $3
done
}
# ==================================
function mt(){
	more $1 | tail -n 500
}
# ==================================
function ak(){
killall autokey
nohup autokey &
}
# ==================================
function lll(){
if [ -z $1 ]; then
	md="*"
else
md=$1
fi
ls -hltr
ls $md | wc
du -h  . --exclude "./.*" --max-depth=1
pwd
}
# ==================================
function LLL(){

lll

ls -d --color=never */ | while read line
do
	echo  `ls $line | wc -l`	 files in $line
done
pwd
}
# ==================================
function epstopdfall() {
for ii in *.eps; do
echo $ii
epstopdf "$ii"
done
}
# ==================================
function xx()
{
if [ -z "$1" ]
then
delay=200
else
delay=$1
fi
if [ -z "$2" ]
then
rate=60
else
rate=$2
fi
echo xset r rate $delay $rate
xset r rate "$delay" "$rate"
}
# ==================================
