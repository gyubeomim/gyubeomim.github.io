git add . -A
if [ -z "$1" ]
then
	git commit -m "$(date +%Y%m%d) from Windows" 
else
	git commit -m "$1" 
fi
git push origin master
