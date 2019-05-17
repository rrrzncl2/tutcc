#関数群
#######################################################

#エスケープシーケンス入りの画像ファイルの変換
#第一引数：エスケープシーケンスの文字　第二引数：変換する拡張子
convertEscape () {
	ast="*"

	if [[ $i == ${ast}${1}${ast} ]]
	then
		echo -n "" >  temp

		echo "${i}" | while read -n 1 num
		do
			echo -n ${num} >> temp

			if [ "${num}" = "" ] || [ "${num}" = "${1}" ]
			then
				if read -n 1 num
				then
					echo -n \\ >> temp
					echo -n \ >> temp
					echo -n ${num} >> temp
				fi
			fi
		done

		fn=`cat temp`
		com="convert -alpha Remove -density 100 "
		sp=" "
		fl="./EPS/"

		pic=${fn%.${2}}.eps
		text=${com}${fn}${sp}${fl}${pic}
		echo $text | bash >/dev/null 2>&1

		return 0
	else
		return 1
	fi
}


#画像変換関数
#第一引数：変換する拡張子
convertImage () {
	wc="*."

	for i in ${wc}${1}
	do
		echo converting $i

		#エスケープシーケンスを含む画像の変換
		convertEscape " " ${1}

		if [ $? -eq 1 ]
		then
			convert -alpha Remove -density 100 $i ${i%.${1}}.eps >/dev/null 2>&1
			mv ${i%.${1}}.eps ./EPS
		fi

	done
}

#######################################################

#mainルーチン
dir=`dirname "$0"`
cd "${dir}"

echo
echo Now dir
pwd
echo

#EPSフォルダの作成
if [ ! -d EPS ]
then
	echo making EPS Folder
	echo
	mkdir EPS
fi


#jpgの変換
if ls *.jpg >/dev/null 2>&1
then
	convertImage jpg
fi

if ls *.JPG >/dev/null 2>&1
then
	convertImage JPG
fi

#pngの変換
if ls *.png >/dev/null 2>&1
then
	convertImage png
fi

if ls *.PNG >/dev/null 2>&1
then
	convertImage PNG
fi

#pdfの変換
if ls *.pdf >/dev/null 2>&1
then
	convertImage pdf
fi

#tempファイルの消去
if [ -e temp ]
then
	rm temp
fi

echo END
echo

sleep 3s
