#!/bin/bash

# Extract all URLs, clear out the ones with "autoplay" and remove doubles
wget https://www.ynetnews.com/category/3082
grep -E -o "https://www.ynetnews.com/article/.................." 3082 > urls
grep -v "autoplay" urls > urls_no_autoplay
grep -E -o "https://www.ynetnews.com/article/........." \
urls_no_autoplay > urls_doubles
cat urls_doubles | sort | uniq > urls_clean

# Count the urls
url_cnt=$(wc -l < urls_clean)
echo $url_cnt > results.csv


# Pop the urls and count Netanyahu and Gantz in each
while [[ -s urls_clean ]]; do

	tmp_url=$(head -n 1 urls_clean)
	wget $tmp_url
	grep -E -o "Netanyahu"  ${tmp_url: -9} > tmp
	Netanyahu_cnt=$(wc -l < tmp)
	grep -E -o "Gantz"  ${tmp_url: -9} > tmp
	Gantz_cnt=$(wc -l < tmp)
	rm ${tmp_url: -9}
	
	if [[ "${Netanyahu_cnt}" = 0 ]] && [[ "${Gantz_cnt}" = 0 ]]; then
		echo "$tmp_url, -" >> results.csv
	else
		echo "$tmp_url, Netanyahu, $Netanyahu_cnt, Gantz, $Gantz_cnt" >> results.csv
	fi

	sed -i 1d urls_clean
done

# Clean all the temporary files 
rm tmp urls 3082 urls_no_autoplay urls_clean urls_doubles



