counter=1
echo "${counter}"

curl --header "Content-Type: application/x-www-form-urlencoded" --request POST --data 'seq1=CESENATICO&seq2=GATTOLINO' http://0.0.0.0:3000/submit

echo " "

while read sequenza1 sequenza2 ; do
  if [[ -n ${sequenza1} && -n ${sequenza2} ]] ; then
		((counter=${counter}+1))
		echo "${counter}"

		curl --header "Content-Type: application/x-www-form-urlencoded" --request POST --data 'seq1='${sequenza1}'&seq2='${sequenza2} http://0.0.0.0:3000/submit

		echo " "
	fi
done < datainput.txt


