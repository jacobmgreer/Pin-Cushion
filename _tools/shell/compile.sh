cd Documents/GitHub/Pin-Cushion

for FILE in $(find boards -mindepth 1 -maxdepth 3 -type f -name "*.png" -o -name "*.PNG" -o -name "*.jpeg" -o -name "*.JPEG") 
do 
  magick mogrify -format jpg $FILE;
  echo "REFORMAT $(echo $FILE)"
  rm $FILE
done

for FILE in $(find boards -mindepth 1 -maxdepth 3 -type f -not -path '*/.*' -not -path '*.md')
  do OFname=${${FILE##*/}%%.*}

	if [[ ${#OFname} != 75 ]] then
	  FILENAME=$(identify -quiet -format '%#' $FILE)
		EXT=${FILE##*.}
		mv $FILE "boards/$(echo $FILE | cut -d '/' -f 2)/$(echo $FILE | cut -d '/' -f 3)/$(date +%F)-$(echo $FILENAME).$(echo $EXT)";
	  echo "RENAME $(echo $FILE | cut -d '/' -f 2)/$(echo $FILE | cut -d '/' -f 3)/$(date +%F)-$(echo $FILENAME).$(echo $EXT)"
	fi
done

for FILE in $(find boards -mindepth 1 -maxdepth 3 -type f -not -path '*/.*' -not -path '*.md') 
do
  if [ ! -f "assets/img/thumbs/$(echo ${${FILE##*/}%%.*}).png" ] 
    then qlmanage -t -o "assets/img/thumbs" -s 200 $FILE;
  fi
done

for FILE in $(find assets/img/thumbs -mindepth 1 -maxdepth 1 -name \*.jpg.png)
	do mv $FILE assets/img/thumbs/${${FILE##*/}%%.*}.png;
done

rm -r board

for BOARD in $(find boards -mindepth 2 -maxdepth 2 -type d)
  do mkdir -p board/$(echo $BOARD | cut -d '/' -f 2)/$(echo $BOARD | cut -d '/' -f 3)
    sh _tools/shell/template-board.sh $BOARD > "board/$(echo $BOARD | cut -d '/' -f 2)/$(echo $BOARD | cut -d '/' -f 3)/index.md"
done 

rm -r _posts
mkdir -p _posts

for FILE in $(find boards -mindepth 1 -maxdepth 3 -type f -not -path '*/.*' -not -path '*.md' )

do printf "---
layout: pin
category: $(echo $FILE | cut -d '/' -f 2)
tag: $(echo $FILE | cut -d '/' -f 3)
image: $FILE
---" > "_posts/${${FILE##*/}%%.*}.md"
done